import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 채팅 화면을 위한 StatefulWidget
class ChatScreen extends StatefulWidget {
  final String chatRoomId; // 채팅방 ID

  // 생성자: 채팅방 ID를 필수 매개변수로 받음
  ChatScreen({required this.chatRoomId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

// ChatScreen의 상태를 관리하는 State 클래스
class _ChatScreenState extends State<ChatScreen> {
  // 메시지 입력을 위한 TextEditingController
  final TextEditingController _messageController = TextEditingController();
  
  // Firestore 인스턴스 생성
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Firebase Auth 인스턴스 생성
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // 현재 사용자 UID 저장을 위한 변수
  late String _currentUserId;

  @override
  void initState() {
    super.initState();
    _getCurrentUser(); // 현재 사용자 정보 가져오기
  }

  // 현재 로그인된 사용자 정보를 가져오는 메서드
  void _getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      _currentUserId = user.uid;
    } else {
      // 사용자가 로그인되어 있지 않은 경우 처리
      Navigator.of(context).pop(); // 채팅 화면을 닫고 이전 화면으로 돌아감
    }
  }

  // 메시지 전송 함수
  void _sendMessage() async {
    // 메시지 내용이 비어있지 않은 경우에만 전송
    if (_messageController.text.isNotEmpty) {
      // Firestore의 'chat_rooms' 컬렉션 내 특정 채팅방의 'messages' 서브컬렉션에 새 문서 추가
      await _firestore
          .collection('chat_rooms')
          .doc(widget.chatRoomId)
          .collection('messages')
          .add({
        'text': _messageController.text, // 메시지 내용
        'timestamp': FieldValue.serverTimestamp(), // 서버 타임스탬프
        'senderId': _currentUserId, // 현재 사용자 ID
      });
      _messageController.clear(); // 입력 필드 초기화
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // 메시지 목록 표시 영역
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                // 특정 채팅방의 메시지들을 시간 순으로 가져오는 스트림
                stream: FirebaseFirestore.instance
                    .collection('chat_rooms')
                    .doc(widget.chatRoomId)
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data!.docs;
                  List<Widget> messageWidgets = [];
                  for (var message in messages) {
                    final messageText = message['text'];
                    final messageSender = message['senderId'];
                    final messageWidget = MessageBubble(
                      sender: messageSender,
                      text: messageText,
                      isMe: _currentUserId == messageSender,
                    );
                    messageWidgets.add(messageWidget);
                  }
                  return ListView(
                    reverse: true,
                    children: messageWidgets,
                  );
                },
              ),
            ),
            // 메시지 입력 영역
            Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  // 메시지 입력 필드
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Enter a message...', // 힌트 텍스트
                      ),
                    ),
                  ),
                  // 메시지 전송 버튼
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _sendMessage, // 전송 버튼 클릭 시 _sendMessage 함수 호출
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 개별 메시지 버블을 표시하는 위젯
class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;

  MessageBubble({required this.sender, required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}