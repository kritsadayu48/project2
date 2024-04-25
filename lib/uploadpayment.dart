import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:project1/ManageRoom.dart';

class UploadPaymentPage extends StatefulWidget {
  final String bookId;
  final String custId;
  final String roomId;

  UploadPaymentPage(
      {required this.bookId, required this.custId, required this.roomId});

  @override
  _UploadPaymentPageState createState() => _UploadPaymentPageState();
}

class _UploadPaymentPageState extends State<UploadPaymentPage> {
  late int bookId;
  late int custId;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    // Initialize bookId and roomId from the widget's properties
    bookId = int.tryParse(widget.bookId) ?? 0;
    custId = int.tryParse(widget.custId) ?? 0;
  }

  void _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadImage(BuildContext context) async {
    if (_imageFile == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please select an image.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Upload image
    String apiUrl =
        'https://s6319410013.sautechnology.com/apiproject/upload_image_api.php';
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.fields['bookId'] = widget.bookId; // Use bookId from widget
    request.fields['custId'] = widget.custId; // Use custId from widget
    var imageStream = http.ByteStream(_imageFile!.openRead());
    var length = await _imageFile!.length();
    var multipartFile = http.MultipartFile(
      'image',
      imageStream,
      length,
      filename: basename(_imageFile!.path),
    );
    request.files.add(multipartFile);
    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var decodedResponse = jsonDecode(responseData);
      if (decodedResponse.containsKey('message')) {
        // Show success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Success'),
            content: Text(decodedResponse['message']),
            actions: [
              TextButton(
                onPressed: () {
                  // Close dialog
                  Navigator.of(context).pop();
                  // Call API to generate QR data
                  _generateQR(context);
                  // Navigate to ManageRoomUI
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ManageRoomUI(
                        custId: widget.custId,
                        bookId: widget.bookId,
                        roomId: widget.roomId,
                      ),
                    ),
                  );
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else if (decodedResponse.containsKey('error')) {
        // Show error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Error'),
            content: Text(decodedResponse['error']),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      // Handle server error
      print('Error: ${response.reasonPhrase}');
    }
  }

  Future<void> _generateQR(BuildContext context) async {
    try {
      var apiUrl =
          'https://s6319410013.sautechnology.com/apiproject/saveroomqr_api.php';
      var response = await http.post(Uri.parse(apiUrl), body: {
        'roomId': widget.roomId, // Use roomId from widget
        'custId': widget.custId, // Use custId from widget
      });
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData.containsKey('message')) {
          // Handle success
          print(responseData['message']);
        } else if (responseData.containsKey('error')) {
          // Handle error
          print(responseData['error']);
        }
      } else {
        // Handle server error
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle network error
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Payment ${widget.custId}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _imageFile != null
                      ? Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : Icon(
                          Icons.camera_alt,
                          size: 100,
                        ),
                  alignment: Alignment.center,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _uploadImage(context),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Text color
                  padding: EdgeInsets.symmetric(vertical: 16), // Button padding
                ),
                child: Text(
                  'Upload Payment',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Roboto', // Use Google Fonts
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
