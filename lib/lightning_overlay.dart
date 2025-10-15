/// A Flutter package that provides a lightning overlay effect for widgets.
///
/// This library allows you to add animated lightning effects to any widget,
/// with customizable directions, colors, durations, and curves.
library lightning;

import 'dart:async';

import 'package:flutter/material.dart';

/// Controller for manually triggering lightning animations.
///
/// Use this controller to programmatically start and stop lightning animations
/// instead of relying on automatic triggers or gestures.
class LightningController {
  AnimationController? _animationController;
  AnimationController? _animationControllerReverse;
  bool _isDisposed = false;

  /// Starts the lightning animation (animates the overlay in).
  ///
  /// This method will only work if:
  /// - The controller is not disposed
  /// - No animation is currently running
  /// - The animation is not already completed
  void animateIn() {
    if (_isDisposed || _animationController == null) return;
    if (_animationController!.isAnimating ||
        _animationController!.status == AnimationStatus.completed ||
        _animationControllerReverse?.isAnimating == true) {
      return;
    }
    _animationController!.forward();
  }

  /// Starts the reverse animation (animates the overlay out).
  ///
  /// This method will only work if:
  /// - The controller is not disposed
  /// - The forward animation has completed
  /// - No reverse animation is currently running
  void animateOut() {
    if (_isDisposed || _animationControllerReverse == null) return;
    if (_animationControllerReverse!.isAnimating ||
        _animationControllerReverse!.status == AnimationStatus.completed) {
      return;
    }
    if (_animationController?.status != AnimationStatus.completed) return;
    _animationControllerReverse!.forward();
  }

  /// Internal method to initialize the controller with animation controllers.
  ///
  /// This is called by the Lightning widget during initialization.
  void _init(
      AnimationController controller, AnimationController reverseController) {
    _animationController = controller;
    _animationControllerReverse = reverseController;
  }

  /// Disposes the controller and cleans up references.
  ///
  /// After calling this method, the controller cannot be used anymore.
  /// This is automatically called when the Lightning widget is disposed.
  void dispose() {
    _isDisposed = true;
    _animationController = null;
    _animationControllerReverse = null;
  }
}

/// Defines the direction of the lightning animation.
///
/// - [leftToRight]: Lightning effect moves from left to right
/// - [rightToLeft]: Lightning effect moves from right to left
enum LightningDirection { leftToRight, rightToLeft }

/// A widget that applies a lightning overlay effect to its child.
///
/// The Lightning widget wraps a child widget and applies an animated
/// lightning effect overlay. The effect can be triggered automatically,
/// manually via a controller, or through gestures.
///
/// Example usage:
/// ```dart
/// Lightning(
///   child: Container(
///     width: 200,
///     height: 100,
///     color: Colors.blue,
///     child: Text('Tap me!'),
///   ),
///   useGesture: true,
///   overlayColor: Colors.white.withOpacity(0.3),
/// )
/// ```
class Lightning extends StatefulWidget {
  /// Duration for the lightning effect to animate in (appear).
  ///
  /// This controls how long it takes for the lightning effect to fully appear.
  /// Default is 300 milliseconds.
  final Duration durationIn;

  /// Duration for the lightning effect to animate out (disappear).
  ///
  /// This controls how long it takes for the lightning effect to fully disappear.
  /// Default is 600 milliseconds.
  final Duration durationOut;

  /// Duration to pause between the in and out animations.
  ///
  /// After the lightning effect has fully appeared, it will wait for this
  /// duration before starting to disappear. Default is 200 milliseconds.
  final Duration pauseDuration;

  /// Animation curve for the lightning effect appearing.
  ///
  /// This curve controls the easing of the lightning effect as it appears.
  /// Default is [Curves.easeIn].
  final Curve curveIn;

  /// Animation curve for the lightning effect disappearing.
  ///
  /// This curve controls the easing of the lightning effect as it disappears.
  /// Default is [Curves.linear].
  final Curve curveOut;

  /// Optional controller to manually trigger animations.
  ///
  /// If provided, you can use [LightningController.animateIn] and
  /// [LightningController.animateOut] to manually control the animation.
  /// If null, a default controller will be created internally.
  final LightningController? controller;

  /// Whether the animation can be triggered by tapping the widget.
  ///
  /// When true:
  /// - Tap down starts the lightning effect
  /// - Tap up or tap cancel ends the lightning effect
  /// When false, the animation must be triggered manually or automatically.
  /// Default is false.
  final bool useGesture;

  /// Delay before the first automatic animation starts.
  ///
  /// If provided, the lightning effect will automatically start after this
  /// delay when the widget is first built. If null, no automatic animation
  /// will occur. Default is 500 milliseconds.
  final Duration? delayDuration;

  /// Color of the lightning overlay effect.
  ///
  /// This color will be used for the lightning overlay that appears over
  /// the child widget. Default is a semi-transparent white.
  final Color overlayColor;

  /// The child widget to apply the lightning effect on.
  ///
  /// This is the widget that will have the lightning effect overlaid on top.
  /// The effect will match the size and shape of this child widget.
  final Widget child;

  /// Border radius for the lightning overlay.
  ///
  /// If the child widget has rounded corners, set this to match those corners
  /// for a better visual effect. Default is 0 (no rounded corners).
  final double borderRadius;

  /// Direction of the lightning effect animation.
  ///
  /// Controls whether the lightning effect moves from left to right or
  /// right to left. Default is [LightningDirection.leftToRight].
  final LightningDirection direction;

  /// Whether the animation should repeat indefinitely.
  ///
  /// When true, the lightning effect will continuously repeat with pauses
  /// in between defined by [pauseRepeatInfinityDelay]. Default is false.
  final bool repeatInfinity;

  /// Pause duration between animation repeats.
  ///
  /// Only used when [repeatInfinity] is true. This defines how long to wait
  /// between each repeat cycle. Default is 2 seconds.
  final Duration pauseRepeatInfinityDelay;

  /// Whether the animation should start once widget is rendered
  final bool autoStart;

  /// Creates a Lightning widget.
  ///
  /// The [child] parameter is required and represents the widget that will
  /// have the lightning effect applied to it.
  const Lightning(
      {super.key,
      required this.child,
      this.delayDuration = const Duration(milliseconds: 500),
      this.useGesture = false,
      this.borderRadius = 0,
      this.repeatInfinity = false,
      this.controller,
      this.pauseRepeatInfinityDelay = const Duration(seconds: 2),
      this.overlayColor = const Color.fromRGBO(255, 255, 255, 0.1),
      this.pauseDuration = const Duration(milliseconds: 200),
      this.durationIn = const Duration(milliseconds: 300),
      this.durationOut = const Duration(milliseconds: 600),
      this.curveIn = Curves.easeIn,
      this.curveOut = Curves.linear,
      this.direction = LightningDirection.leftToRight,
      this.autoStart = true});

  @override
  State<Lightning> createState() => _LightningState();
}

/// Private state class for the Lightning widget.
///
/// Manages the animation controllers, timing, and rendering of the lightning effect.
class _LightningState extends State<Lightning> with TickerProviderStateMixin {
  /// Animation controller for the lightning effect appearing.
  late final AnimationController _animationController;

  /// Animation controller for the lightning effect disappearing.
  late final AnimationController _animationControllerReverse;

  /// Animation that drives the lightning effect appearing.
  late Animation<double> _animation;

  /// Animation that drives the lightning effect disappearing.
  late Animation<double> _animationReverse;

  /// Controller instance for manual animation control.
  late final LightningController _lightningController;

  /// Global key to access the child widget's render object for size calculation.
  final GlobalKey _childKey = GlobalKey();

  /// Maximum value for animations based on child widget size.
  double _maxValue = 0;

  late bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupController();

    // Schedule size calculation and auto-start after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateMaxValue();
      if (mounted && widget.autoStart) {
        _scheduleAutoStart();
      }
    });
  }

  /// Initializes the animation controllers and animations.
  ///
  /// Sets up the forward and reverse animation controllers with their
  /// respective durations and curves.
  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.durationIn,
    );

    _animationControllerReverse = AnimationController(
      vsync: this,
      duration: widget.durationOut,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: widget.curveIn),
    );

    _animationReverse = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _animationControllerReverse, curve: widget.curveOut),
    );

    _setupAnimationListeners();
  }

  /// Sets up the lightning controller.
  ///
  /// Uses the provided controller or creates a new one, then initializes it
  /// with the animation controllers.
  void _setupController() {
    _lightningController = widget.controller ?? LightningController();
    _lightningController._init(
        _animationController, _animationControllerReverse);
  }

  /// Sets up listeners for animation status changes.
  ///
  /// These listeners handle the timing between animations and repetition logic.
  void _setupAnimationListeners() {
    _animationController.addStatusListener(_onAnimationInComplete);
    _animationControllerReverse.addStatusListener(_onAnimationOutComplete);
  }

  /// Handles completion of the lightning in animation.
  ///
  /// When the lightning effect has fully appeared, this starts the pause
  /// before beginning the out animation (unless using gestures).
  void _onAnimationInComplete(AnimationStatus status) {
    if (status == AnimationStatus.completed && !widget.useGesture && mounted) {
      Future.delayed(widget.pauseDuration, () {
        if (mounted) {
          _animationControllerReverse.forward();
        }
      });
    }
  }

  /// Handles completion of the lightning out animation.
  ///
  /// When the lightning effect has fully disappeared, this resets the
  /// animations and handles repetition if enabled.
  void _onAnimationOutComplete(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      _animationController.reset();
      _animationControllerReverse.reset();

      if (widget.repeatInfinity) {
        Future.delayed(widget.pauseRepeatInfinityDelay, () {
          if (mounted) _animationController.forward();
        });
      }
    }
  }

  /// Calculates the maximum animation value based on child widget size.
  ///
  /// Gets the render box of the child widget and uses its height * 2
  /// as the maximum value for smooth lightning animations.
  void _calculateMaxValue() {
    final RenderBox? renderBox =
        _childKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final size = renderBox.size;
      _maxValue = size.height * 2;

      // Update animations with new max value
      if (_maxValue > 0) {
        _updateAnimationTweens();
      }
    }
  }

  /// Updates animation tweens with the calculated maximum value.
  ///
  /// Recreates the animations with the correct end values based on
  /// the child widget's actual size.
  void _updateAnimationTweens() {
    _animation = Tween<double>(begin: 0, end: _maxValue).animate(
      CurvedAnimation(parent: _animationController, curve: widget.curveIn),
    );

    _animationReverse = Tween<double>(begin: 0, end: _maxValue).animate(
      CurvedAnimation(
          parent: _animationControllerReverse, curve: widget.curveOut),
    );
  }

  /// Schedules the automatic start of the lightning animation.
  ///
  /// Uses the delay duration to automatically trigger the first animation
  /// if auto-start is enabled.
  void _scheduleAutoStart() {
    if (_hasStarted) {
      return;
    }
    _hasStarted = true;
    Future.delayed(widget.delayDuration ?? Duration.zero, () {
      if (mounted) {
        _lightningController.animateIn();
      }
    });
  }

  /// Checks if the forward animation can be started.
  ///
  /// Returns true if no animations are running and the forward animation
  /// is not already completed.
  bool _canStartAnimation() {
    return !_animationController.isAnimating &&
        _animationController.status != AnimationStatus.completed &&
        !_animationControllerReverse.isAnimating;
  }

  /// Checks if the reverse animation can be started.
  ///
  /// Returns true if the reverse animation is not running and not completed.
  bool _canStartReverseAnimation() {
    return !_animationControllerReverse.isAnimating &&
        _animationControllerReverse.status != AnimationStatus.completed;
  }

  /// Handles tap down gesture.
  ///
  /// Starts the lightning animation when the user taps down on the widget
  /// (only if gesture control is enabled).
  void _onTapDown(TapDownDetails details) {
    if (!_canStartAnimation()) return;
    if (mounted) _animationController.forward();
  }

  /// Handles tap up gesture.
  ///
  /// Starts the reverse lightning animation after the pause duration
  /// when the user releases the tap.
  void _onTapUp(TapUpDetails details) {
    if (!_canStartReverseAnimation()) return;
    Future.delayed(widget.pauseDuration, () {
      if (mounted) _animationControllerReverse.forward();
    });
  }

  /// Handles tap cancel gesture.
  ///
  /// Immediately starts the reverse lightning animation when the tap
  /// is cancelled (user drags finger away).
  void _onTapCancel() {
    if (!_canStartReverseAnimation() ||
        _animationController.status != AnimationStatus.completed) {
      return;
    }
    if (mounted) _animationControllerReverse.forward();
  }

  /// Builds the lightning overlay widget.
  ///
  /// Creates the animated overlay that appears on top of the child widget,
  /// using custom clipping to create the lightning effect.
  Widget _buildOverlay() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: Listenable.merge([_animation, _animationReverse]),
        builder: (context, child) {
          return ClipPath(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            clipper: _LightClipper(
              progress: _animation.value,
              reverseProgress: _animationReverse.value,
              direction: widget.direction,
            ),
            child: child,
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Container(color: widget.overlayColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Create the base stack with child and overlay
    final stack = Stack(
      children: [
        SizedBox(
          key: _childKey,
          child: widget.child,
        ),
        _buildOverlay(),
      ],
    );

    // Wrap with gesture detector if gesture control is enabled
    if (!widget.useGesture) return stack;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: stack,
    );
  }

  @override
  void dispose() {
    // Clean up animation listeners
    _animationController.removeStatusListener(_onAnimationInComplete);
    _animationControllerReverse.removeStatusListener(_onAnimationOutComplete);

    // Dispose controllers and clean up
    _lightningController.dispose();
    _animationController.dispose();
    _animationControllerReverse.dispose();

    super.dispose();
  }
}

/// Custom clipper that creates the lightning effect shape.
///
/// This clipper creates a triangular path that grows and shrinks to simulate
/// a lightning effect moving across the widget.
class _LightClipper extends CustomClipper<Path> {
  /// Progress of the forward lightning animation (0.0 to max value).
  final double progress;

  /// Progress of the reverse lightning animation (0.0 to max value).
  final double reverseProgress;

  /// Direction of the lightning effect.
  final LightningDirection direction;

  /// Creates a lightning clipper with the specified parameters.
  const _LightClipper({
    required this.progress,
    required this.reverseProgress,
    required this.direction,
  });

  @override
  Path getClip(Size size) {
    final path = Path();

    if (direction == LightningDirection.leftToRight) {
      // Create lightning effect moving from left to right
      path
        ..moveTo(0, 0)
        ..lineTo(reverseProgress, 0)
        ..lineTo(0, reverseProgress)
        ..lineTo(0, progress)
        ..lineTo(progress, 0);
    } else {
      // Create lightning effect moving from right to left
      path
        ..moveTo(size.width, size.height)
        ..lineTo(size.width, size.height - progress)
        ..lineTo(size.width - progress, size.height)
        ..lineTo(size.width - reverseProgress, size.height)
        ..lineTo(size.width, size.height - reverseProgress);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _LightClipper oldClipper) {
    // Only reclip when animation values or direction change
    return progress != oldClipper.progress ||
        reverseProgress != oldClipper.reverseProgress ||
        direction != oldClipper.direction;
  }
}
