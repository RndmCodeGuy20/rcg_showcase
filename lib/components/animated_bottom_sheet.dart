import 'dart:ui';

import 'package:flutter/material.dart';

void showCustomBottomSheet(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Transform.translate(
          offset: Offset(0, (1 - anim1.value)), // Slide from bottom
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Nudge Stress Test",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      // await triggerPosix();
                      Navigator.of(context).pop();
                    },
                    child: Text("Start Stress Test"),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position:
            Tween<Offset>(
              begin: const Offset(0, 1),
              end: const Offset(0, 0),
            ).animate(
              CurvedAnimation(
                parent: anim1,
                curve: Curves.easeOut,
                reverseCurve: Curves.easeIn,
              ),
            ),
        child: child,
      );
    },
  );
}

void showModalBottomSheetNative(BuildContext context, Widget child) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    transitionAnimationController: AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: Navigator.of(context),
    ),
    builder: (BuildContext context) {
      return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        builder: (context, animationValue, child) {
          // Multiple layered animations
          final slideOffset = Tween<double>(
            begin: 300,
            end: 0,
          ).transform(Curves.easeOutBack.transform(animationValue));
          final scaleValue = Tween<double>(
            begin: 0.9,
            end: 1.0,
          ).transform(Curves.elasticOut.transform(animationValue));
          final fadeValue = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).transform(Curves.easeOut.transform(animationValue));
          final blurValue = Tween<double>(
            begin: 8.0,
            end: 0.0,
          ).transform(Curves.easeOutQuart.transform(animationValue));

          return AnimatedPadding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            child: Transform.translate(
              offset: Offset(0, slideOffset),
              child: Transform.scale(
                scale: scaleValue,
                alignment: Alignment.bottomCenter,
                child: Opacity(
                  opacity: fadeValue,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: blurValue,
                      sigmaY: blurValue,
                    ),
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            // BoxShadow(
                            //   color: Colors.black.withOpacity(0.3 * fadeValue),
                            //   blurRadius: 20 * fadeValue,
                            //   offset: Offset(0, -5 * fadeValue),
                            // ),
                          ],
                        ),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        child: child,
      );
    },
  );
}

// void showModalBottomSheetNative(BuildContext context, Widget child) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     transitionAnimationController: AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: Navigator.of(context),
//     ),
//     builder: (BuildContext context) {
//       return AnimatedPadding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom + 16,
//         ),
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInCubic,
//         child: AnimatedSize(
//           duration: const Duration(milliseconds: 400),
//           curve: Curves.easeOutBack, // Adds a subtle bounce
//           alignment: Alignment.bottomCenter, // Grows from bottom
//           child: child,
//         ),
//       );
//     },
//   );
// }
