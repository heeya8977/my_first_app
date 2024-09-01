import 'package:flutter/material.dart';
import 'package:my_first_app/screens/main_screen.dart';


// BookRecommendationScreen 위젯 정의
class BookRecommendationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar 설정
      appBar: AppBar(
        title: Text('당신의 취향에 맞는 책을 선정해봤어요!'),
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
        // 내용을 중앙에 배치
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 안내 메시지
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
    children: [
      Text(
        '책 추천 기능은 준비 중입니다.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 8), // 두 문장 사이에 간격 추가
      Text(
        '조금만 기다려주세요!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ],
  ),
),
              SizedBox(height: 20),
              // 책 아이콘
              Icon(
                Icons.book,
                size: 100,
                color: const Color.fromARGB(255, 241, 245, 196),
              ),
              SizedBox(height: 20),
              // 메인 화면으로 이동하는 버튼
              ElevatedButton(
                onPressed: () {
                  // 모든 이전 화면을 제거하고 메인 화면으로 이동
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Text('메인 화면으로 이동'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 238, 235, 202),
                  minimumSize: Size(200, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}