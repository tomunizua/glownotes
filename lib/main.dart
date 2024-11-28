import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'api_service.dart';

void main() {
  runApp(const GlowNotesApp());
}

class GlowNotesApp extends StatelessWidget {
  const GlowNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glow Notes',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _backgroundIndex = 0;
  String _currentBackground = 'assets/background1.jpg';

  final List<String> _backgroundImages = [
    'assets/background1.jpg',
    'assets/background2.jpg',
    'assets/background3.jpg',
  ];

  final List<Widget> _screens = const [
    QuoteScreen(),
    SearchScreen(),
    FavoritesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _changeBackground() {
    setState(() {
      _backgroundIndex = (_backgroundIndex + 1) % _backgroundImages.length;
      _currentBackground = _backgroundImages[_backgroundIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Glow Notes'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              _currentBackground,
              fit: BoxFit.cover,
            ),
          ),
          _screens[_currentIndex],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _changeBackground();
        },
        child: const Icon(Icons.imagesearch_roller),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color.fromARGB(255, 255, 155, 237),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}

class QuoteScreen extends StatelessWidget {
  const QuoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: QuoteOfTheDay(),
    );
  }
}

class QuoteOfTheDay extends StatefulWidget {
  const QuoteOfTheDay({super.key});

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Quote>(
      future: _quote,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
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
                        onPressed: _fetchNewQuote, // Fetch a new quote
                      ),
                      const SizedBox(width: 16.0),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            isFavorite = !isFavorite; // Toggle favorite state
                          });
                        },
                      ),
                      const SizedBox(width: 16.0),
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {
                          // Implement share functionality here
                        },
                      ),
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
