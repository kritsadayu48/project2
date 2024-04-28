// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project1/reservation.dart';

class RoomdetailsUI extends StatefulWidget {
  final String roomNumber;
  final String roomType;
  final double roomPrice;
  final double custId;
  final String roomImage;
  final String roomId;
  final String bookId;
  final String policy;

  RoomdetailsUI({
    required this.roomNumber,
    required this.roomType,
    required this.roomPrice,
    required this.custId,
    required this.roomImage,
    required this.roomId,
    required this.bookId,
    required this.policy,
  });

  @override
  _RoomdetailsUIState createState() => _RoomdetailsUIState();
}

class _RoomdetailsUIState extends State<RoomdetailsUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('รายละเอียดห้องพัก'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.roomImage),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // สีแสงเงา
                  spreadRadius: 5, // การกระจายของแสงเงา
                  blurRadius: 7, // ความเบลอของแสงเงา
                  offset: Offset(0, 3), // การเยื้องของแสงเงา
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'หมายเลขห้อง: ${widget.roomNumber}',
                  style: GoogleFonts.kanit(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'ประเภทห้อง: ${widget.roomType}',
                  style: GoogleFonts.kanit(
                    textStyle: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'ราคาต่อคืน: ฿${widget.roomPrice}',
                  style: GoogleFonts.kanit(
                    textStyle: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  height: 10,
                  thickness: 1,
                ),
                Text(
                  'นโยบาย: ${widget.policy}',
                  style: GoogleFonts.kanit(
                    textStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8), // ระยะห่างระหว่างข้อความและไอคอน
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.wifi,
                  size: 32, color: Colors.blue), // ไอคอน WIFI ขนาด 32
              SizedBox(width: 8), // ระยะห่างระหว่างไอคอนและข้อความ
              Text('Free WIFI',
                  style: TextStyle(
                      fontSize: 16, color: Colors.blue)), // ข้อความ Free WIFI
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.local_parking,
                  size: 32, color: Colors.green), // ไอคอน Free Parking ขนาด 32
              SizedBox(width: 8), // ระยะห่างระหว่างไอคอนและข้อความ
              Text('Free Parking',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.green)), // ข้อความ Free Parking
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.pool,
                  size: 32,
                  color: Colors.blue), // ไอคอน Outdoor Swimming Pool ขนาด 32
              SizedBox(width: 8), // ระยะห่างระหว่างไอคอนและข้อความ
              Text('Outdoor Swimming Pool',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue)), // ข้อความ Outdoor Swimming Pool
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(FontAwesomeIcons.banSmoking,
                  size: 32,
                  color: Colors.red), // ไอคอน Outdoor Swimming Pool ขนาด 32
              SizedBox(width: 8), // ระยะห่างระหว่างไอคอนและข้อความ
              Text('No Smoking',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue)), // ข้อความ Outdoor Swimming Pool
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(FontAwesomeIcons.dumbbell,
                  size: 32,
                  color: Colors.brown), // ไอคอน Outdoor Swimming Pool ขนาด 32
              SizedBox(width: 8), // ระยะห่างระหว่างไอคอนและข้อความ
              Text('Fitness center',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue)), // ข้อความ Outdoor Swimming Pool
            ],
          ),

          Spacer(), // ใช้ Spacer เพื่อจัดการตำแหน่งของปุ่มด้านล่าง
          Padding(
            padding:  EdgeInsets.all(70.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ReservationUI(
                      roomType: widget.roomType,
                      roomPrice: widget.roomPrice,
                      bookPrice: widget.roomPrice,
                      roomNumber: widget.roomNumber,
                      roomStatus: '',
                      roomId: widget.roomId,
                      bookId: widget.bookId,
                      custId: widget.custId.toString(),
                    ),
                  ),
                );
              },
              icon: Icon(Icons.book),
              label: Text('Book a Room'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
