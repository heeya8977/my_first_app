import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_first_app/services/chat_service.dart';
import 'package:my_first_app/screens/chat_screen.dart'; 
import 'package:my_first_app/screens/UserListScreen.dart';
import 'DiscoverScreen.dart';

// 메인 화면을 관리하는 StatefulWidget
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

// MainScreen의 상태를 관리하는 State 클래스
class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // 현재 선택된 탭의 인덱스

  // 각 탭에 해당하는 화면 위젯들
  final List<Widget> _screens = [
    HomeScreen(),
    LibraryScreen(),
    DiscoverScreen(),
    ChallengeScreen(),
  ];

  // 탭이 탭될 때 호출되는 메서드
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // 현재 선택된 화면 표시
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        backgroundColor: const Color.fromARGB(221, 35, 8, 40), // 네비게이션 바의 배경 색상
        selectedItemColor:
            const Color.fromARGB(255, 126, 54, 54), // 선택된 아이템의 색상
        unselectedItemColor:
            const Color.fromARGB(179, 206, 157, 157), // 선택되지 않은 아이템의 색상
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: '나의 서재',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: '챌린지',
          ),
        ],
      ),
    );
  }
}

// 홈 화면을 관리하는 StatefulWidget
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// HomeScreen의 상태를 관리하는 State 클래스
class _HomeScreenState extends State<HomeScreen> {
  int _annualGoal = 0; // 연간 독서 목표
  int _booksRead = 0; // 읽은 책의 수

  @override
  void initState() {
    super.initState();
    _loadData(); // 초기 데이터 로드
  }

  // SharedPreferences에서 데이터를 로드하는 메서드
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _annualGoal = prefs.getInt('bookGoal') ?? 0;
      _booksRead = prefs.getInt('booksRead') ?? 0;
    });
  }

  // 독서 진행률을 계산하는 getter
  double get _progressPercentage {
    if (_annualGoal == 0) return 0;
    return _booksRead / _annualGoal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('당신의 성장을 응원합니다.',
            style: TextStyle(color: const Color.fromARGB(255, 91, 91, 91))),
        backgroundColor: const Color.fromARGB(255, 213, 207, 185),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/flutter003.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.1), // 투명도를 낮춰 이미지를 더 선명하게 표시
              BlendMode.lighten,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목 텍스트
              Text(
                '2024 독서 목표',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // 텍스트 색상을 어둡게 하여 가독성 향상
                ),
              ),
              SizedBox(height: 20),
              // 독서 진행 상황을 보여주는 카드
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 책 아이콘과 독서 현황 텍스트
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.library_books,
                              size: 32, color: Colors.grey[500]),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            " $_annualGoal 권 중에 $_booksRead 권을 읽으셨네요! ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // 진행률을 보여주는 프로그레스 바
                    LinearProgressIndicator(
                      value: _progressPercentage,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                          const Color.fromARGB(255, 225, 228, 190)),
                    ),
                    SizedBox(height: 8),
                    // 진행률 퍼센티지 표시
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${(_progressPercentage * 100).toInt()}%',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // 책 읽음 기록 버튼
              ElevatedButton(
                onPressed: () async {
                  final currentUser = FirebaseAuth.instance.currentUser;
                  if (currentUser != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UserListScreen(currentUserId: currentUser.uid),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('로그인이 필요합니다.')),
                    );
                  }
                },
                child: Text('채팅 시작하기'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 232, 230, 181),
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ], // Column의 children 끝
          ), // Column 끝
        ), // Padding 끝
      ), // Container 끝
    ); // Scaffold 끝
  } // build 함수 끝
} // _HomeScreenState 클래스 끝

// 책 정보를 저장하는 데이터 클래스
class Book {
  final String title;
  final String author;
  final String imagePath;

  Book({required this.title, required this.author, required this.imagePath});
}

// '나의 서재' 화면
class LibraryScreen extends StatelessWidget {
  // 가상의 책 목록 (제목, 저자, 이미지 경로)
  final List<Book> books = [
    Book(title: '책 1', author: '저자 1', imagePath: 'assets/cozy.webp'),
    Book(title: '책 2', author: '저자 2', imagePath: 'assets/cozy.webp'),
    Book(title: '책 3', author: '저자 3', imagePath: 'assets/cozy.webp'),
    Book(title: '책 4', author: '저자 4', imagePath: 'assets/cozy.webp'),
    Book(title: '책 5', author: '저자 5', imagePath: 'assets/cozy.webp'),
    Book(title: '책 6', author: '저자 6', imagePath: 'assets/cozy.webp'),
    Book(title: '책 7', author: '저자 7', imagePath: 'assets/cozy.webp'),
    Book(title: '책 8', author: '저자 8', imagePath: 'assets/cozy.webp'),
    Book(title: '책 9', author: '저자 9', imagePath: 'assets/cozy.webp'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('나의 서재'),
      ),
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/cozy.webp', // 배경 이미지 경로
              fit: BoxFit.cover, // 화면 전체에 이미지를 맞춤
            ),
          ),
          // 그리드 오버레이
          GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 한 줄에 3개의 아이템을 배치
              crossAxisSpacing: 16.0, // 아이템 간의 가로 간격
              mainAxisSpacing: 16.0, // 아이템 간의 세로 간격
            ),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return GestureDetector(
                onTap: () {
                  // 책 아이템 클릭 시 책 정보 화면으로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetailScreen(book: book),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent, // 완전히 투명한 배경 적용
                  ),
                  child: Center(
                    child: Text(
                      book.title, // 책 제목 표시
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.transparent, // 텍스트 색상 흰색으로 설정
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class BookDetailScreen extends StatefulWidget {
  final Book book;
  BookDetailScreen({required this.book});

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late TextEditingController _noteController;
  late DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
    _currentDate = DateTime.now();
    _loadNote();
  }

  Future<void> _loadNote() async {
    final prefs = await SharedPreferences.getInstance();
    final note = prefs.getString('note_${widget.book.title}') ?? '';
    setState(() {
      _noteController.text = note;
    });
  }

  Future<void> _saveNote() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('note_${widget.book.title}', _noteController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('노트가 저장되었습니다.')),
    );
  }

  Future<void> _addImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // 이미지 처리 로직 구현
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미지가 추가되었습니다.')),
      );
    }
  }

  void _changeTextStyle() {
    // 텍스트 스타일 변경 로직 구현
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('텍스트 스타일 변경 기능이 실행되었습니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5E6D3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.image, color: Colors.black),
            onPressed: _addImage,
          ),
          IconButton(
            icon: Icon(Icons.text_fields, color: Colors.black),
            onPressed: _changeTextStyle,
          ),
          IconButton(
            icon: Icon(Icons.check, color: Colors.purple[300]),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.book, size: 18),
              label: Text('책 속 문장'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[300],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              onPressed: () {
                // 책 속 문장 기능 구현
              },
            ),
            SizedBox(height: 16),
            Text(
              DateFormat('yyyy. M. d. a h:mm').format(_currentDate),
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _noteController,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '노트 내용을 입력해보세요.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}

//class DiscoverScreen extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Discover'),
//      ),
//      body: Center(
//        child: Text('Discover 화면 - 친구 및 유명인사의 서재 탐방'),
//      ),
//    );
 // }
//}

class ChallengeScreen extends StatefulWidget {
  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  String imageUrl = '';

  Future<void> fetchCatImage() async {
    final response =
        await http.get(Uri.parse('https://api.thecatapi.com/v1/images/search'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        imageUrl = data[0]['url'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('챌린지'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('독서 챌린지 화면', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            imageUrl.isNotEmpty
                ? Image.network(imageUrl, height: 200)
                : Text('고양이 사진을 불러오려면 버튼을 눌러주세요!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchCatImage,
              child: Text('귀여운 고양이 보기'),
            ),
            SizedBox(height: 20),
            Text('고양이와 함께 독서 챌린지에 도전해보세요!', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

