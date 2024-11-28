import 'package:flutter/material.dart';
import 'api_service.dart'; // Import your API service or Quote model if necessary

class FavoritesScreen extends StatelessWidget {
  final List<Quote> favoriteQuotes;
  final Function(List<Quote>) onFavoriteUpdated;

  const FavoritesScreen({super.key, required this.favoriteQuotes, required this.onFavoriteUpdated});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: favoriteQuotes.isEmpty
            ? const Center(child: Text('No favorites yet'))
            : ListView.builder(
                itemCount: favoriteQuotes.length,
                itemBuilder: (context, index) {
                  final quote = favoriteQuotes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(quote.text),
                      subtitle: Text(quote.author),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          favoriteQuotes.remove(quote);
                          onFavoriteUpdated(favoriteQuotes);
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
