import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:rcg_showcase/components/dynamic_overlay.dart';
import 'package:rcg_showcase/components/chat_options.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  final GlobalKey _buttonKey = GlobalKey();

  late DynamicOverlay _dynamicOverlay;

  bool _isNewChatOptionsVisible = false;

  @override
  void initState() {
    super.initState();
    _dynamicOverlay = DynamicOverlay(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(kToolbarHeight),
      //   child: const ChatHomeAppBar(),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text(
              "Go Back",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Spacer(),
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: _isNewChatOptionsVisible ? Colors.white : Colors.black,
                borderRadius: BorderRadius.circular(32),
              ),
              child: TextButton(
                key: _buttonKey,
                onPressed: () {
                  _dynamicOverlay.showOverlay(_buttonKey, NewChatOptions(), () {
                    setState(() {
                      _isNewChatOptionsVisible = false;
                    });
                  });

                  setState(() {
                    _isNewChatOptionsVisible = true;
                  });
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: _isNewChatOptionsVisible
                      ? const Text(
                          "Cancel",
                          key: ValueKey('cancel'),
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w800,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/add.svg',
                              key: const ValueKey('search'),
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                              height: 24,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "New Chat",
                              key: ValueKey('new_chat'),
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}
