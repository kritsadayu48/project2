import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project1/ManageRoom.dart';

class BookingsUI extends StatefulWidget {
  final String custId;
  final String bookId;
  final String roomId;

  const BookingsUI({Key? key, required this.custId, required this.bookId, required this.roomId}) : super(key: key);

  @override
  _BookingsUIState createState() => _BookingsUIState();
}

class _BookingsUIState extends State<BookingsUI> {
  late Future<List<Map<String, dynamic>>> _bookingsFuture;
  late final String custId;

  @override
  void initState() {
    super.initState();
    custId = widget.custId;
    _bookingsFuture = _fetchBookings(custId);
  }

  Future<List<Map<String, dynamic>>> _fetchBookings(custId) async {
    final response = await http.get(
      Uri.parse('https://s6319410013.sautechnology.com/apiproject/bookings_api.php?custId=${custId}'),
    );

    if (response.statusCode == 200) {
      // Check if response body is empty
      if (response.body.isEmpty) {
        return [];
      }
      List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings(custId): ${widget.custId}'),
      ),
      body: FutureBuilder(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> bookings =
                snapshot.data as List<Map<String, dynamic>>;
            if (bookings.isEmpty) {
              return Center(child: Text('No bookings found'));
            }
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> booking = bookings[index];
                return ListTile(
                  title: Text('Booking ID: ${booking['bookId']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${booking['bookDate']}'),
                      Text('Status: ${booking['bookStatusPaid']}'),
                      Text('CheckIn: ${booking['bookCheckinDate']}'),
                      Text('CheckOut: ${booking['bookCheckoutDate']}'),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManageRoomUI(
                          custId: widget.custId,
                          bookId: booking['bookId'],
                          roomId: booking['roomId'],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
