import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  final Map<String, dynamic> record;

  ContactScreen(
      this.record,
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${record['id']}'),
            Text('${record['email']}'),
            Text('${record['phone']}'),
          ],
        ),
      ),
    );
  }
}
