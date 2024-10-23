import 'package:flutter/material.dart';
import 'package:my_first_app/screens/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// BookRecommendationScreen 위젯 정의
class BookRecommendationScreen extends StatelessWidget {
  Future<List<Map<String, dynamic>>> fetchBookRecommendations() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // 사용자 장르 가져오기
    DocumentSnapshot userSnapshot =
        await firestore.collection('users').doc('exampleUserId').get();
    List<dynamic> selectedGenres = userSnapshot['selectedGenres'] ?? [];

    // 선택한 장르에 맞는 도서 가져오기
    QuerySnapshot booksSnapshot = await firestore
        .collection('books')
        .where('genre', whereIn: selectedGenres)
        .get();

    return booksSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('당신의 취향에 맞는 책을 선정해봤어요!'),
        backgroundColor: const Color.fromARGB(255, 213, 207, 185),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/flutter003.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.1),
              BlendMode.lighten,
            ),
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchBookRecommendations(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('추천 도서를 불러오는 중 오류가 발생했습니다.'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('추천할 도서를 찾을 수 없습니다.'));
            } else {
              List<Map<String, dynamic>> books = snapshot.data!;

              return ListView.builder(
                itemCount: books.length + 1, // 도서 목록 + 버튼을 포함하기 위해 +1
                itemBuilder: (context, index) {
                  // 마지막 항목에 "메인 화면으로 이동하기" 버튼 추가
                  if (index == books.length) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // 메인 화면으로 이동
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => MainScreen()),
                            (route) => false,
                          );
                        },
                        child: Text('메인 화면으로 이동하기'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 222, 225, 184),
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                    );
                  } 
                  // 도서 카드 항목 생성
                  else {
                    final book = books[index];
                    return Card(
                      color: Colors.white.withOpacity(0.8),
                      child: ListTile(
                        title: Text(book['title'] ?? '제목 없음'),
                        subtitle: Text(book['author'] ?? '작가 미상'),
                                 ),
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}