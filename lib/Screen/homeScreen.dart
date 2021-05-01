import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shapeyou/Screen/welcome_screen.dart';
import 'package:shapeyou/provider/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home-screen';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RaisedButton(
              child: Text('Sign Out'),
              onPressed: (){

              },
            ),


            RaisedButton(
                 onPressed: (){
                   Navigator.pushNamed(context, WelcomeScreen.id);
                 },
              child: Text('Home Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
