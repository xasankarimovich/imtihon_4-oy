import 'package:flutter/material.dart';
import 'package:imtihon_4oyuchun/ui/screens/registration_screen/reminder_screen.dart';
import 'package:imtihon_4oyuchun/utils/extension/extension.dart';
import 'package:lottie/lottie.dart';

import '../home_screen.dart';

class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Success')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(

                height: 300.h,
                width: double.infinity,
                child: Lottie.asset('assets/images/congrulation.json'),
              ),
            ),
            // Lottie.asset('assets/images/check.json'),
            Text('Tabriklaymiz!'),
            Text(
                'Siz Flutter Global Hakaton 2024 tadbiriga muvaffaqiyatli ro\'yhatdan o\'tdingiz.'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (ctx){
                  return HomeScreen();
                },),);
              },
              child: Text('Eslatma Belgilash'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (ctx){
                  return ReminderScreen();
                },),);
              },
              child: Text('Bosh Sahifa'),
            ),
          ],
        ),
      ),
    );
  }
}
