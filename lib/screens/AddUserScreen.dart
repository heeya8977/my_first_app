import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddUserScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 사용자 추가 메서드
  Future<void> addUser() async {
    // 현재 로그인된 사용자 가져오기
    final User? user = _auth.currentUser;

    if (user != null) {
      // Firestore에 사용자 데이터 추가
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'displayName': user.displayName ?? 'Unknown User',  // 디스플레이 이름이 없는 경우 기본값 설정
        'profilePicture': user.photoURL ?? 'default_profile_picture.png',  // 프로필 사진이 없는 경우 기본값 설정
      });
      print("User added to Firestore");
    } else {
      print("No user is currently signed in.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: addUser,  // 버튼 클릭 시 addUser 메서드 호출
          child: Text('Add User to Firestore'),
        ),
      ),
    );
  }
}
