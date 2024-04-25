// editprofilepage.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateProfile() async {
    String newName = _nameController.text;
    String newEmail = _emailController.text;
    String newPhone = _phoneController.text;

    String apiUrl = 'https://s6319410013.sautechnology.com/apiproject/editprofile_api.php';

    Map<String, String> data = {
      'custFullName': newName,
      'custEmail': newEmail,
      'custPhone': newPhone,
    };

    var response = await http.post(Uri.parse(apiUrl), body: data);

    if (response.statusCode == 200) {
      print('Update successful');
    } else {
      print('Failed to update profile');
    }
  }
}
