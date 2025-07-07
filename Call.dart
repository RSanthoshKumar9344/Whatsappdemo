import 'package:flutter/material.dart';

class Call extends StatelessWidget {
  final List<dynamic> callData;

  Call(this.callData);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: callData.length,
      itemBuilder: (context, index) {
        var item = callData[index];
        return ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage:
                NetworkImage(item["avatar"] ?? ''), // fallback if missing
          ),
          title: Text(
            '${item["first_name"]} ${item["last_name"]}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(item["email"] ?? ''), // fallback if missing
          trailing: Icon(
            Icons.call,
            color: Colors.green,
          ),
        );
      },
    );
  }
}
