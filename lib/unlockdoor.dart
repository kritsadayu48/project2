import 'package:flutter/material.dart';

class UnlockDoorUI extends StatefulWidget {
  @override
  _UnlockDoorUIState createState() => _UnlockDoorUIState();
}

class _UnlockDoorUIState extends State<UnlockDoorUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unlock Door'), // กำหนดหัวเรื่องของ AppBar
      ),
      body: Center(
        child: Text('Unlock Door Content'), // เนื้อหาภายในหน้า
      ),
    );
  }
}
