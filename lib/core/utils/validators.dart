class Validators {
  static bool isEmail(String input) {
    return RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+").hasMatch(input);
  }

  static bool isNotEmpty(String input) {
    return input.trim().isNotEmpty;
  }
}
