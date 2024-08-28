import 'package:flutter/material.dart';
import 'book_recommendation_screen.dart';

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

  void _navigateToBookRecommendation() {
    // 사용자가 장르를 선택했을 때만 다음 화면으로 이동
    if (selectedGenres.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BookRecommendationScreen()),
      );
    } else {
      // 장르 선택을 유도하는 간단한 알림
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('최소 하나의 장르를 선택해주세요!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('당신의 독서 취향이 궁금해요!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '좋아하는 장르를 마음껏 선택하세요',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: genres.map((genre) {
                  return CheckboxListTile(
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
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: _navigateToBookRecommendation,
              child: Text('다음'),
            ),
          ],
        ),
      ),
    );
  }
}
