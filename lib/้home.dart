// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:project1/bookings.dart';
import 'package:project1/profile.dart';
import 'package:project1/roomlist.dart';

class HomeUI extends StatefulWidget {
  final String custId;
  final String custFullname; // Add this line
  final String roomType; // Add this line
  final String roomId; // Add this line
  final String bookId; // Add this line

  HomeUI(
      {Key? key,
      required this.custId,
      required this.custFullname,
      required this.roomType,
      required this.roomId,
      required this.bookId,
      
      })
      : super(key: key);

  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  int _currentIndex = 0;
  late final String custFullname;
  late final String custId;
  late final String roomType;
  late final String bookId;
  

  @override
  void initState() {
    super.initState();
    // Assign values to custFullname and custId when the widget is created
    custFullname = widget.custFullname;
    custId = widget.custId;
    roomType = widget.roomType;

    // Call the function to check and delete expired bookings
    checkAndDeleteExpiredBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text('Welcome: ${widget.custFullname}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildHeader(),
            SizedBox(height: 20), // Add space between header and buttons
            _buildTopHotels(),
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
          } else if (newIndex == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BookingsUI(custId: widget.custId, bookId: widget.bookId, roomId: widget.roomId,)),
            );
          } else if (newIndex == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileUI(custId: widget.custId)),
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
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 200.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/standard.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Text(
          'ค้นหาและจองห้องของคุณ',
          style: GoogleFonts.kanit(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width * 0.065,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopHotels() {
    return Column(
      children: <Widget>[
        _buildRoomTypeButton('Deluxe'),
        SizedBox(height: 20),
        _buildRoomTypeButton('Standard'),
        SizedBox(height: 20),
        _buildRoomTypeButton('Suite'),
      ],
    );
  }

  Widget _buildRoomTypeButton(String roomType) {
    return ElevatedButton(
      onPressed: () async {
        List<dynamic> room = await fetchRoomData(roomType);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoomList(roomType: roomType, custId: custId, roomId:'' ,roomPrice:'', bookId: '',),
          ),
        );
      },
      child: Text(
        roomType,
        style: TextStyle(fontSize: 16.0),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.3,
          vertical: MediaQuery.of(context).size.width * 0.07,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> fetchRoomData(roomType) async {
  final response = await http.get(
    Uri.parse(
        'https://s6319410013.sautechnology.com/apiproject/roomlist_api.php?roomType=${roomType}'),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data != null && data is List<dynamic>) {
      return data.cast<Map<String, dynamic>>();
    } else {
      return [];
    }
  } else {
    throw Exception('Failed to load rooms');
  }
}

// Function to check and delete expired bookings
void checkAndDeleteExpiredBookings() async {
  final response = await http.get(
    Uri.parse('https://s6319410013.sautechnology.com/apiproject/expird_books.php'),
  );

  if (response.statusCode == 200) {
    print('Expired bookings checked and deleted successfully');
  } else {
    print('Failed to check and delete expired bookings');
  }
}

