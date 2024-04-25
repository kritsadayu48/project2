import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project1/confirmreservation.dart';

class ReservationUI extends StatefulWidget {
  final String roomNumber;
  final String roomType;
  final double roomPrice;
  final double bookPrice;
  final String custId;
  final String roomId;
  final String bookId;

  ReservationUI({
    Key? key,
    required this.roomNumber,
    required this.roomType,
    required this.roomPrice,
    required this.bookPrice,
    required this.custId,
    required this.bookId,
    required this.roomId,
  }) : super(key: key);

  @override
  _ReservationUIState createState() => _ReservationUIState();
}

class _ReservationUIState extends State<ReservationUI> {
  late TextEditingController _checkInController;
  late TextEditingController _checkOutController;
  String? bookId; // เพิ่มตัวแปร bookId ในคลาส State

  // ฟังก์ชันเพื่อดึงข้อมูลห้องจาก MySQL
  Future<Map<String, dynamic>> fetchRoomData() async {
    final response = await http.get(
      Uri.parse(
        'https://s6319410013.sautechnology.com/apiproject/roomapi.php',
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> roomDataList = json.decode(response.body);

      if (roomDataList.isNotEmpty) {
        final Map<String, dynamic> roomData = roomDataList[0];
        return roomData;
      } else {
        throw Exception('Room data is empty');
      }
    } else {
      throw Exception('Failed to load room data');
    }
  }

  @override
  void initState() {
    super.initState();
    _checkInController = TextEditingController();
    _checkOutController = TextEditingController();
  }

  @override
  void dispose() {
    _checkInController.dispose();
    _checkOutController.dispose();
    super.dispose();
  }

  Future<void> _bookRoom() async {
  final Map<String, dynamic> roomData = await fetchRoomData();

  final url = Uri.parse(
    'https://s6319410013.sautechnology.com/apiproject/book_room_api.php',
  );

  try {
    // ส่งข้อมูลเวลาเช็คอินและเช็คเอาท์ไปยัง API
    final response = await http.post(
      url,
      body: {
        'bookDate': DateTime.now().toString(),
        'bookCheckinDate':
            _checkInController.text + ' 12:00:00', // เช็คอินที่ 12:00 น.
        'bookCheckoutDate':
            _checkOutController.text + ' 12:00:00', // เช็คเอาท์ที่ 12:00 น.
        'bookPrice': widget.roomPrice.toString(),
        'bookStatusPaid': 'R',
        'bookStatusInOut': 'X',
        'custId': widget.custId,
        'roomId': widget.roomId,
        'roomStatus': '1', // เพิ่มข้อมูลสถานะห้อง
      },
    );

    if (response.statusCode == 200) {
      final String responseBody = response.body;
      if (responseBody == "Duplicate Booking") {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Warning'),
              content: Text('The room has already been booked for this date and time.'),
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
        bookId = responseBody; // เก็บค่า bookId ที่ได้จากการจอง
        print('Room booked successfully');

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Room booked successfully'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConfirmReservationUI(
                          roomNumber: widget.roomNumber,
                          roomType: widget.roomType,
                          roomId: widget.roomId,
                          roomPrice: widget.roomPrice,
                          bookPrice: widget.roomPrice,
                          checkInDate: _checkInController.text,
                          checkOutDate: _checkOutController.text,
                          custId: widget.custId,
                          bookId: bookId ?? '', // ส่งค่า bookId ไปยังหน้าต่อไป
                        ),
                      ),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      print('Failed to book room');
    }
  } catch (error) {
    print('Error: $error');
  }
}

  Future<void> _selectCheckInDate(BuildContext context) async {
    final DateTime now = DateTime.now(); // เวลาปัจจุบัน
    final TimeOfDay initialTime =
        TimeOfDay(hour: 12, minute: 0); // เวลาเริ่มต้นที่ 12:00 น.

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:
          DateTime(now.year, now.month, now.day), // เริ่มต้นที่วันปัจจุบัน
      firstDate: DateTime(
          now.year, now.month, now.day), // ไม่อนุญาตให้เลือกวันก่อนหน้านี้
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: initialTime,
      );

      if (pickedTime != null) {
        final DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          _checkInController.text =
              DateFormat('yyyy-MM-dd HH:mm:ss').format(combinedDateTime);
        });
      }
    }
  }

  Future<void> _selectCheckOutDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final TimeOfDay initialTime =
        TimeOfDay(hour: 12, minute: 0); // เวลาเริ่มต้นที่ 12:00 น.

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year, now.month, now.day),
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: initialTime,
      );

      if (pickedTime != null) {
        final DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          _checkOutController.text =
              DateFormat('yyyy-MM-dd HH:mm:ss').format(combinedDateTime);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation ${widget.custId}roomId${widget.roomId}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _selectCheckInDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _checkInController,
                  decoration: InputDecoration(
                    labelText: 'Check-in Date',
                  ),
                  keyboardType: TextInputType.datetime,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () => _selectCheckOutDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _checkOutController,
                  decoration: InputDecoration(
                    labelText: 'Check-out Date',
                  ),
                  keyboardType: TextInputType.datetime,
                ),
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _bookRoom,
              child: Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }
}
