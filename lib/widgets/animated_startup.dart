import 'package:flutter/material.dart';

class AnimatedStartupWidget extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration length;
  final Curve curve;

  const AnimatedStartupWidget({required this.child, this.delay = Duration.zero, this.length = Duration.zero, this.curve = Curves.fastEaseInToSlowEaseOut, super.key});

  @override
  State<AnimatedStartupWidget> createState() => _AnimatedStartupWidgetState();
}

class _AnimatedStartupWidgetState extends State<AnimatedStartupWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.length,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}