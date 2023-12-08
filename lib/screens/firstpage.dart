import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';

class FirstScreen extends StatelessWidget {
  final double welcomeMessageFontSize = 35.0;
  final double buttonFontSize = 26.0;
  final double buttonSpacing = 70.0;
  final double welcomeMessageSpacing = 528.0;
  final double containerPadding = 20.0;
  final double buttonBottomSpacing = 90.0; // Adjust this value to move buttons up

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'images/1746.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          // Welcome Message
          Positioned(
            left: containerPadding,
            bottom: welcomeMessageSpacing,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(65, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ' Welcome to',
                    style: TextStyle(
                      fontSize: welcomeMessageFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  const Text(
                    'My Enrobe',
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Login Button with Hero Animation
          Positioned(
            left: containerPadding,
            bottom: containerPadding + buttonBottomSpacing,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(1, 10, 20, 10),
              child: Hero(
                tag: 'loginButton',
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  LoginScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.deepOrangeAccent,
                  ),
                  child: Text(
                    '  Login  ',
                    style: TextStyle(fontSize: buttonFontSize),
                  ),
                ),
              ),
            ),
          ),
          // Signup Button with Hero Animation
          Positioned(
            left: containerPadding + buttonSpacing, // Adjust the positioning as needed
            bottom: containerPadding + buttonBottomSpacing,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(140, 10, 10, 10),
              child: Hero(
                tag: 'signupButton',
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.deepOrangeAccent,
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: buttonFontSize),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
