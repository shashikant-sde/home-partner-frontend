class LoginController {
  String email = '';
  String password = '';

  bool validate() {
    return email.isNotEmpty && password.isNotEmpty;
  }
}
