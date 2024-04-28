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
  final String roomType;
  String roomStatus;
  

  ManageRoomUI({
    Key? key,
    required this.custId,
    required this.bookId,
    required this.roomId,
    required this.roomType,
    required this.roomStatus,
  }) : super(key: key);

  @override
  _ManageRoomUIState createState() => _ManageRoomUIState();
  static String getStatusText(String roomStatus) {
    return roomStatus == "1" ? 'ล็อค' : 'ปลดล็อค';
  }
}

class _ManageRoomUIState extends State<ManageRoomUI> {
  int _currentIndex = 0;
  List<String> _actionLog = [];

  void _refreshScreen() {
    fetchDoorStatus(widget.roomId);
  }

  Future<void> fetchDoorStatus(String roomId) async {
  try {
    var url = Uri.parse('https://s6319410013.sautechnology.com/apiproject/freshroom.php?roomId=$roomId');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      setState(() {
        widget.roomStatus = data['roomQRStatus'].toString();  // ตรวจสอบว่าเป็น String "1" หรือ "0"
      });
    } else {
      print('Failed to fetch door status with status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching door status: $e');
  }
}


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
          _actionLog.insert(0, 'Unlocked door at ${DateTime.now()}');
          

          // บันทึกการปลดล็อคลงในฐานข้อมูล
          await http.post(
            Uri.parse(
                'https://s6319410013.sautechnology.com/apiproject/record_unlock.php'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'roomId': roomId,
              'custId': widget.custId,
              'action': 'Unlocked'
            }),
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
          _actionLog.insert(0, 'Locked door at ${DateTime.now()}');

          // บันทึกการล็อคลงในฐานข้อมูล
          await http.post(
            Uri.parse(
                'https://s6319410013.sautechnology.com/apiproject/record_lock.php'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'roomId': roomId,
              'custId': widget.custId,
              'action': 'Locked'
            }),
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
          content: Text("คุณต้องการปลดล็อคประตูใช่หรือไม่?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
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
          content: Text("คุณต้องการล็อคประตูใช่หรือไม่?"),
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

  Future<void> _onQRScanResult(BuildContext context) async {
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
          builder: (context) => QRScanScreen(
            cameras: cameras,
            custId: widget.custId,
            roomId: widget.roomId,
          ),
        ),
      );
      if (result != null) {
        setState(() {
          _actionLog.insert(0, result);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('ห้อง10${widget.roomId}'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _refreshScreen(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            Text(
              'รายละเอียดห้องของท่าน',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.hotel),
                        SizedBox(width: 8),
                        Text('ประเภทห้อง: ${widget.roomType}'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.lock),
                        SizedBox(width: 8),
                        Text('สถานะประตู: ${ManageRoomUI.getStatusText(widget.roomStatus)}'),

                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: widget.roomStatus == 'Locked'
                      ? () {
                          _showUnlockWarningDialog(context);
                        }
                      : () {
                          _onQRScanResult(context);
                        },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(widget.roomStatus == 'Locked'
                          ? Icons.lock_open
                          : Icons.lock),
                      SizedBox(width: 15),
                      Text(widget.roomStatus == 'Locked'
                          ? 'Unlock Door'
                          : 'Lock Door'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: widget.roomStatus == 'Locked'
                      ? null
                      : () {
                          _showLockWarningDialog(context);
                        },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_sharp),
                      SizedBox(width: 15),
                      Text('Lock Door'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'ประวัติการล็อค/ปลดล็อค',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _actionLog.map((log) {
                  return Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(log),
                  );
                }).toList(),
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
            Navigator.popUntil(context, ModalRoute.withName('/'));
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeUI(
                  custId: widget.custId,
                  custFullname: '',
                  roomType: '',
                  roomId: '',
                  bookId: '',
                ),
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
        onPressed: () {
          _onQRScanResult(context);
        },
        child: Icon(Icons.qr_code_scanner),
        tooltip: 'Manage Room ',
      ),
    );
  }
}
