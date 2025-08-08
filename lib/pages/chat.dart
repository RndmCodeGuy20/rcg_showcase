import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rcg_showcase/components/animated_bottom_sheet.dart';

import '../components/message_bubble.dart';
import '../models/chat_message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final String currentUserId = "user1";

  // Using the sample data from previous response
  List<ChatMessage> messages = sampleChatMessages;

  ChatMessage? selectedMessage;

  // Animation controller for bottom sheet
  late AnimationController _bottomSheetController;
  late Animation<double> _bottomSheetAnimation;

  // late AnimationController _emojiReactionController;
  // late Animation<double> _emojiReactionAnimation;

  double _dragOffset = 0.0;
  bool _showLeftTimestamps = false; // Show when dragging right
  bool _showRightTimestamps = false; // Show when dragging left
  late AnimationController _timestampAnimationController;
  late AnimationController _dragAnimationController;
  late SpringSimulation _springSimulation;

  @override
  void initState() {
    _bottomSheetController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    // _emojiReactionController = AnimationController(
    //   duration: Duration(milliseconds: 300),
    //   vsync: this,
    // );
    _timestampAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _dragAnimationController = AnimationController.unbounded(vsync: this);

    // Spring physics configuration (adjust for desired bounciness)
    _springSimulation = SpringSimulation(
      SpringDescription(mass: 1.0, stiffness: 200.0, damping: 20.0),
      0.0, // starting position
      0.0, // target position
      0.0, // starting velocity
    );

    _bottomSheetAnimation = CurvedAnimation(
      parent: _bottomSheetController,
      curve: Curves.easeOutCubic,
    );
    // _emojiReactionAnimation = CurvedAnimation(
    //   parent: _emojiReactionController,
    //   curve: Curves.elasticOut,
    // );

    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _bottomSheetController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        messages.add(
          ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: _messageController.text.trim(),
            senderId: currentUserId,
            senderName: "Alex",
            timestamp: DateTime.now(),
            status: MessageStatus.sending,
          ),
        );
      });

      _messageController.clear();
      _scrollToBottom();

      // Simulate message status updates
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          messages.last = ChatMessage(
            id: messages.last.id,
            text: messages.last.text,
            senderId: messages.last.senderId,
            senderName: messages.last.senderName,
            timestamp: messages.last.timestamp,
            status: MessageStatus.sent,
          );
        });
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showMessageOptions(ChatMessage message) {
    setState(() {
      selectedMessage = message;
    });

    // Add haptic feedback
    HapticFeedback.mediumImpact();

    // showModalBottomSheet(
    //   context: context,
    //   backgroundColor: Colors.transparent,
    //   isScrollControlled: true,
    //   builder: (context) => _buildMessageOptionsBottomSheet(message),
    // ).then((_) {
    //   setState(() {
    //     selectedMessage = null;
    //   });
    // });

    _buildMessageOptions(message);
  }

  Widget _buildMessageOptionsBottomSheet(ChatMessage message) {
    final isMe = message.senderId == currentUserId;

    return AnimatedBuilder(
      animation: _bottomSheetAnimation,
      builder: (context, child) {
        return Container(
          width: MediaQuery.of(context).size.width - 24,
          // height: MediaQuery.of(context).size.height * 0.4,
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
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
              Container(
                margin: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xfff8f8f8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.text,
                            style: TextStyle(
                              color: Colors.black.withValues(alpha: 0.54),
                              fontSize: 14,
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Action buttons
              ..._buildActionButtons(message, isMe),

              // SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
            ],
          ),
        );
      },
    );
  }

  void _buildMessageOptions(ChatMessage message) {
    final isMe = message.senderId == currentUserId;

    showModalBottomSheetNative(
      context,
      Container(
        width: MediaQuery.of(context).size.width - 24,
        // height: MediaQuery.of(context).size.height * 0.4,
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
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
            Container(
              margin: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xfff8f8f8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.text,
                          style: TextStyle(
                            color: Colors.black.withValues(alpha: 0.54),
                            fontSize: 14,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            ..._buildActionButtons(message, isMe),

            // SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  void _reactToMessage(ChatMessage message, String emoji) {
    setState(() {
      final messageIndex = messages.indexWhere((m) => m.id == message.id);
      if (messageIndex != -1) {
        // Replace the old message with a new instance
        messages[messageIndex] = message.addReaction(emoji);
      }
    });
  }

  List<Widget> _buildActionButtons(ChatMessage message, bool isMe) {
    var reactionEmojis = [
      '🔥', // Like
      '❤️', // Love
      '😂', // Haha
      '😮', // Wow
      '😢', // Sad
      '😡', // Angry
      '👍', // Thumbs Up
      '👎', // Thumbs Down
      '👏', // Clap
      '🎉', // Celebration
    ];

    return [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          'React',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black.withValues(alpha: 0.87),
            fontFamily: 'Gilroy',
          ),
        ),
      ),

      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(width: 8),
            ...reactionEmojis.map((emoji) {
              return GestureDetector(
                onTap: () {
                  _reactToMessage(message, emoji);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(emoji, style: TextStyle(fontSize: 32)),
                ),
              );
            }),
          ],
        ),
      ),

      _buildActionButton(
        icon: SvgPicture.asset('assets/icons/copy.svg', width: 20, height: 20),
        text: 'Copy',
        onTap: () {
          Navigator.pop(context);
          // _replyToMessage(message);
        },
      ),

      Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Divider(height: 1, color: Color(0xffe0e0e0)),
      ),

      _buildActionButton(
        icon: SvgPicture.asset('assets/icons/reply.svg', width: 20, height: 20),
        text: 'Reply',
        onTap: () {
          Clipboard.setData(ClipboardData(text: message.text));
          Navigator.pop(context);
          // _showSnackBar('Message copied to clipboard');
        },
      ),

      Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Divider(height: 1, color: Color(0xffe0e0e0)),
      ),

      _buildActionButton(
        icon: SvgPicture.asset(
          'assets/icons/forward.svg',
          width: 20,
          height: 20,
        ),
        text: 'Forward',
        onTap: () {
          Navigator.pop(context);
          // _forwardMessage(message);
        },
      ),

      Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Divider(height: 1, color: Color(0xffe0e0e0)),
      ),

      // if (isMe) ...[
      //   _buildActionButton(
      //     icon: Icons.edit,
      //     text: 'Edit',
      //     onTap: () {
      //       Navigator.pop(context);
      //       // _editMessage(message);
      //     },
      //   ),
      //
      _buildActionButton(
        icon: SvgPicture.asset(
          'assets/icons/delete.svg',
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
        ),
        text: 'Delete',
        color: Colors.red,
        onTap: () {
          Navigator.pop(context);
          // _deleteMessage(message);
        },
      ),

      //
      // _buildActionButton(
      //   icon: Icons.info_outline,
      //   text: 'Info',
      //   onTap: () {
      //     Navigator.pop(context);
      //     // _showMessageInfo(message);
      //   },
      // ),
    ];
  }

  Widget _buildActionButton({
    required SvgPicture icon,
    required String text,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: color,
                fontWeight: FontWeight.w600,
                fontFamily: 'Gilroy',
              ),
            ),
            Spacer(),
            icon,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      foregroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        onPressed: () => context.pop(),
      ),
      title: Row(
        children: [
          // CircleAvatar(
          //   radius: 20,
          //   backgroundColor: Colors.blue[100],
          //   child: Text(
          //     'J',
          //     style: TextStyle(
          //       color: Colors.blue[800],
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
          // SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jordan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: 'Gilroy',
                  ),
                ),
                // Text(
                //   'Online',
                //   style: TextStyle(
                //     fontSize: 12,
                //     color: Colors.green,
                //     fontWeight: FontWeight.w400,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // IconButton(icon: Icon(Icons.phone), onPressed: () {}),
        // IconButton(icon: Icon(Icons.videocam), onPressed: () {}),
        // IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
      ],
    );
  }

  Widget _buildLongPressMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Handle menu selection
        print('Selected: $value');
      },
      itemBuilder: (context) => [
        PopupMenuItem(value: 'copy', child: Text('Copy')),
        PopupMenuItem(value: 'delete', child: Text('Delete')),
        PopupMenuItem(value: 'forward', child: Text('Forward')),
      ],
    );
  }

  // Add this method to your class
  void _handleDragAnimationUpdate() {
    setState(() {
      _dragOffset = _dragAnimationController.value;

      // Hide timestamps when returning to center
      if (_dragOffset.abs() < 10 &&
          (_showLeftTimestamps || _showRightTimestamps)) {
        _showLeftTimestamps = false;
        _showRightTimestamps = false;
        _timestampAnimationController.reverse();
      }
    });
  }

  Widget _buildMessageList() {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Cancel any ongoing animation if user takes control
        if (_dragAnimationController.isAnimating) {
          _dragAnimationController.stop();
        }

        setState(() {
          _dragOffset += details.primaryDelta ?? 0.0;
          _dragOffset = _dragOffset.clamp(-50.0, 50.0);

          // Show left timestamps when dragging right (positive offset)
          if (_dragOffset > 20 && !_showLeftTimestamps) {
            _showLeftTimestamps = true;
            _showRightTimestamps = false;
            _timestampAnimationController.forward();
          }
          // Show right timestamps when dragging left (negative offset)
          else if (_dragOffset < -20 && !_showRightTimestamps) {
            _showRightTimestamps = true;
            _showLeftTimestamps = false;
            _timestampAnimationController.forward();
          }
          // Hide timestamps when returning to center
          else if (_dragOffset.abs() < 10 &&
              (_showLeftTimestamps || _showRightTimestamps)) {
            _showLeftTimestamps = false;
            _showRightTimestamps = false;
            _timestampAnimationController.reverse();
          }
        });
      },
      onHorizontalDragEnd: (details) {
        // Remove previous listener if exists
        _dragAnimationController.removeListener(_handleDragAnimationUpdate);

        // Create new simulation
        _springSimulation = SpringSimulation(
          SpringDescription(mass: 1.0, stiffness: 200.0, damping: 20.0),
          _dragOffset,
          0.0,
          details.primaryVelocity ?? 0.0,
        );

        // Add new listener
        _dragAnimationController.addListener(_handleDragAnimationUpdate);
        _dragAnimationController.animateWith(_springSimulation);

        // Auto-hide timestamps after animation completes
        _dragAnimationController.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            Future.delayed(Duration(milliseconds: 500), () {
              if (mounted) {
                setState(() {
                  _showLeftTimestamps = false;
                  _showRightTimestamps = false;
                });
                _timestampAnimationController.reverse();
              }
            });
          }
        });
      },

      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.only(top: 16, bottom: 16, left: 4, right: 4),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          final isMe = message.senderId == currentUserId;

          return MessageBubble(
            key: ValueKey(message.id),
            message: message,
            isMe: isMe,
            showLeftTimestamp: _showLeftTimestamps,
            showRightTimestamp: _showRightTimestamps,
            timestampAnimation: _timestampAnimationController,
            onMessageLongPress: (message) => _showMessageOptions(message),
          );
        },
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isMe, bool showAvatar) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) SizedBox(width: 8),
          Flexible(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onLongPress: () => _showMessageOptions(message),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isMe ? Color(0xfffdc607) : Color(0xfff8f8f8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.text,
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

                /// Emoji Reaction Positioned
                if (message.reaction != null)
                  Positioned(
                    bottom: -10,
                    left: 12,
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      switchInCurve: Curves.elasticOut,
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Text(
                        message.reaction!,
                        key: ValueKey(message.reaction),
                        // Triggers the animation
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (isMe) SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
          ),
        );
      case MessageStatus.sent:
        return Icon(Icons.check, size: 16, color: Colors.white70);
      case MessageStatus.delivered:
        return Icon(Icons.done_all, size: 16, color: Colors.white70);
      case MessageStatus.read:
        return Icon(Icons.done_all, size: 16, color: Colors.white);
      case MessageStatus.failed:
        return Icon(Icons.error_outline, size: 16, color: Colors.red[300]);
    }
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/add.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.54),
                  BlendMode.srcIn,
                ),
              ),
              onPressed: () {
                // Handle attachment
              },
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xfff8f8f8),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  enabled: false,
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(
                      color: Color(0xffb0b0b0),
                      fontSize: 16,
                      fontFamily: 'Gilroy',
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Color(0xfffdc607),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${timestamp.day}/${timestamp.month}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'now';
    }
  }
}
