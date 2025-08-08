class ChatMessage {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final DateTime timestamp;
  final MessageType type;
  final MessageStatus status;
  final String? replyToId;
  final List<String>? attachments;
  final Map<String, dynamic>? metadata;
  String? reaction; // Optional reaction to the message
  DateTime? reactionTimestamp; // Timestamp for the reaction

  ChatMessage({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
    this.type = MessageType.text,
    this.status = MessageStatus.sent,
    this.replyToId,
    this.attachments,
    this.metadata,
    this.reaction,
    this.reactionTimestamp,
  });

  ChatMessage copyWith({
    String? id,
    String? text,
    String? senderId,
    String? senderName,
    DateTime? timestamp,
    MessageStatus? status,
    String? reaction,
    DateTime? reactionTimestamp,
    bool clearReaction = false, // Add this to explicitly clear reactions
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      reaction: clearReaction ? null : (reaction ?? this.reaction),
      reactionTimestamp: clearReaction
          ? null
          : (reactionTimestamp ?? this.reactionTimestamp),
    );
  }

  // Helper method for adding reactions
  ChatMessage addReaction(String emoji) {
    return copyWith(reaction: emoji, reactionTimestamp: DateTime.now());
  }

  // Helper method for removing reactions
  ChatMessage removeReaction() {
    return copyWith(clearReaction: true);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessage &&
          id == other.id &&
          text == other.text &&
          reaction == other.reaction;

  @override
  int get hashCode => id.hashCode ^ text.hashCode ^ (reaction?.hashCode ?? 0);
}

enum MessageType { text, image, file, audio, video, location, system }

enum MessageStatus { sending, sent, delivered, read, failed }

// Sample chat data
final List<ChatMessage> sampleChatMessages = [
  ChatMessage(
    id: "1",
    text: "Hey! How's your day going?",
    senderId: "user1",
    senderName: "Alex",
    timestamp: DateTime.now().subtract(Duration(hours: 2, minutes: 30)),
    status: MessageStatus.read,
  ),

  ChatMessage(
    id: "2",
    text: "Pretty good! Just finished a big project at work. How about you?",
    senderId: "user2",
    senderName: "Jordan",
    timestamp: DateTime.now().subtract(Duration(hours: 2, minutes: 25)),
    status: MessageStatus.read,
  ),

  ChatMessage(
    id: "3",
    text: "That's awesome! What kind of project was it?",
    senderId: "user1",
    senderName: "Alex",
    timestamp: DateTime.now().subtract(Duration(hours: 2, minutes: 20)),
    status: MessageStatus.read,
  ),

  ChatMessage(
    id: "4",
    text:
        "It was a mobile app redesign. Took about 3 months but finally launched today! 🎉",
    senderId: "user2",
    senderName: "Jordan",
    timestamp: DateTime.now().subtract(Duration(hours: 2, minutes: 15)),
    status: MessageStatus.read,
  ),

  ChatMessage(
    id: "5",
    text: "Congratulations! That's a huge accomplishment. You must be relieved",
    senderId: "user1",
    senderName: "Alex",
    timestamp: DateTime.now().subtract(Duration(hours: 2, minutes: 10)),
    status: MessageStatus.read,
  ),

  ChatMessage(
    id: "6",
    text: "Definitely! Want to celebrate this weekend?",
    senderId: "user2",
    senderName: "Jordan",
    timestamp: DateTime.now().subtract(Duration(hours: 2, minutes: 5)),
    status: MessageStatus.read,
  ),

  ChatMessage(
    id: "7",
    text: "Absolutely! I know a great new restaurant downtown",
    senderId: "user1",
    senderName: "Alex",
    timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 58)),
    status: MessageStatus.read,
  ),

  ChatMessage(
    id: "8",
    text: "Perfect! What type of cuisine?",
    senderId: "user2",
    senderName: "Jordan",
    timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 55)),
    status: MessageStatus.read,
  ),

  ChatMessage(
    id: "9",
    text:
        "Italian! They have amazing pasta and the ambiance is really nice. Very cozy",
    senderId: "user1",
    senderName: "Alex",
    timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 50)),
    status: MessageStatus.read,
  ),

  ChatMessage(
    id: "10",
    text: "Sounds perfect! What time works for you?",
    senderId: "user2",
    senderName: "Jordan",
    timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 45)),
    status: MessageStatus.read,
  ),

  ChatMessage(
    id: "11",
    text: "How about 7 PM on Saturday?",
    senderId: "user1",
    senderName: "Alex",
    timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 40)),
    status: MessageStatus.read,
  ),

  ChatMessage(
    id: "12",
    text: "Perfect! I'll make a reservation",
    senderId: "user2",
    senderName: "Jordan",
    timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 35)),
    status: MessageStatus.read,
  ),

  ChatMessage(
    id: "13",
    text: "Great! Looking forward to it 😊",
    senderId: "user1",
    senderName: "Alex",
    timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 30)),
    status: MessageStatus.read,
  ),

  // Some recent messages with different statuses
  ChatMessage(
    id: "14",
    text: "Hey, just confirming - still on for tonight?",
    senderId: "user2",
    senderName: "Jordan",
    timestamp: DateTime.now().subtract(Duration(minutes: 45)),
    status: MessageStatus.read,
  ),

  ChatMessage(
    id: "15",
    text: "Yes! I'm actually getting ready now",
    senderId: "user1",
    senderName: "Alex",
    timestamp: DateTime.now().subtract(Duration(minutes: 30)),
    status: MessageStatus.delivered,
  ),

  ChatMessage(
    id: "16",
    text: "Awesome! See you there",
    senderId: "user2",
    senderName: "Jordan",
    timestamp: DateTime.now().subtract(Duration(minutes: 25)),
    status: MessageStatus.delivered,
  ),

  ChatMessage(
    id: "17",
    text: "Actually, I might be about 10 minutes late. Traffic is crazy",
    senderId: "user1",
    senderName: "Alex",
    timestamp: DateTime.now().subtract(Duration(minutes: 15)),
    status: MessageStatus.sent,
  ),

  ChatMessage(
    id: "18",
    text: "No problem! I'll grab us a table",
    senderId: "user2",
    senderName: "Jordan",
    timestamp: DateTime.now().subtract(Duration(minutes: 10)),
    status: MessageStatus.sent,
  ),

  ChatMessage(
    id: "19",
    text: "You're the best! Almost there now",
    senderId: "user1",
    senderName: "Alex",
    timestamp: DateTime.now().subtract(Duration(minutes: 5)),
    status: MessageStatus.sending,
  ),
];

// Extended sample with different message types
final List<ChatMessage> extendedChatMessages = [
  ...sampleChatMessages,

  // System message
  ChatMessage(
    id: "20",
    text: "Alex has joined the chat",
    senderId: "system",
    senderName: "System",
    timestamp: DateTime.now().subtract(Duration(days: 1)),
    type: MessageType.system,
  ),

  // Image message
  ChatMessage(
    id: "21",
    text: "Check out this sunset!",
    senderId: "user1",
    senderName: "Alex",
    timestamp: DateTime.now().subtract(Duration(hours: 3)),
    type: MessageType.image,
    attachments: ["sunset_image.jpg"],
    status: MessageStatus.read,
  ),

  // Reply message
  ChatMessage(
    id: "22",
    text: "Wow, that's beautiful! Where was this taken?",
    senderId: "user2",
    senderName: "Jordan",
    timestamp: DateTime.now().subtract(Duration(hours: 2, minutes: 58)),
    replyToId: "21",
    status: MessageStatus.read,
  ),

  // File message
  ChatMessage(
    id: "23",
    text: "Here's the document you requested",
    senderId: "user1",
    senderName: "Alex",
    timestamp: DateTime.now().subtract(Duration(hours: 1)),
    type: MessageType.file,
    attachments: ["project_proposal.pdf"],
    status: MessageStatus.delivered,
  ),

  // Audio message
  ChatMessage(
    id: "24",
    text: "🎵 Voice message",
    senderId: "user2",
    senderName: "Jordan",
    timestamp: DateTime.now().subtract(Duration(minutes: 30)),
    type: MessageType.audio,
    attachments: ["voice_note.mp3"],
    metadata: {"duration": 45},
    // seconds
    status: MessageStatus.sent,
  ),

  // Long message
  ChatMessage(
    id: "25",
    text:
        "I've been thinking about our conversation yesterday, and I really appreciate your perspective on the whole situation. It's given me a lot to consider, and I think you're absolutely right about taking a step back and looking at the bigger picture. Sometimes we get so caught up in the day-to-day details that we lose sight of what really matters.",
    senderId: "user1",
    senderName: "Alex",
    timestamp: DateTime.now().subtract(Duration(minutes: 20)),
    status: MessageStatus.delivered,
  ),
];

// Helper function to group messages by date
Map<String, List<ChatMessage>> groupMessagesByDate(List<ChatMessage> messages) {
  Map<String, List<ChatMessage>> groupedMessages = {};

  for (ChatMessage message in messages) {
    String dateKey =
        "${message.timestamp.year}-${message.timestamp.month.toString().padLeft(2, '0')}-${message.timestamp.day.toString().padLeft(2, '0')}";

    if (!groupedMessages.containsKey(dateKey)) {
      groupedMessages[dateKey] = [];
    }
    groupedMessages[dateKey]!.add(message);
  }

  return groupedMessages;
}

// Chat participant info
class ChatParticipant {
  final String id;
  final String name;
  final String avatar;
  final bool isOnline;
  final DateTime? lastSeen;

  ChatParticipant({
    required this.id,
    required this.name,
    required this.avatar,
    this.isOnline = false,
    this.lastSeen,
  });
}

final List<ChatParticipant> chatParticipants = [
  ChatParticipant(
    id: "user1",
    name: "Alex",
    avatar: "https://example.com/avatar1.jpg",
    isOnline: true,
  ),
  ChatParticipant(
    id: "user2",
    name: "Jordan",
    avatar: "https://example.com/avatar2.jpg",
    isOnline: false,
    lastSeen: DateTime.now().subtract(Duration(minutes: 5)),
  ),
];
