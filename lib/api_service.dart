import 'dart:convert';
import 'package:http/http.dart' as http;

class Quote {
  final String text;
  final String author;

  Quote({required this.text, required this.author});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      text: json['quoteText'],
      author: json['quoteAuthor'] ?? 'Unknown', // Handle null author
    );
  }
}

class QuoteService {
  static const String _baseUrl = 'https://api.forismatic.com/api/1.0/?method=getQuote&format=json&lang=en';

  static Future<Quote> fetchQuote() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      return Quote.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load quote');
    }
  }

  static Future<List<Quote>> searchQuotes(String query) async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body) as Map<String, dynamic>;
      final quote = Quote.fromJson(jsonMap);
      return [quote]; // Return as a list with a single quote
    } else {
      throw Exception('Failed to load quotes');
    }
  }
}
