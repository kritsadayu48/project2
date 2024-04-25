// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project1/page1.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () {
        // Navigate to the next screen after 3 seconds
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            
            builder: (context) => Page1(), // Replace Page1 with your desired page
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/logo1.jpg'),
               SizedBox(height: 20),
              CircularProgressIndicator(), // Add a loading indicator or your logo here
            ],
          ),
        ),
      ),
    );
  }
}
