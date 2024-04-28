import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project1/confirmpayment.dart';

class ReservationUI extends StatefulWidget {
  final String roomNumber;
  final String roomType;
  final double roomPrice;
  final double bookPrice;
  final String custId;
  final String roomStatus;
  final String roomId;
  final String bookId;

  ReservationUI({
    Key? key,
    required this.roomNumber,
    required this.roomType,
    required this.roomPrice,
    required this.bookPrice,
    required this.roomStatus,
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
    final url = Uri.parse(
      'https://s6319410013.sautechnology.com/apiproject/book_room_api.php',
    );

    try {
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
                title: Text('ห้องเต็ม'),
                content: Text(
                    'ห้องนี้ในระหว่างวันที่ท่านจองมีการจองจากลูกค้าท่านอื่นแล้ว กรุณาเลือกห้องอื่นหรือวันอื่น'),
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
                title: Text('สำเร็จ'),
                content: Text('ทำการจองเรียบร้อยกรุณาตรวจสอบรายละเอียดอีกครั้งที่หน้าถัดไป'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ConfirmPaymentUI(
                            roomNumber: widget.roomNumber,
                            roomType: widget.roomType,
                            roomId: widget.roomId,
                            roomPrice: widget.roomPrice,
                            roomStatus: widget.roomStatus,
                            checkInDate: _checkInController.text,
                            checkOutDate: _checkOutController.text,
                            custId: widget.custId,
                            bookId:
                                bookId ?? '', // ส่งค่า bookId ไปยังหน้าต่อไป
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
        print('ทำการจองไม่สำเร็จ กรุณาลองอีกครั้ง');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _selectCheckInDate(BuildContext context) async {
    final DateTime now = DateTime.now(); // เวลาปัจจุบัน

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _checkInController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate) + ' 12:00:00';
      });
    }
  }

  Future<void> _selectCheckOutDate(BuildContext context) async {
    final DateTime now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _checkOutController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate) + ' 12:00:00';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('เลือกวันที่จะทำการเข้าพัก'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                      labelText: 'วันเช็คอิน',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _checkInController.clear();
                          });
                        },
                      ),
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
                      labelText: 'วันเช็คเอาท์',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _checkOutController.clear();
                          });
                        },
                      ),
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _bookRoom,
                child: Text('จอง'),
                style: ButtonStyle(
                  // Set a linear gradient background
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors
                            .blue.shade900; // Darker when button is pressed
                      return null; // Use the default value
                    },
                  ),
                  foregroundColor: MaterialStateProperty.all(Colors.blue),
                  overlayColor: MaterialStateProperty.all(Colors.blue.shade200),
                  // Apply shadow for elevation
                  elevation: MaterialStateProperty.all(4.0),
                  shadowColor: MaterialStateProperty.all(Colors.blueAccent),
                  // Rounded corners
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30.0), // More rounded corners
                    ),
                  ),
                  // Padding inside the button
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0)),
                  // Text style
                  textStyle: MaterialStateProperty.all(TextStyle(
                    fontSize: 20, // Larger font size
                    fontWeight: FontWeight.bold, // Bold font weight
                  )),
                ),
              ),
        
              SizedBox(
                  height:
                      20), // ระยะห่างระหว่างปุ่ม Book Now กับ Additional Information
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0), // เพิ่มการระบุขอบเขตแนวนอน
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      'Additional information',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
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
