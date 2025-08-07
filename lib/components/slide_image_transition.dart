import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

import 'animated_button.dart';

class SlideImageSwitcher extends StatelessWidget {
  final AnimatedButtonState state;

  const SlideImageSwitcher({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 500),
        reverse: false,
        transitionBuilder:
            (
              Widget child,
              Animation<double> primaryAnimation,
              Animation<double> secondaryAnimation,
            ) {
              return SlideTransition(
                position: primaryAnimation.drive(
                  Tween<Offset>(
                    begin: const Offset(1.0, 0.0), // enter from right
                    end: Offset.zero,
                  ).chain(CurveTween(curve: Curves.easeInOut)),
                ),
                child: FadeTransition(
                  opacity: primaryAnimation.drive(
                    Tween<double>(
                      begin: 0.0, // start invisible
                      end: 1.0, // end visible
                    ).chain(CurveTween(curve: Curves.easeInOut)),
                  ),
                  child: SlideTransition(
                    position: secondaryAnimation.drive(
                      Tween<Offset>(
                        begin: Offset.zero,
                        end: const Offset(-1.0, 0.0), // exit to left
                      ).chain(CurveTween(curve: Curves.easeInOut)),
                    ),
                    child: FadeTransition(
                      opacity: secondaryAnimation.drive(
                        Tween<double>(
                          begin: 1.0, // start visible
                          end: 0.0, // end invisible
                        ).chain(CurveTween(curve: Curves.easeInOut)),
                      ),
                      child: child,
                    ),
                  ),
                ),
              );
            },
        child: _buildImageForState(state),
      ),
    );
  }

  Widget _buildImageForState(AnimatedButtonState state) {
    switch (state) {
      case AnimatedButtonState.idle:
      // return Image.asset(
      //   'assets/scan.png',
      //   key: const ValueKey('scan'),
      //   height: 150,
      // );
      case AnimatedButtonState.loading:
        return Image.asset(
          'assets/illustrations/publish.png',
          key: const ValueKey('idle'),
          height: 200,
        );
      case AnimatedButtonState.success:
        return Image.asset(
          'assets/illustrations/success.png',
          key: const ValueKey('success'),
          height: 200,
        );
      case AnimatedButtonState.error:
        return Image.asset(
          'assets/illustrations/error.png',
          key: const ValueKey('success'),
          height: 200,
        );
    }
  }
}
