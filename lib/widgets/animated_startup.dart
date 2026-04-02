import 'package:flutter/material.dart';

class AnimatedStartupWidget extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration length;
  final Curve curve;
  final double begin;
  final double end;
  final double initial;
  final String type;

  const AnimatedStartupWidget({required this.child, this.delay = Duration.zero, this.length = Duration.zero, this.curve = Curves.fastEaseInToSlowEaseOut, this.begin = 0.0, this.end = 1.0, this.initial = 0.0, this.type = 'scale', super.key});

  @override
  State<AnimatedStartupWidget> createState() => _AnimatedStartupWidgetState();
}

class _AnimatedStartupWidgetState extends State<AnimatedStartupWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool _started = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.length,
    );

    Future.delayed(widget.delay, () {
      if (!mounted) return;

      setState(() {
        _started = true;
      });

      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = Tween<double>(
      begin: _started ? widget.begin : widget.initial,
      end: widget.end,
    ).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    if (widget.type == 'fade') {
      return FadeTransition(
        opacity: animation,
        child: widget.child
      );
    } else if (widget.type == 'size') {
      return SizeTransition(
        axis: Axis.horizontal,
        sizeFactor: animation,
        child: widget.child,
      );
    }
    return ScaleTransition(
      scale: animation,
      child: widget.child,
    );
  }
}