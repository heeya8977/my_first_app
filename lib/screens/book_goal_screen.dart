import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'genre_selection_screen.dart';
import 'main_screen.dart';

// 디버그 모드 플래그
const bool isDebugMode = true; // 디버깅 시 true, 실제 사용 시 false

class BookGoalScreen extends StatefulWidget {
  @override
  _BookGoalScreenState createState() => _BookGoalScreenState();
}

class _BookGoalScreenState extends State<BookGoalScreen> {
  TextEditingController _goalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (!isDebugMode) {
      checkExistingGoal();
    }
  }

  void checkExistingGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int existingGoal = prefs.getInt('bookGoal') ?? 0;
    if (existingGoal > 0) {
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
        title: Text('2024년 독서 목표를 알려주세요!', style: TextStyle(color: const Color.fromARGB(255, 91, 91, 91))),
        backgroundColor: const Color.fromARGB(255, 213, 207, 185),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/flutter003.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.1),
              BlendMode.lighten,
            ),
          ),
        ),
        // 내용 패딩 설정
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 목표 설정 안내 텍스트
              Text(
                '올해 몇 권을 읽을 계획인가요?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 20),
              // 목표 권수 입력 필드
              TextField(
                controller: _goalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '권 수 입력',
                  fillColor: Colors.white.withOpacity(0.8),
                  filled: true,
                ),
              ),
              SizedBox(height: 20),
              //확인 버튼 
              ElevatedButton(
                onPressed: _navigateToGenreSelection,
                child: Text('확인'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 228, 229, 201),
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}