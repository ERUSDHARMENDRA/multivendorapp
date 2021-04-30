import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shapeyou/Screen/welcome_screen.dart';
import 'homeScreen.dart';

class SplashScreen extends StatefulWidget {

  static const String id = ' splash-screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Timer(
        Duration(
          seconds: 3,
        ),(){
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if (user==null) {
          Navigator.pushReplacementNamed(context, WelcomeScreen.id);
        }else{
          Navigator.pushReplacementNamed(context, HomeScreen.id);
        }
      });
    }
    );
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('images/shapeyou_logo.png'),
            Text("Let's Shape You", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}
