import 'package:flutter/material.dart';

import '../models/chat_message.dart';

class MessageBubble extends StatefulWidget {
  final ChatMessage message;
  final bool isMe;
  final Function(ChatMessage)? onMessageLongPress;
  final bool showLeftTimestamp; // For dragging right
  final bool showRightTimestamp; // For dragging left
  final Animation<double>? timestampAnimation;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.onMessageLongPress,
    required this.showLeftTimestamp,
    required this.showRightTimestamp,
    this.timestampAnimation,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _reactionController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    if (widget.message.reaction != null) {
      _reactionController.value = 1.0;
    }
  }

  void _initializeAnimations() {
    _reactionController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Create a bounce effect with overshoot and settle
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.4,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.4,
          end: 0.8,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 40,
      ),
    ]).animate(_reactionController);

    // Scale animation for the container/background
    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _reactionController, curve: Curves.easeOutBack),
    );

    // Fade animation for smooth appearance
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _reactionController,
        curve: Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void didUpdateWidget(MessageBubble oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldReaction = oldWidget.message.reaction ?? '';
    final newReaction = widget.message.reaction ?? '';

    if (oldReaction != newReaction) {
      print(
        "Reaction changed: ${widget.message.id}, from '$oldReaction' to '$newReaction'",
      );

      if (widget.message.reaction != null) {
        _reactionController.forward();
      } else {
        _reactionController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _reactionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: widget.isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onLongPress: () {
                    if (widget.onMessageLongPress != null) {
                      widget.onMessageLongPress!(widget.message);
                    }
                  },
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: widget.isMe
                          ? Color(0xfffdc607)
                          : Color(0xfff8f8f8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.message.text,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
                if (widget.message.reaction != null) _buildAnimatedReaction(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedTimestamp(String timestampText) {
    if (widget.timestampAnimation != null) {
      return AnimatedBuilder(
        animation: widget.timestampAnimation!,
        builder: (context, child) {
          return Opacity(
            opacity: widget.timestampAnimation!.value,
            child: Transform.scale(
              scale: 0.8 + (0.2 * widget.timestampAnimation!.value),
              child: Center(
                child: Text(
                  timestampText,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontFamily: 'Gilroy',
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    return Center(
      child: Text(
        timestampText,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
          fontFamily: 'Gilroy',
        ),
      ),
    );
  }

  Widget _buildAnimatedReaction() {
    // _reactionController.forward(from: 0.0);
    return Positioned(
      bottom: -6,
      left: 12,
      child: AnimatedBuilder(
        animation: _reactionController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Transform.scale(
                scale: _bounceAnimation.value,
                child: Text(
                  widget.message.reaction!,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
