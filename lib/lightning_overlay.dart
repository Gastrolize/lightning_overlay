library lightning;

import 'package:flutter/material.dart';

class LightningController {
  late final AnimationController _animationController;
  late final AnimationController _animationControllerReverse;

  bool _init = false;

  LightningController();

  void animateIn() {
    if (!_init) return;
    if (_animationController.isAnimating ||
        _animationController.status == AnimationStatus.completed ||
        _animationControllerReverse.isAnimating) return;
    _animationController.forward();
  }

  void animateOut() {
    if (!_init) return;
    if (_animationControllerReverse.isAnimating ||
        _animationControllerReverse.status == AnimationStatus.completed) return;
    if (_animationController.status != AnimationStatus.completed) return;
    _animationControllerReverse.forward();
  }
}

enum LightningDirection { leftToRight, rightToLeft }

class Lightning extends StatefulWidget {
  /// The Duration for the Animation
  final Duration durationIn;

  /// The Duration for the reverse Animation
  final Duration durationOut;

  /// When choosing auto start and the animation fully overlayed the parent aidget, the pause duration will wait and triggers the revere animation.
  final Duration pauseDuration;

  /// The Curve for the Animation
  final Curve curveIn;

  /// The Curve for the reverse Animation
  final Curve curveOut;

  /// Declare the max number of your height or width from your parent widget. If your parent widget has 200 height and 300 width, choose 300.
  final double maxValue;

  /// Using optional controller for firing animation
  final LightningController? controller;

  /// Use gesture mode, when tap down the animation will overlay parent widget. When tap up, the animation will reverse.
  final bool useGesture;

  /// This will delay the auto start for the animation.
  final Duration? delayDuration;

  /// Declare overlay color
  final Color overlayColor;

  /// Pass your child
  final Widget child;

  /// Border radius for parent child
  final double borderRadius;

  /// Animation Direction
  final LightningDirection direction;

  /// Repeat after paused Delay
  final bool repeat;

  /// Delay for repeatMode
  final Duration pauseRepeatDelay;

  const Lightning(
      {super.key,
      required this.maxValue,
      required this.child,
      this.delayDuration = const Duration(milliseconds: 500),
      this.useGesture = false,
      this.borderRadius = 0,
      this.repeat = false,
      this.controller,
      this.pauseRepeatDelay = const Duration(seconds: 2),
      this.overlayColor = const Color.fromRGBO(255, 255, 255, 0.1),
      this.pauseDuration = const Duration(milliseconds: 200),
      this.durationIn = const Duration(milliseconds: 300),
      this.durationOut = const Duration(milliseconds: 600),
      this.curveIn = Curves.easeIn,
      this.curveOut = Curves.linear,
      this.direction = LightningDirection.leftToRight});
  @override
  State<Lightning> createState() => _LightningState();
}

class _LightningState extends State<Lightning> with TickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> animation;

  late final AnimationController animationControllerReverse;
  late final Animation<double> animationReverse;

  late LightningController _lightningController;

  bool triggeredAnimation = false;

  @override
  void didUpdateWidget(covariant Lightning oldWidget) {
    if (oldWidget.pauseDuration != widget.pauseDuration) {
      super.didUpdateWidget(oldWidget);
    } else if (oldWidget.maxValue != widget.maxValue) {
      super.didUpdateWidget(oldWidget);
    } else if (oldWidget.durationIn != widget.durationIn) {
      super.didUpdateWidget(oldWidget);
    } else if (oldWidget.durationOut != widget.durationOut) {
      super.didUpdateWidget(oldWidget);
    } else if (oldWidget.curveIn != widget.curveIn) {
      super.didUpdateWidget(oldWidget);
    } else if (oldWidget.curveOut != widget.curveOut) {
      super.didUpdateWidget(oldWidget);
    } else if (oldWidget.delayDuration != widget.delayDuration) {
      super.didUpdateWidget(oldWidget);
    } else if (oldWidget.direction != widget.direction) {
      super.didUpdateWidget(oldWidget);
    }
  }

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: widget.durationIn,
    );

    animationControllerReverse = AnimationController(
      vsync: this,
      duration: widget.durationOut,
    );

    _lightningController = widget.controller ?? LightningController();
    _lightningController._animationController = animationController;
    _lightningController._animationControllerReverse =
        animationControllerReverse;
    _lightningController._init = true;
    animation = Tween<double>(begin: 0, end: widget.maxValue * 2).animate(
        CurvedAnimation(parent: animationController, curve: widget.curveIn));

    animationReverse = Tween<double>(begin: 0, end: widget.maxValue * 2)
        .animate(CurvedAnimation(
            parent: animationControllerReverse, curve: widget.curveOut));

    super.initState();
    if (widget.delayDuration != null && mounted) {
      Future.delayed(widget.delayDuration!).then((value) {
        _lightningController.animateIn();
        Future.delayed(widget.pauseDuration)
            .then((value) => _lightningController.animateOut());
      });
    }
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!widget.useGesture && mounted) {
          Future.delayed(widget.pauseDuration).then((_) {
            animationControllerReverse.forward();
          });
        }
      }
    });

    animationControllerReverse.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          animationController.reset();
          animationControllerReverse.reset();
          if (widget.repeat && mounted) {
            Future.delayed(widget.pauseRepeatDelay)
                .then((value) => animationController.forward());
          }
        });
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    animationControllerReverse.dispose();
    super.dispose();
  }

  void animate() {
    if (triggeredAnimation) return;
    setState(() {
      triggeredAnimation = true;
    });
    if (mounted) _lightningController.animateIn();
  }

  Future<void> waitForPause() async {
    await Future.delayed(widget.pauseDuration);
  }

  /// For covering
  void _onTap() {
    if (animationController.isAnimating ||
        animationController.status == AnimationStatus.completed ||
        animationControllerReverse.isAnimating) return;
    if (mounted) animationController.forward();
  }

  void _onTapDown(TapDownDetails _) {
    if (animationController.isAnimating ||
        animationController.status == AnimationStatus.completed ||
        animationControllerReverse.isAnimating) return;

    if (mounted) animationController.forward();
  }

  /// For covering out
  void _onTapUp(TapUpDetails _) {
    if (animationControllerReverse.isAnimating ||
        animationControllerReverse.status == AnimationStatus.completed) return;
    waitForPause().then((value) {
      if (mounted) animationControllerReverse.forward();
    });
  }

  void _onTapCancel() {
    if (animationControllerReverse.isAnimating ||
        animationControllerReverse.status == AnimationStatus.completed) return;
    if (animationController.status != AnimationStatus.completed) return;

    if (mounted) animationControllerReverse.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.useGesture) {
      return Stack(
        children: [
          widget.child,
          Positioned.fill(
            child: AnimatedBuilder(
              animation: Listenable.merge([animation, animationReverse]),
              builder: (context, child) {
                return ClipPath(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  clipper: _Light(
                      progress: animation.value,
                      reverseProgress: animationReverse.value,
                      lightningDirection: widget.direction),
                  child: child,
                );
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: Container(color: widget.overlayColor)),
            ),
          ),
        ],
      );
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onLongPressUp: _onTapCancel,
      onTap: _onTap,
      child: Stack(
        children: [
          widget.child,
          Positioned.fill(
            child: AnimatedBuilder(
              animation: Listenable.merge([animation, animationReverse]),
              builder: (context, child) {
                return ClipPath(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  clipper: _Light(
                      progress: animation.value,
                      reverseProgress: animationReverse.value,
                      lightningDirection: widget.direction),
                  child: child,
                );
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: Container(color: widget.overlayColor)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Light extends CustomClipper<Path> {
  final double progress;
  final double reverseProgress;
  final LightningDirection lightningDirection;
  _Light(
      {required this.progress,
      required this.reverseProgress,
      required this.lightningDirection});

  @override
  Path getClip(Size size) {
    final path = Path();

    if (lightningDirection == LightningDirection.leftToRight) {
      path.moveTo(0, 0);

      path.lineTo(reverseProgress, 0);

      ///  X Axis
      path.lineTo(0, reverseProgress);

      ///  Y Axis

      path.lineTo(0, progress);

      ///  Y Axis
      path.lineTo(progress, 0);

      ///  X Axis
    } else {
      path.moveTo(size.width, size.height);

      path.lineTo(size.width, size.height - progress);

      ///  Y Axis
      path.lineTo(size.width - progress, size.height);

      ///  X Axis

      path.lineTo(size.width - reverseProgress, size.height);

      ///  X Axis
      path.lineTo(size.width, size.height - reverseProgress);

      ///  Y Axis
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
