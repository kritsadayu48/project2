// ignore_for_file: sort_child_properties_last, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project1/%E0%B9%89home.dart';
import 'package:project1/bookings.dart';
import 'package:project1/camerascan.dart';
import 'package:project1/profile.dart';

class ManageRoomUI extends StatefulWidget {
  final String custId;
  final String bookId;
  final String roomId;

  ManageRoomUI(
      {Key? key,
      required this.custId,
      required this.bookId,
      required this.roomId})
      : super(key: key);

  @override
  _ManageRoomUIState createState() => _ManageRoomUIState();
}

class _ManageRoomUIState extends State<ManageRoomUI> {
  int _currentIndex = 0;

  Future<void> _checkUnlock(String roomId) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://s6319410013.sautechnology.com/apiproject/testunlock.php'),
        body: jsonEncode({'roomId': roomId}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Unlock command sent successfully")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Failed to unlock: ${jsonResponse['message']}")),
          );
        }
      } else {
        print(
            'Failed to send unlock command. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to send unlock command")),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sending command")),
      );
    }
  }

  Future<void> _checkLock(String roomId) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://s6319410013.sautechnology.com/apiproject/testlock.php'),
        body: jsonEncode({'roomId': roomId}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Lock command sent successfully")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Failed to lock: ${jsonResponse['message']}")),
          );
        }
      } else {
        print(
            'Failed to send lock command. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to send lock command")),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sending command")),
      );
    }
  }

  void _showUnlockWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Are you sure you want to unlock the door?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _checkUnlock(widget.roomId);
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }

  void _showLockWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Are you sure you want to lock the door?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _checkLock(widget.roomId);
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('bookId${widget.bookId},roomId${widget.roomId}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _showUnlockWarningDialog(context);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_open),
                  SizedBox(width: 15), // ระยะห่างระหว่างไอคอนกับข้อความ
                  Text('Unlock Door'), // ข้อความบนปุ่ม
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            ElevatedButton(
              onPressed: () {
                _showLockWarningDialog(context);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_sharp),
                  SizedBox(width: 15), // ระยะห่างระหว่างไอคอนกับข้อความ
                  Text('Lock Door'), // ข้อความบนปุ่ม
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
          if (newIndex == 0) {
            // Home page code
            Navigator.popUntil(context, ModalRoute.withName('/'));
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeUI(custId:widget.custId, custFullname: '', roomType: '', roomId: '', bookId: '',),
              ),
            );
          } else if (newIndex == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingsUI(
                  custId: widget.custId,
                  bookId: widget.bookId,
                  roomId: widget.roomId,
                ),
              ),
            );
          } else if (newIndex == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileUI(custId: widget.custId),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Bookings',
            icon: Icon(Icons.document_scanner),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final cameras = await availableCameras();
          if (cameras.isEmpty) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('No camera found'),
                  content: Text('No camera is available to use.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          } else {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QRScanScreen(cameras: cameras ?? []),
              ),
            );
          }
        },
        child: Icon(Icons.qr_code_scanner),
        tooltip: 'Manage Room ',
      ),
    );
  }
}
