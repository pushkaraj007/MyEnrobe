import 'package:flutter/material.dart';
import 'package:trier/screens/avatarhome.dart';
import 'cameracapturescreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InstructionsScreen(),
    );
  }
}

class InstructionsScreen extends StatefulWidget {
  @override
  _InstructionsScreenState createState() => _InstructionsScreenState();
}

class _InstructionsScreenState extends State<InstructionsScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  List<Widget> _instructionPages = [
    InstructionPage(text: 'Stand '),
    InstructionPage(text: 'Follow instruction 2...'),
    // Add more instruction pages as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instructions'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: _instructionPages,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
            ),
          ),
          // Next Button
          ElevatedButton(
            onPressed: () {
              if (_currentPage < _instructionPages.length - 1) {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              } else {
                // Navigate to the next screen when all instructions are completed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AvatarHomeScreen()),
                );
              }
            },
            child: Text(_currentPage == _instructionPages.length - 1 ? 'Start' : 'Next'),
          ),
        ],
      ),
    );
  }
}

class InstructionPage extends StatelessWidget {
  final String text;

  InstructionPage({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }
}
