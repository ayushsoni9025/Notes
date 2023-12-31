import 'package:flutter/material.dart';
import 'package:sih1363/constant/routes.dart';
import 'package:sih1363/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Email verification"),
      ),
      body: Column(
        children: [
          const Text(
              "We've send you an email verification. please open it to verify your account"),
          const Text(
              "if you haven`t recieve a verification email yet, press the button below"),
          TextButton(
            onPressed: () async {
              final user = AuthService.firebase().currentUser;
              if (user?.isEmailVerified ?? false) {
              } else {
                await AuthService.firebase().sendEmailVerification();
              }
            },
            child: const Text("Send email verification"),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text("Restart"),
          ),
        ],
      ),
    );
  }
}
