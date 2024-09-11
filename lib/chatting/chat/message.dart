import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 메시지 목록을 표시하는 StatelessWidget
class Message extends StatelessWidget {
  // 생성자: key 매개변수를 받아 상위 클래스 생성자에 전달
  const Message({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // StreamBuilder를 사용하여 Firestore의 실시간 데이터를 처리
    return StreamBuilder(
      // Firestore의 'chat' 컬렉션에서 데이터를 실시간으로 가져옴
      // 'timestamp' 필드를 기준으로 내림차순 정렬 (최신 메시지가 먼저 오도록)
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      // 스트림에서 데이터를 받을 때마다 호출되는 builder 함수
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // 연결 상태가 대기 중일 때 로딩 표시기를 보여줌
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // 데이터가 없거나 메시지가 없을 때 메시지를 표시
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No messages yet.'));
        }

        // 메시지 목록을 가져옴
        final messages = snapshot.data!.docs;

        // ListView.builder를 사용하여 메시지 목록을 표시
        return ListView.builder(
          reverse: true, // 리스트를 역순으로 표시 (최신 메시지가 아래에 오도록)
          itemCount: messages.length, // 메시지 개수만큼 아이템 생성
          itemBuilder: (ctx, index) {
            // 각 메시지의 데이터를 Map 형태로 가져옴
            final messageData = messages[index].data() as Map<String, dynamic>;
            // ListTile을 사용하여 각 메시지를 표시
            return ListTile(
              title: Text(messageData['text'] ?? ''), // 메시지 내용 표시
              subtitle: Text(messageData['userId'] ?? 'Anonymous'), // 사용자 ID 표시
              // 여기에 추가적인 스타일링이나 정보를 추가할 수 있습니다.
            );
          },
        );
      },
    );
  }
}