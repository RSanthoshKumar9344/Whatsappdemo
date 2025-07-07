import 'package:flutter/material.dart';

class Status extends StatelessWidget {
  final List<dynamic> statusData;

  const Status(this.statusData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: statusData.length,
      itemBuilder: (context, index) {
        final item = statusData[index];
        return ListTile(
          leading: CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(
              item["avatar"] ?? "https://via.placeholder.com/150",
            ),
          ),
          title: Text(
            '${item["first_name"] ?? ''} ${item["last_name"] ?? ''}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(item["email"] ?? ''),
          trailing: Text(
            '#${item["id"]}',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }
}
