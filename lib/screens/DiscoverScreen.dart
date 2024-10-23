import 'package:flutter/material.dart';
import '../services/book_api_service.dart';

// DiscoverScreen 클래스는 사용자가 책을 검색할 수 있는 화면을 제공합니다.
class DiscoverScreen extends StatefulWidget {
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

// DiscoverScreen의 상태 클래스입니다. 이 클래스는 UI의 상태를 관리합니다.
class _DiscoverScreenState extends State<DiscoverScreen> {
  // BookApiService의 인스턴스를 생성합니다. 이 인스턴스를 통해 책 정보를 가져옵니다.
  final BookApiService _bookApiService = BookApiService();
  // 검색된 책 정보를 저장할 리스트입니다.
  List<dynamic> _books = [];
  // 사용자가 입력한 검색어를 저장할 컨트롤러입니다.
  TextEditingController _searchController = TextEditingController();

  // 사용자가 입력한 검색어로 책을 검색하는 함수입니다.
  void _searchBooks(String query) async {
    try {
      // BookApiService를 사용해 책 정보를 가져옵니다.
      final books = await _bookApiService.fetchBooks(query);
      // 검색 결과를 상태에 반영하여 UI를 업데이트합니다.
      setState(() {
        _books = books;
      });
    } catch (e) {
      // 에러가 발생했을 때 에러 메시지를 출력합니다.
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 앱바에 표시될 제목입니다.
        title: Text('책 검색하기'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController, // 사용자가 입력한 검색어를 관리하는 컨트롤러입니다.
              // 사용자가 검색어를 입력할 수 있는 텍스트 필드입니다.
              decoration: InputDecoration(
                labelText: '책 제목을 입력하세요',
                // 검색 버튼 아이콘을 제공합니다.
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // 사용자가 입력한 검색어로 책을 검색합니다.
                    _searchBooks(_searchController.text);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            // 검색된 책 정보를 리스트 형태로 표시합니다.
            child: ListView.builder(
              itemCount: _books.length, // 리스트의 항목 개수를 설정합니다.
              itemBuilder: (context, index) {
                return ListTile(
                  // 책의 이미지, 제목, 저자를 리스트 항목에 표시합니다.
                  leading: Image.network(_books[index]['image']),
                  title: Text(_books[index]['title']),
                  subtitle: Text(_books[index]['author']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
