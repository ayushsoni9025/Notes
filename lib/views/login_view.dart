import 'package:flutter/material.dart';
import 'package:sih1363/constant/routes.dart';
import 'package:sih1363/services/auth/auth_exception.dart';
import 'package:sih1363/services/auth/auth_service.dart';
import 'package:sih1363/utility/scaffold_message.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text("Login"),
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
                await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(mainUiRoute, (route) => false);
                } else {
                  Navigator.of(context).pushNamed(
                    verifyEmailRoute,
                  );
                }
              } on UserNotFoundAuthException {
                snackMessage(
                  context,
                  'Invalid Email',
                );
              } on WrongPasswordAuthException {
                snackMessage(
                  context,
                  'Invalid Password',
                );
              } on GenericAuthException {
                snackMessage(context, "Authentication error");
              }
            },
            child: const Text("Login"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text('Not register yet? Register here'),
          )
        ],
      ),
    );
  }
}
