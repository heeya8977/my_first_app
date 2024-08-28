import 'package:flutter/material.dart';
import 'screens/book_goal_screen.dart';


void main() {
  runApp(BookTrackerApp());
}

class BookTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookGoalScreen(), // 첫 화면으로 설정
      debugShowCheckedModeBanner: false, // 디버깅 배너 제거
    );
  }
}
