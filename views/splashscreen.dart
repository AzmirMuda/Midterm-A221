import 'dart:async';

import 'package:flutter/material.dart';

import '../models/user.dart';
import 'mainscreen.dart';

class SplashScreen extends StatefulWidget {
  final User user;
  const SplashScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
@override
void initState(){
super.initState();
Timer(
        const Duration(seconds: 5),
        () => Navigator.push(context,
            MaterialPageRoute(builder: (content) =>  MainScreen(user: User(id: "id", name: "name", email: "email", phone: "phone" , address: "address", regdate: "regdate", otp: "otp"),))));
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text(
              "My Hometown Raya",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            CircularProgressIndicator(),
            Text("version 0.1b"),
          ],
        ),
      ),
    );
  }
}
