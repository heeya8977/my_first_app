// 필요한 패키지들을 임포트합니다.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// 로그인 화면을 위한 StatefulWidget을 정의합니다.
class Login extends StatefulWidget {
  // 생성자: 부모 위젯으로부터 key를 받습니다.
  const Login({super.key});

  @override
  // Login 위젯의 상태를 생성합니다.
  State<Login> createState() => _LoginState();
}

// Login 위젯의 상태를 관리하는 클래스입니다.
class _LoginState extends State<Login> {
  @override
  // 위젯을 빌드하는 메서드입니다.
  Widget build(BuildContext context) {
    // Scaffold 위젯으로 기본적인 앱 구조를 제공합니다.
    return Scaffold(
      // SafeArea를 사용하여 시스템 UI를 피해 콘텐츠를 배치합니다.
      body: SafeArea(
        // Column 위젯으로 세로 방향으로 위젯들을 배치합니다.
        child: Column(
          // 컬럼의 내용을 가운데 정렬합니다.
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Expanded 위젯으로 남은 공간을 모두 차지하게 합니다.
            Expanded(
              // 내부에 다시 Column을 배치하여 로그인 버튼을 중앙에 위치시킵니다.
              child: Column(
                // 세로 방향으로 중앙 정렬합니다.
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // InkWell 위젯으로 탭 가능한 영역을 만듭니다.
                  InkWell(
                    // 탭 했을 때의 동작을 정의합니다.
                    onTap: () {
                      //TODO: 구글 로그인 로직을 구현해야 합니다.



                      signInWithGoogle();
                    },
                    // Card 위젯으로 구글 로그인 버튼을 만듭니다.
                    child: Card(
                      // 카드의 여백을 설정합니다.
                      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      // 카드의 모서리를 둥글게 만듭니다.
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      // 카드에 그림자를 추가합니다.
                      elevation: 2,
                      // Row 위젯으로 가로 방향으로 내용을 배치합니다.
                      child: Row(
                        // 가로 방향으로 중앙 정렬합니다.
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 구글 로고 이미지를 표시합니다.
                          Image.asset('assets/flutter003.png'),
                          // SizedBox로 이미지와 텍스트 사이에 간격을 줍니다.
                          const SizedBox(
                            width: 10,
                          ),
                          // "Sign In With Google" 텍스트를 표시합니다.
                          const Text(
                            "Sign In With Google",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}


}


