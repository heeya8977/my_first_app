import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/chat_screen.dart';
import 'firebase_options.dart';

const bool isDebugMode = true;

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
      home: isDebugMode
          ? LoginScreen()
          : FutureBuilder<bool>(
              future: checkFirstRun(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  if (snapshot.data == true) {
                    return LoginScreen();
                  } else {
                    return FutureBuilder<bool>(
                      future: checkLoginStatus(),
                      builder: (context, loginSnapshot) {
                        if (loginSnapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else {
                          if (loginSnapshot.data == true) {
                            return MainScreen();
                          } else {
                            return LoginScreen();
                          }
                        }
                      },
                    );
                  }
                }
              },
            ),
    onGenerateRoute: (settings) {
  if (settings.name == '/chat') {
    final args = settings.arguments as Map<String, dynamic>;
    return MaterialPageRoute(
      builder: (context) => ChatScreen(
        chatRoomId: args['chatRoomId'],       // 기존에 전달하던 chatRoomId
        currentUserId: args['currentUserId'], // 추가된 currentUserId
        otherUserId: args['otherUserId'],     // 추가된 otherUserId
  ),
          );
        }
      },
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