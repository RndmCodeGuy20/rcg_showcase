import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rcg_showcase/components/animated_bottom_sheet.dart';
import 'package:rcg_showcase/components/bm_content.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  final List<String> _profileCompletionSteps = [
    'About Me',
    'Contact Info',
    'Interests',
    'Goals',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: kToolbarHeight,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
        title: const Text(
          "Alerts",
          style: TextStyle(
            fontFamily: 'Gilroy',
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showModalBottomSheetNative(context, BottomSheetContent());
            },
            child: SvgPicture.asset(
              'assets/icons/globe.svg',
              width: 24,
              height: 24,
              color: Colors.black54,
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.only(right: 16),
      ),
      body: ReorderableListView(
        onReorder: _onReorder,
        proxyDecorator: (child, index, animation) {
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              final scale = 1.0 + (0.05 * animation.value);
              return Transform.scale(
                scale: scale,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  child: child,
                ),
              );
            },
            child: child,
          );
        },

        children: _profileCompletionSteps
            .map(
              (item) => Padding(
                key: ValueKey(item),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/grip.svg',
                      width: 18,
                      height: 18,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontFamily: 'Gilroy',
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/icons/menu.svg',
                      width: 18,
                      height: 18,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(
                      'assets/icons/down.svg',
                      width: 18,
                      height: 18,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final String item = _profileCompletionSteps.removeAt(oldIndex);
      _profileCompletionSteps.insert(newIndex, item);
    });
  }
}
