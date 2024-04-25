// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
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
        title: Text('รายละเอียดห้อง ${widget.custId}'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 200,
            width: double.infinity,
            child: Image.network(
              widget.roomImage,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15), // ปรับเป็น left: 16.0 เพื่อให้มีการเว้นระยะขอบซ้าย
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment
                  .start, // เพิ่ม mainAxisAlignment เพื่อชิดซ้าย
              children: <Widget>[
                Text(
                  'หมายเลขห้อง: ${widget.roomNumber}',
                  style: GoogleFonts.kanit(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'ประเภทห้อง: ${widget.roomType}',
                  style: GoogleFonts.kanit(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'ราคาต่อคืน: ฿${widget.roomPrice}',
                  style: GoogleFonts.kanit(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                Divider(
                  color: Colors.grey, // สีของเส้นขั้น
                  height: 10, // ความสูงของเส้นขั้น
                  thickness: 1, // ความหนาของเส้นขั้น
                  indent: 0, // ระยะห่างจากขอบซ้าย
                  endIndent: 0, // ระยะห่างจากขอบขวา
                ),
                Text(
                  'นโยบาย: ${widget.policy}',
                  style: GoogleFonts.kanit(
                    textStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontStyle: FontStyle.normal,
                      color: Colors.black, // สีข้อความ
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 100,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
