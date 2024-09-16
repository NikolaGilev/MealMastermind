import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  final List<Map<String, String>> recentMessages = [
    {
      'friendName': 'John Doe',
      'message': 'Hey, how are you?',
      'time': '2:45 PM',
    },
    {
      'friendName': 'Jane Smith',
      'message': 'Let\'s catch up soon!',
      'time': '1:30 PM',
    },
    {
      'friendName': 'Alex Johnson',
      'message': 'Did you finish the project?',
      'time': 'Yesterday',
    },
  ];

  final List<Map<String, String>> friendsList = [
    {
      'name': 'John Doe',
    },
    {
      'name': 'Jane Smith',
    },
    {
      'name': 'Alex Johnson',
    },
    {
      'name': 'Chris Williams',
    },
    {
      'name': 'Emma Brown',
    },
    {
      'name': 'Jane Smith',
    },
    {
      'name': 'Alex Johnson',
    },
    {
      'name': 'Chris Williams',
    },
    {
      'name': 'Emma Brown',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: Column(
        children: [
          _buildRecentMessagesSection(),
          Divider(),
          _buildFriendsListSection(),
        ],
      ),
    );
  }

  Widget _buildRecentMessagesSection() {
    return Expanded(
      child: ListView.builder(
        itemCount: recentMessages.length,
        itemBuilder: (context, index) {
          final message = recentMessages[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(
                message['friendName']!.substring(0, 1), // Initial of the friend's name
              ),
            ),
            title: Text(message['friendName']!),
            subtitle: Text(message['message']!),
            trailing: Text(message['time']!),
            onTap: () {
              // Navigate to the chat screen with the selected friend
            },
          );
        },
      ),
    );
  }

  Widget _buildFriendsListSection() {
    return Expanded(
      child: ListView.builder(
        itemCount: friendsList.length,
        itemBuilder: (context, index) {
          final friend = friendsList[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(
                friend['name']!.substring(0, 1), // Initial of the friend's name
              ),
            ),
            title: Text(friend['name']!),
            onTap: () {
              // Navigate to the chat screen with the selected friend
            },
          );
        },
      ),
    );
  }
}
