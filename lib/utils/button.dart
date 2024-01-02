import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double width;
  final double height;

  CustomButton({
    required this.onPressed,
    required this.text,
    this.width = double.infinity,
    this.height = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
