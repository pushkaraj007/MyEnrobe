import 'package:flutter/material.dart';

import 'button.dart';

class AnimatedLoginButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool shouldAnimate; // Flag to indicate whether the animation should be triggered

  AnimatedLoginButton({required this.onPressed, required this.shouldAnimate});

  @override
  _AnimatedLoginButtonState createState() => _AnimatedLoginButtonState();
}

class _AnimatedLoginButtonState extends State<AnimatedLoginButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: CustomButton(
            onPressed: widget.shouldAnimate ? () {
              _animationController.forward();
              widget.onPressed();
            } : widget.onPressed,
            text: 'Login',
            width: 100.0,
            height: 35.0,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
