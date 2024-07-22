#!/bin/bash

# Initialize flavors
echo "Initializing Flavors"

# Define the directory where pubspec.yaml should be located
DIRECTORY="."

# Check if pubspec.yaml exists in the specified directory
if [ ! -f "$DIRECTORY/pubspec.yaml" ]; then
    echo "Error: pubspec.yaml not found in the directory $DIRECTORY." >&2
    exit 1
else
    # Check if Dart is available
    if ! command -v dart &> /dev/null; then
        echo "Error: Dart is not installed or not in the PATH." >&2
        exit 1
    fi

    # Check if flutter_flavorizr is available
    if ! dart pub global list | grep -q "flutter_flavorizr"; then
        echo "Error: flutter_flavorizr is not installed. Installing it." >&2
    else
        dart pub global activate flutter_flavorizr
    fi

    echo "Running Flavorizr"
    dart run flutter_flavorizr
fi

# Check if the target folder exists, create if it does not
if [ ! -d "lib/flavors" ]; then
    echo "Flavors folder does not exist. Creating it..."
    mkdir -p "lib/flavors"

    if [ $? -ne 0 ]; then
        echo "Error: Failed to create directory flavors." >&2
        exit 1
    fi
fi

# echo "Moving flavor files to flavor folder..."
# mv -f lib/main*.dart "lib/flavors/"
# mv -f lib/flavors.dart lib/flavors/

if [ $? -ne 0 ]; then
    echo "Error: Failed to move files to the flavors directory." >&2
    exit 1
fi

echo "Flavors initialized successfully."

export PATH="$PATH:$(pwd)"

# cleanup

rm -r lib/pages
rm lib/app.dart