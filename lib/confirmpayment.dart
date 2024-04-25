import 'package:flutter/material.dart';
import 'package:project1/uploadpayment.dart';
import 'package:promptpay_qrcode_generate/promptpay_qrcode_generate.dart';

class ConfirmPaymentUI extends StatefulWidget {
  final String roomNumber;
  final String roomType;
  final double roomPrice;
  final String checkInDate;
  final String checkOutDate;
  final String custId;
  final String bookId;
  final String roomId;

  const ConfirmPaymentUI({
    Key? key,
    required this.roomNumber,
    required this.roomType,
    required this.roomPrice,
    required this.custId,
    required this.bookId,
    required this.roomId,
    required this.checkInDate,
    required this.checkOutDate,
  }) : super(key: key);

  @override
  _ConfirmPaymentUIState createState() => _ConfirmPaymentUIState();
}

class _ConfirmPaymentUIState extends State<ConfirmPaymentUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Payment Method ${widget.bookId}'),
        backgroundColor:
            Colors.blue, // Consistent color with the previous screen
      ),
      body: SingleChildScrollView(
        // To prevent overflow
        child: Padding(
          padding:  EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Room Type: ${widget.roomType}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Room Number: ${widget.roomNumber}',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('Check-in Date: ${widget.checkInDate}',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('Check-out Date: ${widget.checkOutDate}',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('Price: \ ${widget.roomPrice.toStringAsFixed(2)} บาท',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Generate QR code
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Payment Confirmation'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('กรุณาสแกนเพื่อชำระ'),
                            SizedBox(height: 10),
                            QRCodeGenerate(
                              promptPayId: '0648050398',
                              amount: widget.roomPrice,
                              width: 400,
                              height: 400,
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UploadPaymentPage(
                                    custId: widget.custId,
                                    bookId: widget.bookId,
                                    roomId: widget.roomId,
                                  ),
                                ),
                              );
                            },
                            child: Text('Upload Payment Image'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.green, // Text color
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 12),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Confirm Payment'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
