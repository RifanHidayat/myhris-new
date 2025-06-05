import 'package:flutter/material.dart';
import 'package:siscom_operasional/utils/constans.dart';

class DetailAuditScreen extends StatelessWidget {

  const DetailAuditScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constanst.colorWhite,
        elevation: 0,
        leadingWidth: 50,
        titleSpacing: 0,
        centerTitle: true,
        title: const Text("Detail Audit"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'haha',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'auditDescription',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Add your action here
              },
              child: Text('Take Action'),
            ),
          ],
        ),
      ),
    );
  }
}