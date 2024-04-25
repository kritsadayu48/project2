// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_declarations

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:project1/bookings.dart';
import 'package:project1/profile.dart';
import 'package:project1/roomlist.dart';

class ChatBot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(70.0),
      child: Column(
        children: [
          Text(
            'คุณมีคำถามหรือข้อสงสัยอะไรเกี่ยวกับการจองห้องพักไหมครับ?',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 8.0),
         ElevatedButton(
  onPressed: () {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext,
          Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Builder(
          builder: (BuildContext context) {
            return Dialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: ChatBotDialog(),
            );
          },
        );
      },
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 300),
      transitionBuilder: (BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  },
  child: Text(
    'เริ่มการสนทนากับแชทบอท',
    style: TextStyle(
      fontSize: 16.0,
      color: Colors.white,
    ),
  ),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    padding: EdgeInsets.symmetric(
      vertical: 12.0,
      horizontal: 24.0,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),
),

        ],
      ),
    );
  }
}

class ChatBotDialog extends StatefulWidget {
  @override
  _ChatBotDialogState createState() => _ChatBotDialogState();
}

class _ChatBotDialogState extends State<ChatBotDialog> {
  TextEditingController messageController = TextEditingController();
  List<String> chatMessages = [];

  @override
  Widget build(BuildContext context) {
    // ดึงขนาดหน้าจอของอุปกรณ์
    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: screenSize.width * 0.8, // ใช้ 80% ของความกว้างของหน้าจอ
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'แชทบอท',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: ListView.builder(
              itemCount: chatMessages.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    chatMessages[index],
                    style: TextStyle(
                      color: chatMessages[index].startsWith('คุณ')
                          ? Colors.blue
                          : Colors.green,
                      fontSize: 16.0,
                    ),
                  ),
                  tileColor: chatMessages[index].startsWith('คุณ')
                      ? Colors.grey[200]
                      : Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    hintText: 'พิมพ์ข้อความ...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              ElevatedButton(
                onPressed: () async {
                  // Add user message to chat messages
                  setState(() {
                    chatMessages.add('คุณ: ${messageController.text}');
                  });

                  // Store user message to MySQL
                  await storeMessageToMySQL(messageController.text);

                  // Generate response and add to chat messages
                  String response =
                      await generateResponse(messageController.text);
                  setState(() {
                    chatMessages.add('แชทบอท: $response');
                  });

                  // Clear message controller after sending message
                  messageController.clear();
                },
                child: Text('ส่ง'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('ปิด'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


  Future<String> fetchResponseFromAPI(String query) async {
    final response = await http.get(
      Uri.parse('https://s6319410013.sautechnology.com/apiproject/chatbot.php'),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to fetch response from API');
    }
  }

  Future<String> generateResponse(String message) async {
    if (message.contains('จอง')) {
      return 'คุณสามารถทำการจองห้องพักได้โดยการคลิกที่ปุ่มเลือกประเภทห้องจากด้านบนได้เลยครับ';
    } else if (message.contains('ราคา')) {
      try {
        // Fetch response from API
        String response = await fetchResponseFromAPI('ราคาห้องพัก');
        // Decode the response from JSON format
        List<dynamic> responseData = json.decode(response);
        // Construct a user-friendly message
        String formattedResponse = 'รายการห้องพัก\n';
        for (var room in responseData) {
          formattedResponse +=
              'ประเภท: ${room['roomType']}, ราคา: ${room['roomPrice']} บาท\n';
        }
        return formattedResponse;
      } catch (error) {
        return 'ขอโทษครับ ไม่สามารถแสดงรายการห้องพักในขณะนี้';
      }
    } else {
      return 'ขอโทษครับ ฉันไม่เข้าใจคำถามของคุณ กรุณาลองถามใหม่อีกครั้ง หรือโทรหาเราได้ที่ 0648050398';
    }
  }


Future<void> storeMessageToMySQL(String message) async {
  try {
    final response = await http.post(
      Uri.parse(
          'https://s6319410013.sautechnology.com/apiproject/store_message.php'),
      body: json.encode({'message': message}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('Message stored successfully');
    } else {
      print('Failed to store message');
    }
  } catch (error) {
    print('Error storing message: $error');
  }
}

class HomeUI extends StatefulWidget {
  final String custId;
  final String custFullname; // Add this line
  final String roomType; // Add this line
  final String roomId; // Add this line
  final String bookId; // Add this line

  HomeUI({
    Key? key,
    required this.custId,
    required this.custFullname,
    required this.roomType,
    required this.roomId,
    required this.bookId,
  }) : super(key: key);

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
    checkAndDeleteRoomQRs();
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
                  builder: (context) => BookingsUI(
                        custId: widget.custId,
                        bookId: widget.bookId,
                        roomId: widget.roomId,
                      )),
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
        SizedBox(height: 20),
        ChatBot(),
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
            builder: (context) => RoomList(
              roomType: roomType,
              custId: custId,
              roomId: '',
              roomPrice: '',
              bookId: '',
            ),
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

void checkAndDeleteExpiredBookings() async {
  final response = await http.get(
    Uri.parse(
        'https://s6319410013.sautechnology.com/apiproject/expird_books.php'),
  );

  if (response.statusCode == 200) {
    print('Expired bookings checked and deleted successfully');
  } else {
    print('Failed to check and delete expired bookings');
  }
}

Future<void> checkAndDeleteRoomQRs() async {
  try {
    var response = await http.get(
      Uri.parse('https://s6319410013.sautechnology.com/apiproject/check_delete_roomqr.php'),
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        print('Error: ${responseData['error']}');
      } else if (responseData['success'] != null) {
        print(responseData['success']);
        print('Deleted IDs: ${responseData['deleted']}');
      } else {
        print(responseData['message']);
      }
    } else {
      print('Failed to connect to the API');
    }
  } catch (e) {
    print('Error: $e');
  }
}