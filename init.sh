#!/bin/bash

# Initialize flavors

echo "Initializing Flavors"


# Check if pubspec.yaml exists in the specified directory
if [ ! -f "pubspec.yaml" ]; then
    echo "Error: pubspec.yaml not found in the directory $DIRECTORY." >&2
    exit 1
else
    echo "Running Flavorizr"
    dart run flutter_flavorizr
fi

# CURRENT_DIRECTORY=$(pwd)

# Check if the target folder exists, create if it does not
if [ ! -d "lib/flavors" ]; then

    echo "Flavors folder does not exist. Creating it..."
    mkdir -p "lib/flavors"

    echo "Moving flavor files to flavor folder..."
    mv -f lib/main*.dart "lib/flavors/"
    mv -f lib/flavors.dart lib/flavors/

    if [ $? -ne 0 ]; then
        echo "Error: Failed to create directory flavors." >&2
        exit 1
    fi
else
    echo "Moving flavor files to flavor folder..."
    mv -f lib/main*.dart "lib/flavors/"
    mv -f lib/flavors.dart lib/flavors/
fi