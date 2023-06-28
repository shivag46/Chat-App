import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key,required this.toggleSignInStatus}) : super(key: key);
  final Function toggleSignInStatus;

  @override
  State<LoginPage> createState() => _LoginPageState(toggleSignInStatus: toggleSignInStatus);
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController textEditingControllerEmail = TextEditingController();
  final TextEditingController textEditingControllerPassword = TextEditingController();
  late String email, password;
  Function toggleSignInStatus;

  _LoginPageState({required this.toggleSignInStatus});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextField(
                  controller: textEditingControllerEmail,
                  decoration: const InputDecoration(
                      hintText: "Email"
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextField(
                  controller: textEditingControllerPassword,
                  decoration: const InputDecoration(
                      hintText: "Password"
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: () async{
                  email = textEditingControllerEmail.text;
                  password = textEditingControllerPassword.text;
                  try{
                    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                    toggleSignInStatus(true);
                  }on FirebaseAuthException {
                    const snackBar = SnackBar(
                      content: Text("Error"),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                    child:const Text("Log In")),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 const Text(
                     "New user? ",
                   style: TextStyle(fontSize: 18),
                 ),
                 GestureDetector(
                   onTap: () {
                     Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => SignInPage(toggleSignInStatus: toggleSignInStatus,))
                     );
                   },
                   child: const Text(
                       "Sign in ",
                     style: TextStyle(fontSize: 18,color: Colors.blue,decoration: TextDecoration.underline)
                   ),
                 ),
                 const Text(
                   "here",
                   style: TextStyle(fontSize: 18),
                 ),
               ],
              )
            ],
          ),
        )
    );
  }
}










class SignInPage extends StatefulWidget {
  const SignInPage({Key? key, required this.toggleSignInStatus}) : super(key: key);
  final Function toggleSignInStatus;

  @override
  State<SignInPage> createState() => _SignInPageState(toggleSignInStatus: toggleSignInStatus);
}

class _SignInPageState extends State<SignInPage> {

  Function toggleSignInStatus;
  _SignInPageState({required this.toggleSignInStatus});

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingControllerEmail = TextEditingController();
    final TextEditingController textEditingControllerPassword = TextEditingController();
    final TextEditingController textEditingControllerUsername = TextEditingController();

    return  Scaffold(
      appBar: AppBar(
        leading: ElevatedButton(
            style:ButtonStyle(
              elevation: MaterialStateProperty.all(0),
            ),
            child: const Icon(Icons.arrow_back,size: 30,),
            onPressed: () {
              Navigator.pop(context);
            },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextField(
                controller: textEditingControllerEmail,
                decoration: const InputDecoration(
                  hintText: "Email"
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextField(
                controller: textEditingControllerUsername,
                decoration: const InputDecoration(
                    hintText: "Username"
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextField(
                controller: textEditingControllerPassword,
                decoration: const InputDecoration(
                    hintText: "Password"
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed: () async{
                String email = textEditingControllerEmail.text;
                String username = textEditingControllerUsername.text;
                String password = textEditingControllerPassword.text;
                try{
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
                  await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).set(
                      {
                        "email": email,
                        "name": username
                      }
                  );
                  toggleSignInStatus(true);
                  Navigator.of(context).pop();
                }on FirebaseAuthException{
                  const snackBar = SnackBar(
                    content: Text("Error"),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
                  child:const Text("Sign In")),
            )
          ],
        ),
      )
    );
  }
}
