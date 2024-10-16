import 'package:http/http.dart' as http;
import 'dart:convert';

class BookApiService {
  final String clientId = '4Tmgv53I431S4uN9D2tt';
  final String clientSecret = 'xbGq4zxtL_';

  Future<List<dynamic>> fetchBooks(String query) async {
    final response = await http.get(
      Uri.parse('https://openapi.naver.com/v1/search/book.json?query=$query'),
      headers: {
        'X-Naver-Client-Id': clientId,
        'X-Naver-Client-Secret': clientSecret,
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['items'];
    } else {
      throw Exception('Failed to load books');
    }
  }
}
