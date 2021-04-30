import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shapeyou/Screen/homeScreen.dart';
import 'package:shapeyou/Screen/map_screen.dart';
import 'package:shapeyou/Screen/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shapeyou/provider/auth_provider.dart';
import 'package:shapeyou/provider/location_provider.dart';

import 'Screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_)=> AuthProvider(),
        ),

        ChangeNotifierProvider(
          create: (_)=> LocationProvider(),
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
     initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id:(context)=>SplashScreen(),
        HomeScreen.id:(context)=> HomeScreen(),
        WelcomeScreen.id:(context)=>WelcomeScreen(),
        MapScreen.id:(context)=>MapScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}



