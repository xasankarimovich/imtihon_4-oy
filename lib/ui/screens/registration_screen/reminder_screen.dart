import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reminder')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Eslatma kuni'),
            TextFormField(
              decoration: InputDecoration(
                hintText: '14 09 2024',
              ),
            ),
            SizedBox(height: 20),
            Text('Eslatma vaqti'),
            TextFormField(
              decoration: InputDecoration(
                hintText: '09:00',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {

              },
              child: Text('Esla'),
            ),
          ],
        ),
      ),
    );
  }
}
