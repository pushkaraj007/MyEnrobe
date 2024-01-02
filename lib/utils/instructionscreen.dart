import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'cameracapturescreen.dart'; // Import your existing CameraCaptureScreen


class InstructionsScreen extends StatefulWidget {
  @override
  _InstructionsScreenState createState() => _InstructionsScreenState();
}

class _InstructionsScreenState extends State<InstructionsScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  late CameraController _cameraController;

  List<Widget> _instructionPages = [
     InstructionPage(
      text: 'Make Sure\nTo have a contrasting background colour with good lighting',
    ),InstructionPage(
      text: 'Make Sure\nPlease stand within the box on the screen',
    ),InstructionPage(
      text: 'Make Sure\nTo have both your arms and hands visible',
    ),InstructionPage(
      text: 'Make Sure\nTo select correct gender and sizes',
    ),
    // Add more instruction pages as needed
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the camera controller here
    _initializeCameraController();
  }

  Future<void> _initializeCameraController() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    await _cameraController.initialize();
  }

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
          Container(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
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
                    MaterialPageRoute(
                      builder: (context) => CameraCaptureScreen(
                        cameraController: _cameraController,
                      ),
                    ),
                  );
                }
              },
              child: Text(_currentPage == _instructionPages.length - 1 ? 'Start' : 'Next'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Customize button color
                textStyle: TextStyle(fontSize: 20.0), // Customize text style
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the camera controller when the widget is disposed
    _cameraController.dispose();
    super.dispose();
  }
}

class InstructionPage extends StatelessWidget {
  final String text;

  InstructionPage({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 20.0),
          ),
        ],
      ),
    );
  }
}
