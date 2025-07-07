import 'package:flutter/material.dart';

class ViewNumber extends StatelessWidget {
  final List<String> d;
  ViewNumber(this.d);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("View Phone Numbers")),
      body: ListView.builder(
        itemCount: d.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Phone ${index + 1}: ${d[index]}"),
          );
        },
      ),
    );
  }
}
