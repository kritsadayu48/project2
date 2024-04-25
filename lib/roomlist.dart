import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:project1/roomdetails.dart';

class RoomList extends StatefulWidget {
  final String roomType;
  final String custId;
  final String roomId;
  final String bookId;
  final String roomPrice;

  RoomList(
      {required this.roomType,
      required this.custId,
      required this.roomId,
      required this.roomPrice,
      required this.bookId});

  @override
  _RoomListState createState() => _RoomListState();
}

class _RoomListState extends State<RoomList> {
  List<dynamic>? rooms;
  // เรียก API เพื่อดึงข้อมูลห้องตามประเภทที่ระบุ
  Future<void> fetchRooms() async {
    final response = await http.get(
      Uri.parse(
          'https://s6319410013.sautechnology.com/apiproject/roomlist_api.php?roomType=${widget.roomType}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        rooms = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load rooms');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Room List ${widget.custId}'),
      ),
      body: rooms == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: rooms!.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4, // เพิ่มเงาให้กับรายการห้อง
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // กำหนดระยะห่างรอบขอบ
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // กำหนดรูปร่างของรายการห้อง
                  ),
                  child: ListTile(
                    title: Text(
                      'Room Number: ${rooms![index]['roomNumber']}',
                      style: GoogleFonts.kanit(), // ใช้ Google Fonts
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Room Type: ${rooms![index]['roomType']}',
                          style: GoogleFonts.kanit(), // ใช้ Google Fonts
                        ),
                        Text(
                          'Room Price: ${rooms![index]['roomPrice']}',
                          style: GoogleFonts.kanit(), // ใช้ Google Fonts
                        ),
                      ],
                    ),
                    tileColor: Colors.blue[50], // กำหนดสีพื้นหลังของรายการห้อง
                    onTap: () {
                      // ตรวจสอบว่า custId ไม่ใช่ null ก่อนที่จะเปลี่ยนหน้า
                      if (widget.custId != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RoomdetailsUI(
                              roomNumber: rooms![index]['roomNumber'],
                              roomType: rooms![index]['roomType'],
                              roomId: rooms![index]['roomId'],
                              policy: rooms![index]['policy'],
                              roomPrice:
                                  double.parse(rooms![index]['roomPrice']),
                              custId: double.parse(
                                  widget.custId), // แปลงเป็น double ก่อนส่ง
                              bookId: widget.bookId.toString(),
                              roomImage: rooms![index]['roomImage'],
                            ),
                          ),
                        );
                      } else {
                        // จัดการกรณีที่ custId เป็น null
                        print('custId is null');
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
