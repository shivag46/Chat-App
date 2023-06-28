import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key, required this.toggleSignInStatus}) : super(key: key);
  final Function toggleSignInStatus;

  @override
  State<UserDetails> createState() => _UserDetailsState(toggleSignInStatus: toggleSignInStatus);
}

class _UserDetailsState extends State<UserDetails> {
  String? name = FirebaseAuth.instance.currentUser?.displayName;
  Function toggleSignInStatus;
  _UserDetailsState({required this.toggleSignInStatus});

  Future<void> _showSimpleDialog() async {
    TextEditingController textEditingController = TextEditingController();
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog( // <-- SEE HERE
            title: const Text('Edit name'),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: textEditingController,
                ),
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () { Navigator.of(context).pop(); }, child: const Text('Cancel')),
                  ElevatedButton(onPressed: () async{
                    await FirebaseAuth.instance.currentUser?.updateDisplayName(textEditingController.text);
                    setState(() {
                      name = FirebaseAuth.instance.currentUser?.displayName;
                    });
                    Navigator.of(context).pop();
                    },
                      child: const Text('Update')),
                ],
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    name ??= "xyz";
    return Scaffold(
      appBar: AppBar(
        leading: ElevatedButton(
            style:ButtonStyle(
              elevation: MaterialStateProperty.all(0),
            ),
            child: const Icon(Icons.arrow_back),
            onPressed: () {
          Navigator.pop(context);
        }),
        title: const Text("Profile"),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.person_rounded,size:30),
                Text(name!),
                ElevatedButton(onPressed: () {
                  _showSimpleDialog();
                },
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                ),
                    child: const Icon(Icons.edit),)
              ],
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
                onPressed: () async{
                  await FirebaseAuth.instance.signOut();
                  toggleSignInStatus(false);
                  Navigator.of(context).pop();
                },
                child: const Text("Sign Out")
            )
          ],
        ),
      ),
    );
  }
}

/*
ElevatedButton(onPressed: () {
FirebaseAuth.instance.signOut();
toggleFoundSignInStatus(false);
toggleSignInStatus(false);
}, child: const Text("Log Out")),*/