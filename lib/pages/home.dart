import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/user_details.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase/firebase_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key,required this.toggleSignInStatus,required this.toggleFoundSignInStatus}) : super(key: key);
  final Function toggleSignInStatus;
  final Function toggleFoundSignInStatus;

  @override
  State<HomePage> createState() => _HomePageState(toggleSignInStatus: toggleSignInStatus,toggleFoundSignInStatus: toggleFoundSignInStatus);
}

class _HomePageState extends State<HomePage> {

  _HomePageState({required this.toggleSignInStatus,required this.toggleFoundSignInStatus});
  Function toggleSignInStatus;
  Function toggleFoundSignInStatus;
  TextEditingController textEditingController = TextEditingController();
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat App"),
        actions:  [
          ElevatedButton(
              style:ButtonStyle(
                elevation: MaterialStateProperty.all(0),
              ),
              onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (builder) => UserDetails(toggleSignInStatus: toggleSignInStatus,)));
          }, child: const Icon(Icons.person_rounded,size: 30,)),
          const SizedBox(width: 10,)
        ],
        elevation: 0,
      ),
      body: Center(
        child:getFriends()
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async{
            addFriend();
            },
          child: const Icon(Icons.add_comment_rounded,size: 30,)
      ),
    );
  }

  addFriend() async{
    TextEditingController textEditingController = TextEditingController();
    return showDialog(context: context, builder: (builder){
      return SimpleDialog(
        title: const Text("Add Friend"),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: textEditingController,
              decoration: const InputDecoration(hintText: "Type in your friend's mail"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () async{
                  try{
                    var recipientData  = await FirestoreService.getUserFromEmail(textEditingController.text);
                    var senderData = await FirestoreService.getUserFromUserId(userId!);
                    await FirestoreService.addConnection(senderData.id, recipientData.id,senderData.data()!['name'],recipientData.data()['name']);
                    Navigator.of(context).pop();
                    setState(() {

                    });
                  }on RangeError {
                    const snackBar = SnackBar(
                      content: Text("Please enter a valid registered mail"),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: const Text("Add")
            ),
          )
        ],
      );
    });
  }

  getFriends(){
    return FutureBuilder(
      future: FirestoreService.getFriends(userId!),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const CircularProgressIndicator();
          }
          if(snapshot.hasData){
            var data = snapshot.data;
            return ListView.builder(
                itemCount: data?.length,
                itemBuilder: (context,index){
                  return ListTile(
                      leading: const Icon(Icons.person_rounded,size: 40,),
                      title: Text(
                        data![index].data()['name'],
                        style: const TextStyle(
                          fontSize: 23,
                        ),
                      ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatPage(connectionDetails: data[index].data()))
                      );
                    },
                  );
                },
            );
          }
          return Container();
        }
    );
  }
}

