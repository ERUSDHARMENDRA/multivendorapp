import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shapeyou/Screen/welcome_screen.dart';
import 'package:shapeyou/provider/auth_provider.dart';
import 'package:shapeyou/widgets/image_slider.dart';
import 'package:shapeyou/widgets/my_appbar.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(112),
        child: MyAppBar(),
      ),

      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageSlider(),
          RaisedButton(
              child: Text('Sign Out',style: TextStyle(fontWeight: FontWeight.bold,),),
              onPressed: (){
            auth.error= ' ';
            FirebaseAuth.instance.signOut().then((value){
             Navigator.push(context, MaterialPageRoute(
                 builder: (context) => WelcomeScreen(),
             ));
            });
          }),



          RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, WelcomeScreen.id);
            },
            child: Text('Home Screen'),
          ),
        ],
      ),
    );
  }
}
