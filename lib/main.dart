import 'package:flutter/material.dart';
import 'quote_screen.dart';
import 'favorites_screen.dart';
import 'search_screen.dart';
import 'my_quotes_screen.dart';
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
  List<Quote> favoriteQuotes = []; // Shared list of favorite quotes
  List<Quote> userQuotes = [];

  final List<String> _backgroundImages = [
    'assets/background1.jpg',
    'assets/background2.jpg',
    'assets/background3.jpg',
  ];

  // Method to handle navigation item tap 
  void _onItemTapped(int index) { 
    setState(() { 
      _currentIndex = index; 
      }); 
    } 

  // Method to change the background image 
  void _changeBackground() { 
    setState(() {
       _backgroundIndex = (_backgroundIndex + 1) % _backgroundImages.length; 
       _currentBackground = _backgroundImages[_backgroundIndex]; 
       }); 
      } 
      
  // Method to add user-submitted quotes 
  void _addUserQuote(String quote, String author) { 
    setState(() { 
      userQuotes.add(Quote(text: quote, author: author)); 
      }); 
    }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      QuoteScreen(favoriteQuotes: favoriteQuotes, onFavoriteUpdated: (quotes) {
        setState(() {
          favoriteQuotes = quotes;
        });
      }), // Pass favorite quotes to QuoteScreen
      SearchScreen(),
      FavoritesScreen(favoriteQuotes: favoriteQuotes, onFavoriteUpdated: (quotes) {
        setState(() {
          favoriteQuotes = quotes;
        });
      }), // Pass favorite quotes to FavoritesScreen
      MyQuotesScreen(onQuoteSubmitted: _addUserQuote), // Add MyQuotesScreen
    ];

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
        onPressed: _changeBackground,
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
          BottomNavigationBarItem( 
            icon: Icon(Icons.create), // Use pen icon for My Quotes 
            label: 'My Quotes', 
          ),
        ],
      ),
    );
  }
}
