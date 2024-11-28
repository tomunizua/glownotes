import 'package:flutter/material.dart';
import 'api_service.dart'; // Ensure this is correctly imported

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<List<Quote>>? _searchResults;
  String _query = '';

  void _performSearch(String query) {
    setState(() {
      _query = query;
      _searchResults = QuoteService.searchQuotes(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Quotes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search for inspiration...',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                if (value.length >= 3) { // Perform search after at least 3 characters
                  _performSearch(value);
                }
              },
            ),
            const SizedBox(height: 16.0),
            _searchResults == null
                ? const Center(child: Text('Enter a search query to find quotes'))
                : FutureBuilder<List<Quote>>(
                    future: _searchResults,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No quotes found'));
                      } else {
                        final quotes = snapshot.data!;
                        return Expanded(
                          child: ListView.builder(
                            itemCount: quotes.length,
                            itemBuilder: (context, index) {
                              final quote = quotes[index];
                              return ListTile(
                                title: Text(quote.text),
                                subtitle: Text(quote.author),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
