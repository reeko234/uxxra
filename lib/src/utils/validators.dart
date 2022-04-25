class Validators {
  static bool checkIfIsEmail(String value) {
    return value.contains("@");
  }

  static bool checkIfIsAlphabets(String? value) {
    String pattern = r'^[A-Za-z]+$';
    return RegExp(pattern).hasMatch(value ?? "");
  }
}
