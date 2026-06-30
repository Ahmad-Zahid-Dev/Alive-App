import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedListItem extends StatefulWidget {
  const AnimatedListItem({
    super.key,
    required this.child,
    required this.index,
    this.baseDelay = 60,
    this.slideX = 0.0,
    this.slideY = 0.15,
  });

  final Widget child;
  final int index;
  final int baseDelay;
  final double slideX;
  final double slideY;

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem> {
  bool _animationCompleted = false;

  @override
  Widget build(BuildContext context) {
    if (_animationCompleted) {
      return widget.child;
    }

    return widget.child
        .animate(
          onComplete: (_) {
            if (mounted) {
              setState(() {
                _animationCompleted = true;
              });
            }
          },
        )
        .fadeIn(
          delay: Duration(milliseconds: widget.baseDelay * widget.index),
          duration: const Duration(milliseconds: 350),
        )
        .slide(
          begin: Offset(widget.slideX, widget.slideY),
          end: Offset.zero,
          delay: Duration(milliseconds: widget.baseDelay * widget.index),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
  }
}
