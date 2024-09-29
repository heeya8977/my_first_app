import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// 메시지 목록을 표시하는 StatelessWidget
class Message extends StatelessWidget {
  // 현재 사용자의 UID를 저장하는 변수
  final String currentUserId;
  final String chatRoomId;

  // 생성자: 현재 사용자 UID를 받아 초기화
  const Message({
    Key? key,
    required this.currentUserId,
    required this.chatRoomId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // StreamBuilder를 사용하여 Firestore의 실시간 데이터를 빌드
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      // 'chat_rooms' 컬렉션에서 타임스탬프를 기준으로 내림차순 정렬된 스냅샷 스트림을 가져옴
      stream: FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),

      // 스트림 데이터의 상태 변화에 따라 UI를 업데이트하는 빌더 함수
      builder: (context, snapshot) {
        // 에러 발생 시 처리
        if (snapshot.hasError) {
          return Center(child: Text('메시지를 불러오는 중 오류가 발생했습니다.'));
        }
        // 데이터 로딩 중일 때 로딩 인디케이터를 표시
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        // 데이터가 없을 경우 안내 메시지를 표시
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No messages yet.'));
        }
        // 메시지 목록을 가져옴
        final messages = snapshot.data!.docs;
        // ListView.builder를 사용하여 메시지 목록을 빌드
        return ListView.builder(
          reverse: true, // 리스트를 역순으로 표시하여 최신 메시지가 아래로 오도록 설정
          itemCount: messages.length, // 메시지 개수만큼 아이템을 생성
          itemBuilder: (ctx, index) {
            // 각 메시지의 데이터를 가져옴
            final messageData = messages[index].data();

            // 메시지의 타임스탬프를 가져옴
            final DateTime timestamp = messageData['timestamp'].toDate();

            // 메시지가 현재 사용자의 것인지 확인
            final isCurrentUser = messageData['userId'] == currentUserId;

            // 메시지를 정렬하고 스타일링하여 반환
            return Align(
              alignment: isCurrentUser
                  ? Alignment.centerRight
                  : Alignment.centerLeft, // 메시지 정렬 설정
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: 8, horizontal: 12), // 내부 패딩 설정
                margin: EdgeInsets.symmetric(
                    vertical: 4, horizontal: 8), // 외부 마진 설정
                decoration: BoxDecoration(
                  color: isCurrentUser
                      ? Colors.blueAccent
                      : Colors.grey[300], // 현재 사용자 메시지의 배경색 설정
                  borderRadius: BorderRadius.circular(12), // 테두리 반경 설정
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      messageData['text'] ?? '', // 메시지 텍스트 표시
                      style: TextStyle(
                        color: isCurrentUser
                            ? Colors.white
                            : Colors.black, // 텍스트 색상 설정
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      // 타임스탬프 형식화 및 표시
                      DateFormat('yyyy-MM-dd HH:mm').format(timestamp),
                      style: TextStyle(
                        color:
                            isCurrentUser ? Colors.white70 : Colors.black54,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
