import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Divider(),
              Hero(
                  tag: 'Logo',
                  child: Image.asset('images/shapeyou_logo.png', height: 100.0, width: 100.0,)),
            ],
          ),
        ),
      ),
    );
  }
}
