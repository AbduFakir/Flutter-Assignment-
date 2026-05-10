import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteResult {
  const QuoteResult({required this.quote, required this.author});
  final String quote;
  final String author;
}

class QuoteService {
  static const _url = 'https://zenquotes.io/api/random';

  Future<QuoteResult> fetchRandom() async {
    final response = await http
        .get(Uri.parse(_url))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Failed to load quote (${response.statusCode})');
    }

    final List<dynamic> data = jsonDecode(response.body);
    final map = data.first as Map<String, dynamic>;

    return QuoteResult(quote: map['q'] as String, author: map['a'] as String);
  }
}
