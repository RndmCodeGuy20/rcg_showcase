import 'package:flutter/material.dart';

class NewChatOptions extends StatelessWidget {
  const NewChatOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      // padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      // height: 300.0,
      width: MediaQuery.of(context).size.width - 32.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: [
          _buildOptionItem(
            icon: Icons.chat_bubble_outline,
            title: "New Chat",
            subtitle: "Send a message to your contact",
            onTap: () {
              // Handle new chat action
            },
          ),
          Divider(color: Colors.black.withValues(alpha: 0.14), thickness: 0.5),
          _buildOptionItem(
            icon: Icons.person_add_outlined,
            title: "New Contact",
            subtitle: "Add a contact to be able to send messages",
            // tag: "chat app",
            onTap: () {
              // Handle new contact action
            },
          ),
          Divider(color: Colors.black.withValues(alpha: 0.14), thickness: 0.5),
          _buildOptionItem(
            icon: Icons.group_outlined,
            title: "New Community",
            subtitle: "Join the community around you",
            onTap: () {
              // Handle new community action
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    String? tag,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container
            SizedBox(
              width: 40.0,
              height: 40.0,
              child: Icon(icon, color: Colors.black, size: 20.0),
            ),
            SizedBox(width: 16.0),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                  // SizedBox(height: 4.0),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black.withValues(alpha: 0.54),
                            fontFamily: 'Gilroy',
                          ),
                        ),
                      ),
                      if (tag != null) ...[
                        SizedBox(width: 8.0),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
