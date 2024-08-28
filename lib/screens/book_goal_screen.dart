import 'package:flutter/material.dart';
import 'genre_selection_screen.dart';

class BookGoalScreen extends StatefulWidget {
  @override
  _BookGoalScreenState createState() => _BookGoalScreenState();
}

class _BookGoalScreenState extends State<BookGoalScreen> {
  TextEditingController _goalController = TextEditingController();

  void _navigateToGenreSelection() {
    // 목표가 입력되었을 때만 다음 화면으로 이동
    if (_goalController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GenreSelectionScreen()),
      );
    } else {
      // 목표 입력을 유도하는 간단한 알림
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
            TextField(
              controller: _goalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '권 수 입력',
              ),
            ),
            SizedBox(height: 20),
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
