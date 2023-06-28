import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../firebase/firebase_firestore.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.connectionDetails}) : super(key: key);
  final Map<String,dynamic> connectionDetails;

  @override
  State<ChatPage> createState() => _ChatPageState(connectionDetails: connectionDetails);
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController textEditingController = TextEditingController();
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  Map<String,dynamic> connectionDetails;

  _ChatPageState({required this.connectionDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(connectionDetails['name']),
        leading: GestureDetector(
            onTap: () { Navigator.of(context).pop(); },
            child: const Icon(Icons.arrow_back),
        ),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            chats(),
            const SizedBox(height: 20,),
            Row(
              children: [
                SizedBox(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: textEditingController,
                        decoration: const InputDecoration(
                            hintText: "Send a message"
                        ),
                      ),
                    )),
                const SizedBox(width: 10,),
                ElevatedButton(onPressed: () async{
                  await FirestoreService.sendMessage(textEditingController.text, userId!, connectionDetails['channel_id']);
                  textEditingController.text = "";
                  setState(() {
                  });
                }, child: const Icon(Icons.send_rounded),),
              ],
            ),
          ],
        ),
      ),
    );
  }

  chats(){
    return StreamBuilder(
        stream: FirestoreService.getChats(connectionDetails['channel_id']),
        builder: (context,snapshot){
          if(snapshot.hasData){
            dynamic data = snapshot.data?.docs;
            return Expanded(
              child: ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context,index){
                    if(data[index].data()['sender'] == userId){
                      return messageTile(data[index].data()['content'],true);
                    }
                    return messageTile(data[index].data()['content'],false);
                  }),
            );
          }
          return Container();
        }
    );
  }


  messageTile(String text, bool myMessage){
    return SizedBox(
        child:Align(
          alignment: myMessage?Alignment.centerRight:Alignment.centerLeft,
          child:Container(
            constraints: const BoxConstraints(maxWidth: 200),
            margin: const EdgeInsets.only(left: 10,right:10,top: 5,bottom: 5),
            decoration: BoxDecoration(
              color: myMessage?Colors.indigoAccent[100]:Colors.cyanAccent[100],
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 1.0,
                ), //BoxShadow
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                ), //BoxShadow
              ],
            ),
            child: Padding(
              padding:  const EdgeInsets.all(8.0),
              child: Text(text,
                style: const TextStyle(
                    fontSize: 18
                ),
              ),
            ),
          ),
        )
    );
  }
}

