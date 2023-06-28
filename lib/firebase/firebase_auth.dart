import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static login(String email, String password) async{
    try{
      return firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    }on FirebaseAuthException catch (e){
      print(e.message);
    }
  }

  static signUp(String email, String password, String username) async{
    try{
      await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    }on FirebaseAuthException catch(e){
      print(e.message);
    }
    await FirebaseFirestore.instance.collection("users").add(
      {
        "email": email,
        "name": username
      }
    );
  }
}