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
