import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String custId;
  final String roomId;
  const QRScanScreen({
    Key? key,
    required this.cameras,
    required this.custId,
    required this.roomId,
  }) : super(key: key);

  @override
  _QRScanScreenState createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool _isQRScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code ${widget.custId},roomId${widget.roomId}'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text('กำลังสแกน QR Code...'),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
  controller.scannedDataStream.listen((scanData) {
    if (!_isQRScanned && scanData.code != null) {
      _updateRoomQRStatus(widget.custId, widget.roomId , scanData.code!);  // Now passing custId along with roomId
      setState(() {
        _isQRScanned = true;  // Consider when to reset this to allow for another scan
      });
    }
  });
}

  Future<void> _updateRoomQRStatus(String custId, String roomId, String s) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://s6319410013.sautechnology.com/apiproject/testunlock.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'custId': custId,
          'roomId': roomId,
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Unlock command sent successfully")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Failed to unlock: ${jsonResponse['message']}")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Failed to send unlock command. Status code: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sending command: $e")),
      );
    }
  }
}
