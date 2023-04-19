import 'package:flutter/material.dart';
import 'package:pdf/src/widgets/image_provider.dart';

class buildPrintableData extends StatelessWidget {
  final Map<String, dynamic> record;
  const buildPrintableData(
      this.record
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('${record['id']}'),
        Text('${record['name']}'),
        Text('${record['email']}'),
        Text('${record['phone']}'),
        SizedBox(height: 50,),
      ],
    );
  }
}
