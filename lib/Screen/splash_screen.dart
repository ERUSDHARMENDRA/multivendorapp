import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shapeyou/Screen/landing_screen.dart';
import 'package:shapeyou/Screen/main_screen.dart';
import 'package:shapeyou/Screen/welcome_screen.dart';
import 'package:shapeyou/services/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homeScreen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = ' splash-screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    Timer(
        Duration(
          seconds: 3,
        ), () {
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if (user == null) {
          Navigator.pushReplacementNamed(context, WelcomeScreen.id);
        } else {
          //if user has data on firestore..
          getUserData();
        }
      });
    });
    // TODO: implement initState
    super.initState();
  }

  getUserData() async {
    UserServices _userServices = UserServices();
    _userServices.getUserById(user.uid).then((result) {
      //check location details has or not
      if (result.data()['address'] != null) {
        //if address details exists
        updatePrefs(result);
      }
      //if address detail DNE
      Navigator.pushReplacementNamed(context, LandingScreen.id);
    });
  }

  Future<void> updatePrefs(result) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', result['latitude']);
    prefs.setDouble('longitude', result['longitude']);
    prefs.setString('address', result['address']);
    prefs.setString('location', result['location']);
    //after updating prefs , navigate to homepage
    Navigator.pushReplacementNamed(context, MainScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('images/shapeyou_logo.png'),
            Text(
              "Let's Shape You",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
