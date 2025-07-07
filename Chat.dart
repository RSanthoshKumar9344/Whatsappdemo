import 'package:flutter/material.dart';
import "ChatDetails.dart";

class Chat extends StatelessWidget {
  final List<dynamic> users;

  const Chat(this.users, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final chat = users[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              chat['avatar'] ?? 'https://via.placeholder.com/150',
            ),
          ),
          title: Text(
            '${chat['first_name'] ?? ''} ${chat['last_name'] ?? ''}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            chat['email'] ?? '',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
          trailing: Text(
            '#${chat['id']}',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatDetails(chat: chat)),
            );
          },
        );
      },
    );
  }
}
