import 'package:flutter/material.dart';
import 'package:project1/confirmpayment.dart';

class ConfirmReservationUI extends StatefulWidget {
  final String roomNumber;
  final String roomType;
  final double roomPrice;
  final String checkInDate;
  final String checkOutDate;
  final String roomId;
  final String bookId;
  final String custId;

  const ConfirmReservationUI({
    Key? key,
    required this.roomNumber,
    required this.roomType,
    required this.roomPrice,
    required this.roomId,
    required this.custId,
    required this.bookId,
    required this.checkInDate,
    required this.checkOutDate,
    required double bookPrice,
  }) : super(key: key);

  @override
  _ConfirmReservationUIState createState() => _ConfirmReservationUIState();
}

class _ConfirmReservationUIState extends State<ConfirmReservationUI> {
  late Future<Map<String, dynamic>> _roomDataFuture;

  @override
  void initState() {
    super.initState();
    _roomDataFuture = fetchRoomData(widget.roomNumber);
  }

  Future<Map<String, dynamic>> fetchRoomData(String roomNumber) async {
    // ฟังก์ชันนี้จะจำลองการเรียกใช้ API เพื่อดึงข้อมูลห้อง
    // ในที่นี้ฉันจะใช้ข้อมูลที่ถูกคำนึงถึงเหมือนที่ได้รับผ่านอาร์กิวเมนต์
    // แต่คุณต้องแทนที่ด้วยการเรียกใช้ API จริง
    final Map<String, dynamic> roomData = {
      'roomNumber': widget.roomNumber,
      'roomType': widget.roomType,
      'roomPrice': widget.roomPrice,
    };

    // คำสั่ง await ที่นี่ใช้เพื่อจำลองการรอเวลาในการดึงข้อมูลจาก API
    await Future.delayed(Duration(seconds: 2));

    return roomData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Confirm Reservation ${widget.bookId}'),
         
      ),
      body: SingleChildScrollView(
        // To prevent overflow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<Map<String, dynamic>>(
            future: _roomDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final roomData = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Room Type: ${roomData['roomType']}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Room Number: ${roomData['roomNumber']}',
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text('Check-In: ${widget.checkInDate}',
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text('Check-Out: ${widget.checkOutDate}',
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'จำนวนเข้าพัก',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => ConfirmPaymentUI(
                              bookId: widget.bookId,
                              custId: widget.custId,
                              roomId: widget.roomId,
                              roomNumber: widget.roomNumber,
                              roomType: widget.roomType,
                              roomPrice: roomData['roomPrice'],
                              checkInDate: widget.checkInDate,
                              checkOutDate: widget.checkOutDate,
                            ),
                          ),
                        );
                      },
                      child: Text('Confirm Booking'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green, // Text color
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
