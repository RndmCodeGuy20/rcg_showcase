import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AnimatedButtonState { idle, loading, success, error }

class AnimatedButton extends StatelessWidget {
  final AnimatedButtonState state;
  final VoidCallback onPressed;
  final String idleText;
  final String loadingText;
  final String successText;
  final String failureText;

  const AnimatedButton({
    super.key,
    required this.state,
    required this.onPressed,
    this.idleText = "Publish",
    this.loadingText = "Publishing...",
    this.successText = "View Live",
    this.failureText = "Try Again",
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (state == AnimatedButtonState.idle) {
          onPressed();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutBack,
        // padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        constraints: BoxConstraints(minWidth: 150, minHeight: 36),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(128),
          boxShadow: [
            // BoxShadow(
            //   color: _getBackgroundColor().withOpacity(0.3),
            //   blurRadius: 15,
            //   offset: const Offset(0, 8),
            // ),
          ],
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SlideTransition(
                position: animation.drive(
                  Tween<Offset>(
                    begin: const Offset(0.3, 0.0),
                    end: Offset.zero,
                  ).chain(CurveTween(curve: Curves.easeOut)),
                ),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: _buildContentForState(),
          ),
        ),
      ),
    );
  }

  Widget _buildContentForState() {
    switch (state) {
      case AnimatedButtonState.idle:
        return _buildIdleContent();
      case AnimatedButtonState.loading:
        return _buildLoadingContent();
      case AnimatedButtonState.success:
        return _buildSuccessContent();
      case AnimatedButtonState.error:
        return _buildErrorContent();
    }
  }

  Widget _buildIdleContent() {
    return Text(
      idleText,
      key: const ValueKey('idle'),
      style: const TextStyle(
        fontFamily: 'gilroy',
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Row(
      key: const ValueKey('loading'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          loadingText,
          style: const TextStyle(
            fontFamily: 'gilroy',
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 12),
        IndefiniteAnimationContainer(
          duration: 4000,
          child: SvgPicture.asset(
            "assets/icons/loader.svg",
            height: 20,
            width: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessContent() {
    return Row(
      key: const ValueKey('success'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          successText,
          style: const TextStyle(
            fontFamily: 'gilroy',
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        SvgPicture.asset(
          "assets/icons/view_live.svg",
          height: 16,
          width: 16,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget _buildErrorContent() {
    return Row(
      key: const ValueKey('error'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          failureText,
          style: const TextStyle(
            fontFamily: 'gilroy',
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.error_outline, color: Colors.white, size: 16),
      ],
    );
  }

  Color _getBackgroundColor() {
    switch (state) {
      case AnimatedButtonState.idle:
      case AnimatedButtonState.loading:
        return Colors.black;
      case AnimatedButtonState.success:
        return Colors.black;
      case AnimatedButtonState.error:
        return Colors.black;
    }
  }
}

class IndefiniteAnimationContainer extends StatefulWidget {
  /// A container that can be used to display an indefinite animation.
  final Widget child;
  final int duration;

  // final AnimationController controller;
  // final Animation<double> animation;

  const IndefiniteAnimationContainer({
    super.key,
    required this.child,
    this.duration = 1000,
    // required this.controller,
    // required this.animation,
  });

  @override
  State<IndefiniteAnimationContainer> createState() =>
      _IndefiniteAnimationContainerState();
}

class _IndefiniteAnimationContainerState
    extends State<IndefiniteAnimationContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration),
    );

    _animation = Tween<double>(begin: 0.0, end: 12.5664).animate(_controller);

    _controller.forward();

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.repeat();
      }
    });

    // _controller = widget.controller;
    // _animation = widget.animation;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) {
        return Transform.rotate(angle: _animation.value, child: child);
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
