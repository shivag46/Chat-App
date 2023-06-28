import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{

  static Stream<QuerySnapshot> getChats(String channelId) async*{
    var channel = FirebaseFirestore.instance.collection("channels").doc(channelId);
    yield* channel.collection("messages").orderBy("time").snapshots();
  }

  static sendMessage(String message, String senderID, String channelId) async{
    Map<String,dynamic> data = {
      "sender":senderID,
      "content": message,
      "time":DateTime.now().microsecondsSinceEpoch,
    };
    var channel = FirebaseFirestore.instance.collection("channels").doc(channelId);
    await channel.collection("messages").add(data);
  }

  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getFriends(String userId) async{
    var friends = await FirebaseFirestore.instance.collection("users").doc(userId).collection("friends").get();
    return friends.docs;
  }

  static Future<QueryDocumentSnapshot<Map<String, dynamic>>> getUserFromEmail(String email) async{
    var user = await FirebaseFirestore.instance.collection("users").where(
      "email",isEqualTo:email
    ).get();

    return user.docs[0];
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getUserFromUserId(String userId) async{
    var user = await FirebaseFirestore.instance.collection("users").doc(userId).get();
    return user;
  }

  static addConnection(String userId, String friendId, String userName, String friendName) async{
    var channel = await FirebaseFirestore.instance.collection("channels").add(
      {
        "type": "personal_chat"
      }
    );

    await FirebaseFirestore.instance.collection("users").doc(userId).collection("friends").add(
      {
        "user_id":friendId,
        "name":friendName,
        "channel_id":channel.id
      }
    );

    await FirebaseFirestore.instance.collection("users").doc(friendId).collection("friends").add(
        {
          "user_id":userId,
          "name":userName,
          "channel_id":channel.id
        }
    );
  }
}


