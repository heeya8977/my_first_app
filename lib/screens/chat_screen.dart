import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_first_app/chatting/chat/message.dart';

// 채팅 화면을 위한 StatefulWidget
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

// ChatScreen의 상태를 관리하는 State 클래스
class _ChatScreenState extends State<ChatScreen> {
  // 메시지 입력을 위한 TextEditingController
  final TextEditingController _messageController = TextEditingController();
  
  // Firestore 인스턴스 생성
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 메시지 전송 함수
  void _sendMessage() async {
    // 메시지 내용이 비어있지 않은 경우에만 전송
    if (_messageController.text.isNotEmpty) {
      // Firestore의 'chat' 컬렉션에 새 문서 추가
      await _firestore.collection('chat').add({
        'text': _messageController.text, // 메시지 내용
        'timestamp': FieldValue.serverTimestamp(), // 서버 타임스탬프
        'userId': 'User123', // 사용자 ID (실제 앱에서는 로그인한 사용자의 ID를 사용해야 함)
      });
      _messageController.clear(); // 입력 필드 초기화
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 앱 바 설정
      appBar: AppBar(
        title: Text('Chat Room'),
      ),
      // 채팅 화면의 본문
      body: Column(
        children: <Widget>[
          // 메시지 목록 표시 영역
          Expanded(
            child: Message(), // Message 위젯을 사용하여 메시지 목록 표시
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
    );
  }
}