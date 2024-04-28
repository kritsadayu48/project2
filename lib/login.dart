// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:project1/%E0%B9%89home.dart';
import 'package:project1/register.dart';

class LoginUI extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<Map<String, dynamic>> authenticateUser(
      String custEmail, String custPassword) async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'sautechnology.com',
      user: 'u231198616_s6319410013',
      password: 'S@u6319410013',
      db: 'u231198616_s6319410013_db',
    ));

    var results = await conn.query(
      'SELECT custId, custFullname FROM customer WHERE custEmail = ? AND custPassword = ?',
      [custEmail, custPassword],
    );

    await conn.close();

    if (results.isNotEmpty) {
      return results.first.fields; // Return the fields of the first row
    } else {
      return {}; // Return an empty map if no results are found
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                final custEmail = emailController.text;
                final custPassword = passwordController.text;

                final userData =
                    await authenticateUser(custEmail, custPassword);
                if (userData.isNotEmpty) {
                  final custId = userData['custId'];
                  final custFullname = userData['custFullname'];
                  if (custId != null && custFullname != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeUI(
                                custId: custId.toString(),
                                custFullname: custFullname,
                                roomType: '',
                                roomId: '',
                                bookId: '',
                              )),
                    );
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Login Failed'),
                        content: Text('Incorrect email or password.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterUI()),
                );
              },
              child: Text(
                'Create an account',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
