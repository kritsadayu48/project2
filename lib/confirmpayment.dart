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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Room Type: ${widget.roomType}'),
            Text('Room Number: ${widget.roomNumber}'),
            Text('Check-in Date: ${widget.checkInDate}'),
            Text('Check-out Date: ${widget.checkOutDate}'),
            Text('Price: ${widget.roomPrice}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your payment logic here

                // Navigate to the next screen or show confirmation message

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
                            promptPayId:
                                '0648050398', // ระบุ PromptPay ID ของคุณที่นี่
                            amount:
                                widget.roomPrice, // ระบุจำนวนเงินที่ต้องการชำระ
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
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Confirm Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
