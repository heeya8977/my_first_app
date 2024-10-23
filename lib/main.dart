import 'package:flutter/material.dart'; // Flutter의 핵심 UI 라이브러리를 가져옵니다.
import 'screens/main_screen.dart'; // 메인 화면 파일을 가져옵니다.
import 'package:shared_preferences/shared_preferences.dart'; // 기기 내에 데이터를 저장하는 SharedPreferences 라이브러리를 가져옵니다.
import 'screens/login_screen.dart'; // 로그인 화면 파일을 가져옵니다.
import 'package:firebase_core/firebase_core.dart'; // Firebase 초기화를 위한 라이브러리를 가져옵니다.
import 'package:firebase_auth/firebase_auth.dart'; // Firebase 인증 관련 라이브러리를 가져옵니다.
import 'screens/chat_screen.dart'; // 채팅 화면 파일을 가져옵니다.
import 'firebase_options.dart'; // Firebase 설정 옵션을 가져옵니다.
import 'screens/book_goal_screen.dart'; // 독서 목표 화면 파일을 가져옵니다.
import 'screens/genre_selection_screen.dart'; // 장르 선택 화면 파일을 가져옵니다.
import 'screens/book_recommendation_screen.dart'; // 책 추천 화면 파일을 가져옵니다.

// main 함수는 애플리케이션의 진입점입니다.
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진과 위젯을 초기화합니다.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Firebase 초기화 시 플랫폼에 맞는 옵션을 설정합니다.
  );
  runApp(const BookTrackerApp()); // BookTrackerApp 위젯을 실행합니다.
}

// BookTrackerApp 클래스는 애플리케이션의 루트 위젯입니다.
class BookTrackerApp extends StatelessWidget {
  const BookTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkLoginStatus(), // 사용자가 로그인했는지 확인합니다.
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // 로그인 상태를 확인하는 동안 로딩 인디케이터를 표시합니다.
        } else {
          return MaterialApp(
            title: 'Book Tracker', // 애플리케이션의 제목을 설정합니다.
            theme: ThemeData(
              primarySwatch: Colors.blue, // 앱의 기본 테마 색상을 파란색으로 설정합니다.
            ),
            home: snapshot.data == true ? buildNavigationFlow(context) : LoginScreen(), // 로그인 상태에 따라 목표 설정 흐름 또는 로그인 화면을 설정합니다.
            debugShowCheckedModeBanner: false, // 디버그 배너를 숨깁니다.
          );
        }
      },
    );
  }
}

// checkFirstRun 함수는 앱이 처음 실행되는지 여부를 확인합니다.
Future<bool> checkFirstRun() async {
  SharedPreferences prefs = await SharedPreferences.getInstance(); // SharedPreferences 인스턴스를 가져옵니다.
  bool isFirstRun = prefs.getBool('isFirstRun') ?? true; // 'isFirstRun' 값이 없으면 기본값으로 true를 사용합니다.
  if (isFirstRun) {
    await prefs.setBool('isFirstRun', false); // 처음 실행된 경우 'isFirstRun'을 false로 설정합니다.
  }
  return isFirstRun; // 처음 실행 여부를 반환합니다.
}

// checkLoginStatus 함수는 사용자가 로그인 상태인지 확인합니다.
Future<bool> checkLoginStatus() async {
  User? user = FirebaseAuth.instance.currentUser; // 현재 로그인한 사용자를 가져옵니다.
  if (user != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true); // 사용자가 로그인된 경우 'isLoggedIn' 값을 true로 설정합니다.
    return true;
  } else {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false; // 'isLoggedIn' 값이 없으면 기본값으로 false를 사용합니다.
    return isLoggedIn;
  }
}

// checkBookGoal 함수는 사용자가 독서 목표를 설정했는지 확인합니다.
Future<bool> checkBookGoal() async {
  SharedPreferences prefs = await SharedPreferences.getInstance(); // SharedPreferences 인스턴스를 가져옵니다.
  int bookGoal = prefs.getInt('bookGoal') ?? 0; // 'bookGoal' 값이 없으면 기본값으로 0을 사용합니다.
  return bookGoal > 0; // 목표가 설정되어 있다면 true를 반환합니다.
}

// buildNavigationFlow 함수는 사용자가 목표 설정, 장르 선택, 책 추천의 순서대로 화면을 이동하도록 설정합니다.
Widget buildNavigationFlow(BuildContext context) {
  return Navigator(
    onGenerateRoute: (RouteSettings settings) {
      switch (settings.name) {
        case '/':
          return MaterialPageRoute(builder: (context) => BookGoalScreen()); // 첫 화면은 목표 설정 화면입니다.
        case '/genreSelection':
          return MaterialPageRoute(builder: (context) => GenreSelectionScreen()); // 두 번째 화면은 장르 선택 화면입니다.
        case '/bookRecommendation':
          return MaterialPageRoute(builder: (context) => BookRecommendationScreen()); // 세 번째 화면은 책 추천 화면입니다.
        case '/mainScreen':
          return MaterialPageRoute(builder: (context) => MainScreen()); // 네 번째 화면은 메인 화면입니다.
        default:
          return MaterialPageRoute(builder: (context) => BookGoalScreen());
      }
    },
    initialRoute: '/',
  );
}
