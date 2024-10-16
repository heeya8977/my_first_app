import 'package:flutter/material.dart';
import '../services/book_api_service.dart';

class DiscoverScreen extends StatefulWidget {
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final BookApiService _bookApiService = BookApiService();
  List<dynamic> _books = [];

  void _searchBooks(String query) async {
    try {
      final books = await _bookApiService.fetchBooks(query);
      setState(() {
        _books = books;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('책 검색하기'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: '책 제목을 입력하세요',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchBooks('Flutter');
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _books.length,
              itemBuilder: (context, index) {
                return ListTile(
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
