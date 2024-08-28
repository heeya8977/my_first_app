import 'package:flutter/material.dart';
import 'package:my_first_app/screens/main_screen.dart';


class BookRecommendationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('당신의 취향에 맞는 책을 선정해봤어요!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '책 추천 기능은 준비 중입니다. 조금만 기다려주세요!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Icon(
              Icons.book,
              size: 100,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text('메인 화면으로 이동'),
            ),
          ],
        ),
      ),
    );
  }
}
