import 'package:flutter/material.dart';

class DynamicOverlay {
  final BuildContext context;
  OverlayEntry? _overlayEntry;

  DynamicOverlay(this.context);

  void showOverlay(
    GlobalKey targetKey,
    Widget overlayContent,
    Function onDismiss,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("Adding overlay...");
      final renderBox =
          targetKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null) return;
      print("RenderBox: $renderBox");

      final targetOffset = renderBox.localToGlobal(Offset.zero);
      final targetSize = renderBox.size;

      print("Target Offset: $targetOffset, Target Size: $targetSize");

      _overlayEntry = OverlayEntry(
        builder: (context) {
          return _OverlayWrapper(
            targetOffset: targetOffset,
            targetSize: targetSize,
            onDismiss: () {
              print("Overlay dismissed");
              removeOverlay();
              onDismiss();
            },
            child: overlayContent,
          );
        },
      );

      Overlay.of(context).insert(_overlayEntry!);
    });
  }

  void removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class _OverlayWrapper extends StatefulWidget {
  final Offset targetOffset;
  final Size targetSize;
  final Widget child;
  final VoidCallback onDismiss;

  const _OverlayWrapper({
    required this.targetOffset,
    required this.targetSize,
    required this.child,
    required this.onDismiss,
  });

  @override
  _OverlayWrapperState createState() => _OverlayWrapperState();
}

class _OverlayWrapperState extends State<_OverlayWrapper>
    with SingleTickerProviderStateMixin {
  final GlobalKey _overlayKey = GlobalKey();
  Size? overlaySize;

  bool isProcessing = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Set up animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    // Define animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox =
          _overlayKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        print("Overlay Size: ${renderBox.size}");

        setState(() {
          overlaySize = renderBox.size;
          isProcessing = false;

          // Start animation once measurements are complete
          _animationController.forward();
        });
      }
    });
  }

  void _handleDismiss() {
    _animationController.reverse().then((_) {
      print("Overlay dismissed");
      widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return OverlayEntryBuilder(
          overlayKey: _overlayKey,
          targetOffset: widget.targetOffset,
          targetSize: widget.targetSize,
          overlaySize: overlaySize,
          onDismiss: _handleDismiss,
          isProcessing: isProcessing,
          opacity: _fadeAnimation.value,
          scale: _scaleAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}

class OverlayEntryBuilder extends StatelessWidget {
  final GlobalKey overlayKey;
  final Offset targetOffset;
  final Size targetSize;
  final Size? overlaySize;
  final Widget child;
  final VoidCallback onDismiss;
  final bool isProcessing;
  final double opacity;
  final double scale;

  const OverlayEntryBuilder({
    super.key,
    required this.overlayKey,
    required this.targetOffset,
    required this.targetSize,
    required this.overlaySize,
    required this.child,
    required this.onDismiss,
    this.isProcessing = true,
    this.opacity = 1.0,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final double overlayWidth = overlaySize?.width ?? 200;
    final double overlayHeight = overlaySize?.height ?? 200;

    // Adjust positioning to keep overlay within screen bounds
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double top = targetOffset.dy + targetSize.height;
    double left = targetOffset.dx - (overlayWidth / 2) + (targetSize.width / 2);

    if (top + overlayHeight > screenHeight) {
      top = targetOffset.dy - overlayHeight;
    }

    if (left + overlayWidth > screenWidth) {
      left = screenWidth - (overlayWidth);
    }

    return Stack(
      children: [
        GestureDetector(
          onTap: onDismiss,
          behavior: HitTestBehavior.translucent,
          child: SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: ClipPath(
              clipper: RectangularHoleClipper(
                xPosition: targetOffset.dx - 4,
                yPosition: targetOffset.dy,
                width: targetSize.width + 8,
                height: targetSize.height,
              ),
              child: Container(color: Colors.black.withOpacity(0.2 * opacity)),
            ),
          ),
        ),
        Positioned(
          key: overlayKey,
          top: top,
          left: left,
          child: Visibility(
            visible: !isProcessing,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                child: Material(
                  color: Colors.transparent,
                  child: GestureDetector(onTap: onDismiss, child: child),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RectangularHoleClipper extends CustomClipper<Path> {
  final double xPosition;
  final double yPosition;
  final double width;
  final double height;
  final double borderRadius; // New parameter for rounding

  RectangularHoleClipper({
    super.reclip,
    required this.xPosition,
    required this.yPosition,
    required this.width,
    required this.height,
    this.borderRadius = 100, // Default to 0 (no rounding)
  });

  @override
  Path getClip(Size size) {
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height)) // Full background
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(xPosition, yPosition, width, height),
          Radius.circular(borderRadius),
        ),
      )
      ..fillType = PathFillType.evenOdd;

    return path;
  }

  @override
  bool shouldReclip(covariant RectangularHoleClipper oldClipper) {
    return xPosition != oldClipper.xPosition ||
        yPosition != oldClipper.yPosition ||
        width != oldClipper.width ||
        height != oldClipper.height ||
        borderRadius != oldClipper.borderRadius;
  }
}
