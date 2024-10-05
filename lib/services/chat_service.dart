import 'package:cloud_firestore/cloud_firestore.dart';



class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createChatRoom(String senderId1, String senderId2) async {
  List<String> ids = [senderId1, senderId2];
  ids.sort(); // 정렬하여 항상 같은 순서가 되도록 함
  String chatRoomId = ids.join('_');

  DocumentReference chatRoomRef = _firestore.collection('chat_rooms').doc(chatRoomId);

  final chatRoomSnapshot = await chatRoomRef.get();
  if (!chatRoomSnapshot.exists) {
    await chatRoomRef.set({
      'participants': [senderId1, senderId2],
      'created_at': FieldValue.serverTimestamp(),
      'last_message': '',
      'last_message_time': null,
    });
  }

  return chatRoomId;
}

  // 여기에 다른 채팅 관련 메서드를 추가할 수 있습니다.
}