import 'package:flutter/material.dart';
import 'book_recommendation_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GenreSelectionScreen extends StatefulWidget {
  @override
  _GenreSelectionScreenState createState() => _GenreSelectionScreenState();
}

class _GenreSelectionScreenState extends State<GenreSelectionScreen> {
  final List<String> genres = [
    '소설', '시', '에세이', '인문', '가정', '요리', '건강', '취미', '경제/경영',
    '자기계발', '정치/사회', '역사/문화', '종교', '예술', '기술', '외국어', '과학',
    '여행', '컴퓨터/IT'
  ];
  List<String> selectedGenres = [];

  void _navigateToBookRecommendation() async {
     if (selectedGenres.isNotEmpty) {
       // Firestore 인스턴스
       FirebaseFirestore firestore = FirebaseFirestore.instance;

       // Firestore에 선택한 장르 저장 (예시로 'users' 컬렉션 사용)
       await firestore.collection('users').doc('exampleUserId').set({
         'selectedGenres': selectedGenres,
       });

       // 도서 추천 화면으로 이동
       Navigator.push(
         context,
         MaterialPageRoute(builder: (context) => BookRecommendationScreen()),
       );
     } else {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('최소 하나의 장르를 선택해주세요!')),
       );
     }
   }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar 설정
      appBar: AppBar(
        title: Text('당신의 독서 취향이 궁금해요!'),
        backgroundColor: const Color.fromARGB(255, 213, 207, 185),
      ),
      // 본문 내용
      body: Container(
        // 배경 이미지 설정
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
        // 내용 패딩 설정
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 안내 텍스트
              Text(
                '좋아하는 장르를 마음껏 선택하세요',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 20),
              // 장르 선택 리스트
              Expanded(
                child: ListView(
                  children: genres.map((genre) {
                    return Card(
                      // 카드 배경색 설정
                      color: Colors.white.withOpacity(0.8),
                      child: CheckboxListTile(
                        title: Text(genre),
                        value: selectedGenres.contains(genre),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedGenres.add(genre);
                            } else {
                              selectedGenres.remove(genre);
                            }
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              // 다음 화면으로 이동하는 버튼
              ElevatedButton(
                onPressed: _navigateToBookRecommendation,
                child: Text('다음'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 222, 225, 184),
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}