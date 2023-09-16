import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtool show log;

import 'package:sih1363/constant/routes.dart';
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
                final userCredential =
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                devtool.log(
                  userCredential.toString(),
                );
                //Object? value = null;
                Navigator.of(context).pushNamedAndRemoveUntil(
                  mainUiRoute,
                  (route) => false,
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  errorMessage(
                    context,
                    'Invalid Email',
                  );
                } else if (e.code == 'wrong-password') {
                  devtool.log("WRONG PASSWORD");
                  errorMessage(
                    context,
                    'Invalid Password',
                  );
                } else {
                  devtool.log("Some thing else happen");
                  errorMessage(context, "Error ${e.code}");
                }
              } catch(e){
                errorMessage(context, e.toString());

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
