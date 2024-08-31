import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    LibraryScreen(),
    DiscoverScreen(),
    ChallengeScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        backgroundColor: Colors.purple, // 네비게이션 바의 배경 색상
        selectedItemColor: const Color.fromARGB(255, 126, 54, 54), // 선택된 아이템의 색상
        unselectedItemColor: const Color.fromARGB(179, 206, 157, 157), // 선택되지 않은 아이템의 색상
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


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _annualGoal = 0;
  int _booksRead = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _annualGoal = prefs.getInt('bookGoal') ?? 0;
      _booksRead = prefs.getInt('booksRead') ?? 0;
    });
  }

  double get _progressPercentage {
    if (_annualGoal == 0) return 0;
    return _booksRead / _annualGoal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('홈', style: TextStyle(color: Colors.purple[300])),
        backgroundColor: Colors.purple[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '2024 독서 목표',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
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
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.library_books, size: 32, color: Colors.grey[500]),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          "$_annualGoal 권 중 $_booksRead 권을 달성하셨습니다.",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: _progressPercentage,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple[300]!),
                  ),
                  SizedBox(height: 8),
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
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _booksRead++;
                });
                final prefs = await SharedPreferences.getInstance();
                await prefs.setInt('booksRead', _booksRead);
              },
              child: Text('책 읽음 기록 하기'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[300],
                minimumSize: Size(double.infinity, 50), // 버튼의 너비를 최대로, 높이를 50으로 설정
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

// 책 정보 화면
class BookDetailScreen extends StatelessWidget {
  final Book book;
  BookDetailScreen({required this.book}); // 선택된 책 정보를 받아옴

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title), // 책 제목을 화면 제목으로 설정
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '제목: ${book.title}',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              '저자: ${book.author}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: Image.asset(
                'assets/note11.png', // 'note11.png' 이미지 표시
                fit: BoxFit.contain, // 이미지가 화면에 맞게 조정되도록 변경
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class DiscoverScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover'),
      ),
      body: Center(
        child: Text('Discover 화면 - 친구 및 유명인사의 서재 탐방'),
      ),
    );
  }
}


class ChallengeScreen extends StatefulWidget {
  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  String imageUrl = '';

  Future<void> fetchCatImage() async {
    final response = await http.get(Uri.parse('https://api.thecatapi.com/v1/images/search'));
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