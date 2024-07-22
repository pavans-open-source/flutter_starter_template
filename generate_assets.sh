#!/bin/bash

# Function to capitalize the first letter of a string
capitalize() {
    echo "$1" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}'
}

to_camel_case() {
    local string="$1"
    local camel_case=""

    # Convert underscores to spaces and capitalize the first letter of each subsequent word
    IFS='_' read -ra words <<< "$string"

    for i in "${!words[@]}"; do
        if [ $i -eq 0 ]; then
            # Lowercase the first word
            camel_case="${words[i],,}"
        else
            # Capitalize subsequent words
            camel_case="${camel_case}$(capitalize "${words[i]}")"
        fi
    done

    echo "$camel_case"
}

update_pubspec() {
    local pubspec_file="pubspec.yaml"
    local temp_file="${pubspec_file}.tmp"
    local backup_file="${pubspec_file}.bak"

    # Check if pubspec.yaml exists
    if [ ! -f "$pubspec_file" ]; then
        echo "pubspec.yaml not found!"
        exit 1
    fi

    # Backup the original pubspec.yaml
    cp "$pubspec_file" "$backup_file"

    # Create a temporary file for updated content
    : > "$temp_file"

    # Flag to identify if we are in the flutter section
    in_flutter_section=false

    while IFS= read -r line; do
        # If we find the start of the flutter section, set the flag
        if [[ "$line" =~ ^[[:space:]]*flutter: ]]; then
            in_flutter_section=true
        fi

        # If we are in the flutter section and find assets, stop writing until we reach the end
        if $in_flutter_section && [[ "$line" =~ ^[[:space:]]*assets: ]]; then
            in_flutter_section=true
            # Skip lines until end of assets section
            while IFS= read -r inner_line; do
                if [[ "$inner_line" =~ ^[[:space:]]*$ ]]; then
                    break
                fi
            done
            continue
        fi

        # Write other lines to the temporary file
        echo "$line" >> "$temp_file"
    done < "$pubspec_file"

    # Add the new flutter and assets section
    echo "  assets:" >> "$temp_file"
    for feature in assets/*; do
        if [ -d "$feature" ]; then
            feature_name=$(basename "$feature")
            echo "    - assets/$feature_name/icons/" >> "$temp_file"
            echo "    - assets/$feature_name/images/" >> "$temp_file"
        fi
    done

    # Replace the old pubspec.yaml with the updated content
    mv "$temp_file" "$pubspec_file"

    echo "pubspec.yaml updated successfully."
}

# Iterate over each feature directory
for feature in assets/*; do
    if [ -d "$feature" ]; then
        feature_name=$(basename "$feature")
        capitalized_name=$(capitalize "$feature_name")
        echo "Feature name = $feature_name"
        output_file="lib/features/$feature_name/static/assets/${feature_name}_screen_assets.dart"

        # Ensure the output directory exists
        mkdir -p "$(dirname "$output_file")"

        # Start the Dart file with the class definition
        cat <<EOL > "$output_file"
class ${capitalized_name}ScreenAssets {
EOL

        # Add paths for icons
        for icon in "$feature"/icons/*; do
            if [ -f "$icon" ]; then
                filename=$(basename "$icon")
                basename="${filename%.*}"  # Remove file extension
                camel_case_name=$(to_camel_case "$basename")
                echo "${camel_case_name}"
                path="assets/$feature/icons/$filename"
                echo "  static const String $camel_case_name = '$path';" >> "$output_file"
            fi
        done

        # Add paths for images
        for image in "$feature"/images/*; do
            if [ -f "$image" ]; then
                filename=$(basename "$image")
                basename="${filename%.*}"  # Remove file extension
                camel_case_name=$(to_camel_case "$basename")
                                echo "${camel_case_name}"

                path="assets/$feature/images/$filename"
                echo "  static const String $camel_case_name = '$path';" >> "$output_file"
            fi
        done

        # End the Dart class definition
        cat <<EOL >> "$output_file"
}
EOL
    fi
done

update_pubspec