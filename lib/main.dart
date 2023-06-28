import 'package:chat_app/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './firebase/firebase_options.dart';
import 'pages/sign_in_page.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _signInStatus = false;
  bool _foundSignInStatus = false;

  void initializeFirebase() async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if(FirebaseAuth.instance.currentUser == null){
      _signInStatus = false;
    }else{
      _signInStatus = true;
    }

    setState(() {
      _foundSignInStatus = true;
    });
  }

  void toggleSignInStatus(bool value){
    setState(() {
      _signInStatus = value;
      _foundSignInStatus = true;
    });
  }

  void toggleFoundSignInStatus(bool value){
    _foundSignInStatus = value;
  }

  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  _foundSignInStatus?(_signInStatus?HomePage(toggleSignInStatus: toggleSignInStatus,toggleFoundSignInStatus: toggleFoundSignInStatus,): LoginPage(toggleSignInStatus: toggleSignInStatus,)):const Scaffold(body: Center(child: CircularProgressIndicator()))
      //home: const ChatPage(),
    );
  }
}







