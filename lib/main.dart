import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shapeyou/Screen/homeScreen.dart';
import 'package:shapeyou/Screen/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shapeyou/provider/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_)=> AuthProvider(),
        ),
      ],
    child: MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.deepOrangeAccent,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
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
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>WelcomeScreen(),
           ));
         }else{
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen(),
           ));
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


