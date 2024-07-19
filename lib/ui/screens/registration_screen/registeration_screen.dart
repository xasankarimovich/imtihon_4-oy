import 'package:flutter/material.dart';
import 'package:imtihon_4oyuchun/ui/screens/registration_screen/succes_screen.dart';
class EventRegistrationScreen extends StatefulWidget {
  @override
  _EventRegistrationScreenState createState() => _EventRegistrationScreenState();
}
class _EventRegistrationScreenState extends State<EventRegistrationScreen> {
  int _seatCount = 0;
  String? _paymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register for Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Joylar sonini tanlang'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (_seatCount > 0) _seatCount--;
                    });
                  },
                ),
                Text('$_seatCount'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _seatCount++;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('To\'lov turini tanlang'),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Click'),
              trailing: Radio<String>(
                value: 'click',
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value;
                  });
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Payme'),
              trailing: Radio<String>(
                value: 'payme',
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value;
                  });
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Naqd'),
              trailing: Radio<String>(
                value: 'naqd',
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (ctx){
                 return SuccessScreen();
               },),);
              },
              child: Text('Keyingi'),
            ),
          ],
        ),
      ),
    );
  }
}
