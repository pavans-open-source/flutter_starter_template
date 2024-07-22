#!/bin/bash

FEATURE_FOLDER="lib/features"

if [ -z "$1" ]; then
  echo "Usage: $0 <feature_name>"
  exit 1
fi

FEATURE_PATH="$FEATURE_FOLDER/$1"

to_camel_case() {
    local string="$1"
    local camel_case=""

    IFS=' _-' read -ra words <<< "$string"

    for i in "${!words[@]}"; do
        if [ $i -eq 0 ]; then
            camel_case="${words[i],,}"
        else
            camel_case="${camel_case}${words[i]^}"
        fi
    done

    echo "$camel_case"
}


capitalize_first_letter() {
    local string="$1"
    echo "$(tr '[:lower:]' '[:upper:]' <<< ${string:0:1})${string:1}"
}

camel_case=$(to_camel_case "$1")
class_camel_case=$(to_camel_case "$1")
capitalized_class_camel_case=$(capitalize_first_letter "$class_camel_case")

VIEW_TEMPLATE="import 'package:flutter/material.dart';
import '../controllers/${1}_screen_controller.dart';


class ${capitalized_class_camel_case}Screen extends StatefulWidget {
  const ${capitalized_class_camel_case}Screen({super.key});

  @override
  State<${capitalized_class_camel_case}Screen> createState() => _${capitalized_class_camel_case}ScreenState();
}

class _${capitalized_class_camel_case}ScreenState extends State<${capitalized_class_camel_case}Screen> {

    ${capitalized_class_camel_case}ScreenController ${camel_case}ScreenController = ${capitalized_class_camel_case}ScreenController();

    @override
    void initState() {
        ${camel_case}ScreenController.init();
        super.initState();
    }

    @override
    void dispose() {
        ${camel_case}ScreenController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context){
        return Scaffold(
            body: Container(),
        );
    }
}
"

CONTROLLER_TEMPLATE="import '../../../utils/controllers/feature_controller.dart';

class ${capitalized_class_camel_case}ScreenController extends FeatureController {

    @override
    void init(){}

    @override
    void dispose(){}
}
"

CUBIT_TEMPLATE="import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part '${camel_case}_screen_state.dart';

class ${capitalized_class_camel_case}ScreenCubit extends Cubit<${capitalized_class_camel_case}ScreenState> {
  ${capitalized_class_camel_case}ScreenCubit() : super(${capitalized_class_camel_case}ScreenInitial());
}
"

CUBIT_STATE_TEMPLATE="part of '${camel_case}_screen_cubit.dart';

@immutable
sealed class ${capitalized_class_camel_case}ScreenState {}

final class ${capitalized_class_camel_case}ScreenInitial extends ${capitalized_class_camel_case}ScreenState {}

"

if [ ! -f "pubspec.yaml" ]; then
    echo "Please run it from the project level directory..."
    exit 1
fi

if [ -d "$FEATURE_PATH" ]; then
    read -p "The feature '$1' already exists. Do you want to override it? (y/n): " choice
    case "$choice" in
        y|Y )
            echo "Overriding the existing feature..."
            ;;
        * )
            echo "Operation cancelled."
            exit 1
            ;;
    esac
fi

mkdir -p "$FEATURE_PATH/views"
mkdir -p "$FEATURE_PATH/controllers"
mkdir -p "$FEATURE_PATH/logic"
mkdir -p "$FEATURE_PATH/logic/${1}_cubit"
mkdir -p "$FEATURE_PATH/static"
mkdir -p "$FEATURE_PATH/static/assets"
mkdir -p "assets/${1}"
mkdir -p "assets/${1}/images"
mkdir -p "assets/${1}/icons"
mkdir -p "$FEATURE_PATH/static/network"
mkdir -p "$FEATURE_PATH/static/models"

echo "$VIEW_TEMPLATE" > "$FEATURE_PATH/views/${1}_screen.dart"
echo "$CONTROLLER_TEMPLATE" > "$FEATURE_PATH/controllers/${1}_screen_controller.dart"
echo "$CUBIT_TEMPLATE" > "$FEATURE_PATH/logic/${1}_cubit/${1}_screen_cubit.dart"
echo "$CUBIT_STATE_TEMPLATE" > "$FEATURE_PATH/logic/${1}_cubit/${1}_screen_state.dart"


echo "Feature '$1' has been created successfully."
