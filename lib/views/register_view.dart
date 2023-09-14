import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sih1363/firebase_options.dart';

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
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.done:
            return Column(
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
                  try{
                  final userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: password);
                  print(userCredential);
                  }
                  on FirebaseAuthException catch(e){
                    if(e.code == 'weak-password'){
                      print("Weak Password");

                    }
                    else if(e.code == 'email-already-in-use'){
                      print("Email i already in use");
                    }
                    else if(e.code == 'invalid-email'){
                      print('invalid email');
                    }
                  }
                },
                child: const Text("Register"),
              ),
            ],
          );
            // case ConnectionState.none:
            // break;
            // case ConnectionState.waiting:
            // break;
            // case ConnectionState.active:
            // break;
            default:
            return const Text("loading");

          }
          
        },
      ),
    );
  }
}