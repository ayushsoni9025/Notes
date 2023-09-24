import 'package:flutter/material.dart';
import 'package:sih1363/constant/routes.dart';
import 'package:sih1363/services/auth/auth_exception.dart';
import 'package:sih1363/services/auth/auth_service.dart';
import 'package:sih1363/utility/scaffold_message.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Column(
        children: [
          TextField(
            decoration:
                const InputDecoration(hintText: "Enter your email here"),
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            controller: _email,
          ),
          TextField(
            decoration:
                const InputDecoration(hintText: "Enter your password here"),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            controller: _password,
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().creatUser(
                  email: email,
                  password: password,
                );
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordAuthException {
                snackMessage(
                  context,
                  "Weak Password",
                );
              } on EmailAlreadyInUseAuthException {
                snackMessage(
                  context,
                  "Email already in use",
                );
              } on InvalidEmailAuthException {
                snackMessage(
                  context,
                  "Invalid email",
                );
              } on GenericAuthException {
                snackMessage(context, "Authentication error");
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text('Already have an account! Login here'),
          )
        ],
      ),
    );
  }
}
