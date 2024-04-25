// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:project1/login.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('แอพจองห้องพัก'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Image.asset(
                'assets/images/logo1.jpg'), // แทนที่ 'your_image.jpg' ด้วยชื่อไฟล์ของรูปที่คุณต้องการใช้
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ค้นหาห้องที่ดีเพื่อคุณ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Find the best room for you',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginUI()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // สีพื้นหลังของปุ่ม
                      padding: EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30), // ขนาดของปุ่ม
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // รูปร่างของปุ่ม
                      ),
                    ),
                    child: Text(
                      'Access Marketplace',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // สีของข้อความในปุ่ม
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
