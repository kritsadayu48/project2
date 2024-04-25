// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterUI extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Future<void> _register() async {
    final url = Uri.parse('https://s6319410013.sautechnology.com/apiproject/register_api.php'); // แทนที่ด้วย URL ของ API ของคุณ

    final response = await http.post(
      url,
      body: {
        'custFullname': _fullnameController.text,
        'custUsername': _usernameController.text,
        'custPassword': _passwordController.text,
        'custEmail': _emailController.text,
        'custPhone': _phoneController.text,
      },
    );

    if (response.statusCode == 200) {
      // ลงทะเบียนสำเร็จ
      print('Registration successful');
      // เพิ่มโค้ดสำหรับการแสดงข้อความหรือการนำทางไปยังหน้าอื่นตามความเหมาะสม
    } else {
      // ลงทะเบียนไม่สำเร็จ
      print('Registration failed');
      // เพิ่มโค้ดสำหรับการแสดงข้อความหรือการทำสิ่งอื่นตามความเหมาะสม
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Create an Account',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _fullnameController,
                decoration: InputDecoration(labelText: 'Fullname'),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Phone'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // สีพื้นหลังของปุ่ม
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30), // ขนาดของปุ่ม
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // รูปร่างของปุ่ม
                  ),
                ),
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // สีของข้อความในปุ่ม
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // กลับไปยังหน้า LoginUI
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back, color: Colors.blue),
                    SizedBox(width: 5.0),
                    Text(
                      'Back to Login',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
