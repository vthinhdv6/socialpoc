import 'package:flutter/material.dart';

import 'signinservice.dart';


class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PhoneAuthScreen(),
    );
  }
}
class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Auth Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Gọi hàm xác nhận số điện thoại
                await signInWithPhoneNumber(_phoneNumberController.text);
              },
              child: Text('Send OTP'),
            ),
            SizedBox(height: 32.0),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'OTP'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Gọi hàm đăng nhập bằng số điện thoại và OTP
                await signInWithPhoneNumberAndOTP(
                  _phoneNumberController.text,
                  _otpController.text,
                );
              },
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}

