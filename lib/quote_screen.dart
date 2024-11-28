import 'package:flutter/material.dart';
import 'api_service.dart'; // Ensure this is correctly imported

class QuoteScreen extends StatelessWidget {
  final List<Quote> favoriteQuotes;
  final Function(List<Quote>) onFavoriteUpdated;

  const QuoteScreen({super.key, required this.favoriteQuotes, required this.onFavoriteUpdated});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: QuoteOfTheDay(
        favoriteQuotes: favoriteQuotes,
        onFavoriteUpdated: onFavoriteUpdated,
      ),
    );
  }
}

class QuoteOfTheDay extends StatefulWidget {
  final List<Quote> favoriteQuotes;
  final Function(List<Quote>) onFavoriteUpdated;

  const QuoteOfTheDay({super.key, required this.favoriteQuotes, required this.onFavoriteUpdated});

  @override
  _QuoteOfTheDayState createState() => _QuoteOfTheDayState();
}

class _QuoteOfTheDayState extends State<QuoteOfTheDay> {
  late Future<Quote> _quote;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _quote = QuoteService.fetchQuote();
  }

  void _fetchNewQuote() {
    setState(() {
      _quote = QuoteService.fetchQuote();
    });
  }

  void _toggleFavorite(Quote quote) {
    setState(() {
      if (widget.favoriteQuotes.contains(quote)) {
        widget.favoriteQuotes.remove(quote);
      } else {
        widget.favoriteQuotes.add(quote);
      }
      widget.onFavoriteUpdated(widget.favoriteQuotes);
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Quote>(
      future: _quote,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text('No Quote Found');
        } else {
          final quote = snapshot.data!;
          return Card(
            margin: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '"${quote.text}"',
                    style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '- ${quote.author}',
                    style: const TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _fetchNewQuote,
                      ),
                      const SizedBox(width: 16.0),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: () => _toggleFavorite(quote),
                      ),
                      const SizedBox(width: 16.0),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
