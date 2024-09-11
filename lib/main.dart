import 'package:flutter/material.dart';
import 'screens/main_screen.dart'; // 메인 화면 위젯 import
import 'package:shared_preferences/shared_preferences.dart'; // 로컬 저장소 사용을 위한 패키지
import 'package:supabase_flutter/supabase_flutter.dart'; // Supabase 기능 사용을 위한 패키지
import 'screens/login_screen.dart'; // 로그인 화면 위젯 import
import 'package:firebase_core/firebase_core.dart'; // Firebase 초기화를 위한 패키지

// 디버그 모드 플래그 (true: 디버그 모드, false: 실제 사용 모드)
const bool isDebugMode = false;

// 앱의 시작점
void main() async {
  // Flutter 위젯 바인딩 초기화 (비동기 작업을 위해 필요)
  WidgetsFlutterBinding.ensureInitialized();
  
  // Supabase 초기화
  await Supabase.initialize(
    url: 'https://pnorkrjfjvcafnaiimrw.supabase.co', // Supabase 프로젝트 URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBub3JrcmpmanZjYWZuYWlpbXJ3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjU0MTgzNDUsImV4cCI6MjA0MDk5NDM0NX0.9a7Ht_EnfBYZNtvVFUgJtY_eTbOm-PsyVu7vY1_pH00', // Supabase 익명 키
  );

  // Firebase 초기화
  await Firebase.initializeApp();

  // 앱 실행
  runApp(const BookTrackerApp());
}

// 앱의 루트 위젯
class BookTrackerApp extends StatelessWidget {
  const BookTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Tracker', // 앱 제목
      theme: ThemeData(
        primarySwatch: Colors.blue, // 앱의 기본 색상 테마
      ),
      home: isDebugMode
        ? LoginScreen() // 디버그 모드일 때는 항상 LoginScreen 표시
        : FutureBuilder<bool>(
            // 첫 실행 여부 확인
            future: checkFirstRun(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // 데이터 로딩 중일 때 로딩 인디케이터 표시
                return CircularProgressIndicator();
              } else {
                if (snapshot.data == true) {
                  // 첫 실행 시 LoginScreen 표시
                  return LoginScreen();
                } else {
                  // 첫 실행이 아닐 경우 로그인 상태 확인
                  return FutureBuilder<bool>(
                    future: checkLoginStatus(),
                    builder: (context, loginSnapshot) {
                      if (loginSnapshot.connectionState == ConnectionState.waiting) {
                        // 로그인 상태 확인 중 로딩 인디케이터 표시
                        return CircularProgressIndicator();
                      } else {
                        if (loginSnapshot.data == true) {
                          // 로그인 된 경우 MainScreen 표시
                          return MainScreen();
                        } else {
                          // 로그인 되지 않은 경우 LoginScreen 표시
                          return LoginScreen();
                        }
                      }
                    },
                  );
                }
              }
            },
          ),
      debugShowCheckedModeBanner: false, // 디버그 배너 숨기기
    );
  }

  // 앱의 첫 실행 여부를 확인하는 메서드
  Future<bool> checkFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstRun = prefs.getBool('isFirstRun') ?? true;
    if (isFirstRun) {
      // 첫 실행일 경우 플래그를 false로 설정
      await prefs.setBool('isFirstRun', false);
    }
    return isFirstRun;
  }

  // 사용자의 로그인 상태를 확인하는 메서드
  Future<bool> checkLoginStatus() async {
    final user = Supabase.instance.client.auth.currentUser;
    return user != null; // 현재 사용자가 있으면 true, 없으면 false 반환
  }
}