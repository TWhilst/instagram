import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  // this is used to make like animation the parent widget
  // this is used to take in a widget as the argument of the class like animation
  final Widget child;
  final bool isAnimating;
  // this tells us how long the like animation should continue
  final Duration duration;
  // this is what will be called to end the like animation
  final VoidCallback? onEnd;
  // this is to check if the like button was clicked or not
  final bool smallLike;
  const LikeAnimation({Key? key,
    required this.child,  this.duration = const Duration(milliseconds: 150),
    required this.isAnimating,  this.onEnd,
     this.smallLike = false,
  }) : super(key: key);

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

// the SingleTickerProviderStateMixin is used to access the animation
class _LikeAnimationState extends State<LikeAnimation> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    // what the syntax(~/ 2) does is that it divides the value of widget.duration.inMilliseconds by 2 and converts it to integer
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration.inMilliseconds ~/2));
    scale = Tween<double>(begin: 1, end: 1.2).animate(controller);
  }

  // this will be called when the current widget is replaced by another widget
  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.isAnimating != oldWidget.isAnimating) {
      startAnimation();
    }
  }

  startAnimation() async {
    if(widget.isAnimating || widget.smallLike) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(const Duration(milliseconds: 200));

      if(widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
