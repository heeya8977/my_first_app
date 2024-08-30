import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'genre_selection_screen.dart';
import 'main_screen.dart';

// 책 목표 설정 화면 위젯
class BookGoalScreen extends StatefulWidget {
  @override
  _BookGoalScreenState createState() => _BookGoalScreenState();
}

class _BookGoalScreenState extends State<BookGoalScreen> {
  // 목표 권수 입력을 위한 컨트롤러
  TextEditingController _goalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkExistingGoal(); // 앱 시작 시 기존 목표 확인
  }

  // 기존에 설정된 목표가 있는지 확인하는 함수
  void checkExistingGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int existingGoal = prefs.getInt('bookGoal') ?? 0;
    if (existingGoal > 0) {
      // 이미 목표가 설정되어 있으면 MainScreen으로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    }
  }

  // 장르 선택 화면으로 이동하는 함수
  void _navigateToGenreSelection() async {
    if (_goalController.text.isNotEmpty) {
      int goal = int.parse(_goalController.text);
      // 목표 권수를 SharedPreferences에 저장
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('bookGoal', goal);
      
      // 장르 선택 화면으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GenreSelectionScreen()),
      );
    } else {
      // 목표 권수가 입력되지 않았을 때 알림 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('책의 권수를 입력해주세요!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('2024년 독서 목표를 알려주세요!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '올해 몇 권을 읽을 계획인가요?',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            // 목표 권수 입력 필드
            TextField(
              controller: _goalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '권 수 입력',
              ),
            ),
            SizedBox(height: 20),
            // 확인 버튼
            ElevatedButton(
              onPressed: _navigateToGenreSelection,
              child: Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}