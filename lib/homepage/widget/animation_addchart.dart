import 'package:flutter/material.dart';

class AnimatedFlyWidget extends StatefulWidget {
  final Offset start;
  final Offset end;
  final Widget child;
  final VoidCallback onComplete;

  const AnimatedFlyWidget({
    super.key,
    required this.start,
    required this.end,
    required this.onComplete,
    required this.child,
  });

  @override
  State<AnimatedFlyWidget> createState() => _AnimatedFlyWidgetState();
}

class _AnimatedFlyWidgetState extends State<AnimatedFlyWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: widget.start,
      end: widget.end,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward().whenComplete(widget.onComplete);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, child) {
        return Positioned(
          left: _animation.value.dx,
          top: _animation.value.dy,
          child: child!,
        );
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
