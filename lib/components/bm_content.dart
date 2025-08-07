import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rcg_showcase/components/slide_image_transition.dart';
import 'package:rcg_showcase/components/animated_button.dart';

class BottomSheetContent extends StatefulWidget {
  const BottomSheetContent({super.key});

  @override
  State<BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  AnimatedButtonState _buttonState = AnimatedButtonState.idle;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: MediaQuery.of(context).size.width - 24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(
            defaultTargetPlatform == TargetPlatform.iOS ? 58 : 38,
          ),
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 10,
        //     offset: Offset(0, -5),
        //   ),
        // ],
      ),
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Color(0xffe0e0e0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          ClipRect(child: SlideImageSwitcher(state: _buttonState)),

          _buildHeaderText(_buttonState),
          _buildSubHeaderText(_buttonState),

          SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                switchInCurve: Curves.easeOutBack,
                switchOutCurve: Curves.easeInBack,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SizeTransition(
                    sizeFactor: animation,
                    axis: Axis.horizontal,
                    child: child,
                  ),
                ),
                child:
                    _buttonState == AnimatedButtonState.success ||
                        _buttonState == AnimatedButtonState.error
                    ? GestureDetector(
                        key: const ValueKey('close'),
                        onTap: () {
                          // setState(() {
                          //   _buttonState = AnimatedButtonState.idle;
                          // });
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 150,
                          margin: const EdgeInsets.only(right: 16),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(128),
                          ),
                          child: Text(
                            "Close",
                            style: TextStyle(
                              fontFamily: 'gilroy',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(key: ValueKey('empty')),
              ),
              AnimatedSlide(
                duration: const Duration(milliseconds: 400),
                offset: Offset.zero,
                curve: Curves.easeOutBack,
                child: AnimatedButton(
                  state: _buttonState,
                  onPressed: () {
                    setState(() {
                      _buttonState = AnimatedButtonState.loading;
                    });

                    Future.delayed(const Duration(seconds: 2), () {
                      if (mounted) {
                        // generate 0 or 1 randomly
                        const randomBinary = [
                          AnimatedButtonState.success,
                          AnimatedButtonState.error,
                        ];
                        final randomIndex =
                            randomBinary[DateTime.now().millisecondsSinceEpoch %
                                1];
                        setState(() {
                          _buttonState = randomIndex;
                        });
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      // ),
    );
  }

  Widget _buildHeaderText(AnimatedButtonState state) {
    final texts = {
      AnimatedButtonState.idle: "Publish your profile...",
      AnimatedButtonState.loading: "Publishing...",
      AnimatedButtonState.success: "Published successfully!",
      AnimatedButtonState.error: "Failed to publish!",
    };

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          // child: SizeTransition(
          //   sizeFactor: animation,
          //   axis: Axis.vertical,
          child: child,
          // ),
        );
      },
      child: Text(
        texts[state]!,
        key: ValueKey<String>(texts[state]!),
        style: TextStyle(
          fontFamily: 'gilroy',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildSubHeaderText(AnimatedButtonState state) {
    final texts = {
      AnimatedButtonState.idle: "Share who you are with the world.",
      AnimatedButtonState.loading: "Please wait while we publish your profile.",
      AnimatedButtonState.success:
          "Your profile has been published successfully!",
      AnimatedButtonState.error:
          "There was an error publishing your profile. Please try again.",
    };

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          // child: SlideTransition(
          //   position: Tween<Offset>(
          //     begin: const Offset(0, 0.2),
          //     end: Offset.zero,
          //   ).animate(animation),
          child: child,
          // ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          texts[state]!,
          textAlign: TextAlign.center,
          key: ValueKey<String>(texts[state]!),
          style: TextStyle(
            fontFamily: 'gilroy',
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
