import 'dart:convert';
import 'package:http/http.dart' as http;


class Quote {
  final String text;
  final String author;

  Quote({required this.text, required this.author});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      text: json['quote'],
      author: json['author'],
    );
  }
}

class QuoteService {
  static const String _baseUrl = 'https://api.quotable.io/random';

  static Future<Quote> fetchQuote() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      return Quote.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load quote');
    }
  }
}
