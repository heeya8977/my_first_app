import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/chat_screen.dart';
import 'firebase_options.dart';
import 'screens/book_goal_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const BookTrackerApp());
}

class BookTrackerApp extends StatelessWidget {
  const BookTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookGoalScreen(), // 항상 BookGoalScreen부터 시작하게 설정
      debugShowCheckedModeBanner: false,
    );
  }
}

Future<bool> checkFirstRun() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstRun = prefs.getBool('isFirstRun') ?? true;
  if (isFirstRun) {
    await prefs.setBool('isFirstRun', false);
  }
  return isFirstRun;
}

Future<bool> checkLoginStatus() async {
  return FirebaseAuth.instance.currentUser != null;
}

// 여기서 checkBookGoal 함수를 추가합니다.
Future<bool> checkBookGoal() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int bookGoal = prefs.getInt('bookGoal') ?? 0;
  return bookGoal > 0; // 목표가 설정되어 있다면 true 반환
}
