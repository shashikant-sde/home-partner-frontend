import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../presentation/widgets/common/custom_button.dart';
import '../../../presentation/widgets/common/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (!Validators.isEmail(emailController.text)) {
      return;
    }
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.loginTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(controller: emailController, label: AppStrings.emailHint),
            const SizedBox(height: 16),
            CustomTextField(controller: passwordController, label: AppStrings.passwordHint, obscureText: true),
            const SizedBox(height: 24),
            CustomButton(text: AppStrings.loginButton, onPressed: _onLogin),
          ],
        ),
      ),
    );
  }
}
