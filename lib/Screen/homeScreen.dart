import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shapeyou/Screen/welcome_screen.dart';
import 'package:shapeyou/provider/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      body:  RaisedButton(
        child: Center(
          child: Text('Sign Out'),
        ),
        onPressed: (){
          auth.error = '';

          FirebaseAuth.instance.signOut().then((value){
            Navigator.push(context, MaterialPageRoute(
                builder: (context)=> WelcomeScreen(),
            ));
          });
        },
      ),
    );
  }
}
