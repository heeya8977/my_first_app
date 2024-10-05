import 'package:flutter/material.dart'; // Flutter의 기본 위젯과 디자인 요소를 사용하기 위한 패키지
import 'package:cloud_firestore/cloud_firestore.dart'; // Cloud Firestore와의 연동을 위한 패키지
import 'package:my_first_app/services/chat_service.dart'; // 채팅 관련 서비스를 제공하는 사용자 정의 서비스
import 'package:my_first_app/screens/chat_screen.dart'; // 채팅 화면을 위한 사용자 정의 스크린

// 사용자 목록 화면을 정의하는 StatelessWidget 클래스
class UserListScreen extends StatelessWidget {
  final String currentUserId; // 현재 사용자의 고유 ID

  // 생성자: currentUserId를 필수로 요구함
  const UserListScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 앱 바 설정
      appBar: AppBar(
        title: Text('사용자 목록'), // 앱 바 제목
      ),
      // 본문에 실시간으로 Firestore의 'users' 컬렉션을 스트리밍
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(), // 'users' 컬렉션의 실시간 스냅샷 스트림
        builder: (context, snapshot) {
          // 에러가 발생한 경우 표시
          if (snapshot.hasError) {
            return Center(child: Text('사용자 목록을 불러오는 중 오류가 발생했습니다.'));
          }
          // 데이터가 로드 중인 경우 로딩 인디케이터 표시
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final users = snapshot.data!.docs; // 가져온 사용자 문서들
          // 현재 사용자를 제외한 다른 사용자들로 목록 필터링
          final otherUsers = users.where((doc) => doc['nxtlPpskMLa1YknDSblqdWnsfMs2'] != currentUserId).toList();
          // 다른 사용자가 없는 경우 메시지 표시
          if (otherUsers.isEmpty) {
            return Center(child: Text('다른 사용자가 없습니다.'));
          }
          // 사용자 목록을 리스트뷰로 표시
          return ListView.builder(
            itemCount: otherUsers.length, // 목록의 항목 수
            itemBuilder: (context, index) {
              final userData = otherUsers[index].data() as Map<String, dynamic>; // 각 사용자의 데이터
              return ListTile(
                // 사용자의 프로필 사진 표시
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(userData['profilePicture'] ?? ''),
                ),
                // 사용자의 이름 표시
                title: Text(userData['displayName'] ?? 'Unknown'),
                // 사용자를 탭했을 때의 동작 정의
                onTap: () async {
                  // 채팅방 생성 및 채팅 화면으로 이동
                  ChatService chatService = ChatService(); // 채팅 서비스 인스턴스 생성
                  String chatRoomId = await chatService.createChatRoom(
                    currentUserId, // 현재 사용자 ID
                    userData['nxtlPpskMLa1YknDSblqdWnsfMs2'], // 선택한 사용자의 ID
                  );
                  // 채팅 화면으로 네비게이션
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        chatRoomId: chatRoomId, // 생성된 채팅방 ID
                        currentUserId: currentUserId, // 현재 사용자 ID
                        otherUserId: userData['nxtlPpskMLa1YknDSblqdWnsfMs2'], // 상대방 사용자 ID
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
