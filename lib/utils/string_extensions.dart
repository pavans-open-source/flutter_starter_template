import 'package:validators/validators.dart' as validators;
import 'dart:convert';

extension StringUtils on String {
  // Checks if the string is a valid email address
  bool get isValidEmail {
    return validators.isEmail(this);
  }

  // Checks if the string is a valid URL
  bool get isValidUrl {
    return validators.isURL(this);
  }

  // Checks if the string is a valid phone number (basic validation)
  bool get isValidPhoneNumber {
    final regex = RegExp(r'^\+?[1-9]\d{1,14}$');
    return regex.hasMatch(this);
  }

  // Checks if the string is a valid credit card number
  bool get isValidCreditCard {
    return validators.isCreditCard(this);
  }

  // Checks if the string is a valid IPv4 address
  bool get isValidIPv4 {
    final regex = RegExp(
      r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
    );
    return regex.hasMatch(this);
  }


  // Checks if the string is a valid UUID (version 4)
  bool get isValidUUID {
    final regex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
    );
    return regex.hasMatch(this);
  }

  // Checks if the string is a valid JSON
  bool get isValidJson {
    try {
      final json = jsonDecode(this);
      return json is Map || json is List;
    } catch (e) {
      return false;
    }
  }

  // Checks if the string contains only alphabets (letters)
  bool get isAlphabet {
    final regex = RegExp(r'^[a-zA-Z]+$');
    return regex.hasMatch(this);
  }

  // Checks if the string contains only digits
  bool get isDigits {
    final regex = RegExp(r'^\d+$');
    return regex.hasMatch(this);
  }

  // Checks if the string is a valid password (at least 8 characters, with at least one letter and one number)
  bool get isValidPassword {
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    return regex.hasMatch(this);
  }

  // Capitalizes the first letter of each word
  String capitalizeEachWord() {
    return this
        .split(' ')
        .map((word) => word.isEmpty
            ? ''
            : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  // Capitalizes the first letter of the string
  String capitalizeFirstLetter() {
    if (this.isEmpty) return this;
    return this[0].toUpperCase() + this.substring(1).toLowerCase();
  }

  // Converts the string to title case
  String toTitleCase() {
    return this
        .split(' ')
        .map((word) => word.isEmpty
            ? ''
            : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  // Reverses the characters in the string
  String reverse() {
    return this.split('').reversed.join('');
  }

  // Checks if the string is a palindrome
  bool get isPalindrome {
    String reversed = this.reverse();
    return this == reversed;
  }

  // Removes all whitespace from the string
  String removeWhitespace() {
    return this.replaceAll(RegExp(r'\s+'), '');
  }

  // Truncates the string to a specified length and appends an ellipsis if necessary
  String truncate(int length, [String ellipsis = '...']) {
    if (this.length <= length) return this;
    return '${this.substring(0, length)}$ellipsis';
  }

  // Converts the string to snake_case
  String toSnakeCase() {
    return this
        .replaceAll(RegExp(r'([a-z])([A-Z])'), r'$1_$2')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();
  }

  // Converts the string to kebab-case
  String toKebabCase() {
    return this
        .replaceAll(RegExp(r'([a-z])([A-Z])'), r'$1-$2')
        .replaceAll(RegExp(r'\s+'), '-')
        .toLowerCase();
  }

  // Checks if the string contains only letters and numbers
  bool get containsOnlyLettersAndNumbers {
    final regex = RegExp(r'^[a-zA-Z0-9]+$');
    return regex.hasMatch(this);
  }

  // Checks if the string contains any special characters
  bool get containsSpecialCharacters {
    final regex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    return regex.hasMatch(this);
  }

  // Returns a list of words from the string
  List<String> getWords() {
    return this.split(RegExp(r'\s+'));
  }

  // Pads the string with a specified character from the left to a certain length
  String padLeftWithChar(int length, [String padChar = ' ']) {
    return this.padLeft(length, padChar);
  }

  // Pads the string with a specified character from the right to a certain length
  String padRightWithChar(int length, [String padChar = ' ']) {
    return this.padRight(length, padChar);
  }
}
