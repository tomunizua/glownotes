import 'package:flutter/material.dart';

class MyQuotesScreen extends StatefulWidget {
  final Function(String, String) onQuoteSubmitted;

  MyQuotesScreen({required this.onQuoteSubmitted});

  @override
  _MyQuotesScreenState createState() => _MyQuotesScreenState();
}

class _MyQuotesScreenState extends State<MyQuotesScreen> {
  final _quoteController = TextEditingController();
  final _authorController = TextEditingController();
  List<Map<String, String>> submittedQuotes = [];

  void _submitQuote() {
    if (_quoteController.text.isNotEmpty && _authorController.text.isNotEmpty) {
      widget.onQuoteSubmitted(_quoteController.text, _authorController.text);
      
      setState(() {
        submittedQuotes.add({
          'quote': _quoteController.text,
          'author': _authorController.text,
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Quote added successfully!'),
        ),
      );

      _quoteController.clear();
      _authorController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter both a quote and an author.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Quotes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You can also input your own quote!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _quoteController,
              decoration: InputDecoration(
                labelText: 'Quote',
              ),
            ),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(
                labelText: 'Author',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitQuote,
              child: Text('Submit Quote'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: submittedQuotes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(submittedQuotes[index]['quote']!),
                    subtitle: Text(submittedQuotes[index]['author']!),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _quoteController.dispose();
    _authorController.dispose();
    super.dispose();
  }
}
