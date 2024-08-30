import 'package:flutter/material.dart';
import 'screens/book_goal_screen.dart';
import 'screens/main_screen.dart'; // MainScreen import 추가
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences import 추가

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
      home: FutureBuilder<bool>(
        future: checkFirstRun(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // 로딩 중 표시
          } else {
            if (snapshot.data == true) {
              return BookGoalScreen();
            } else {
              return MainScreen();
            }
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  Future<bool> checkFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstRun = prefs.getBool('isFirstRun') ?? true;
    if (isFirstRun) {
      await prefs.setBool('isFirstRun', false);
    }
    return isFirstRun;
  }
}