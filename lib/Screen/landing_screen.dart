import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shapeyou/Screen/homeScreen.dart';
import 'package:shapeyou/Screen/map_screen.dart';
import 'package:shapeyou/provider/location_provider.dart';

class LandingScreen extends StatefulWidget {
  static const String id = 'landing-screen';

  const LandingScreen({Key key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  LocationProvider _locationProvider = LocationProvider();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Delivery Address not Set',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Please update your Delivery Location to find nearest Store for you',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Container(
              width: 400,
              child: Image.asset(
                'images/city.png',
                fit: BoxFit.fill,
                color: Colors.black12,
              ),
            ),
            _loading
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  )
                : FlatButton(
                    child: Text(
                      'Set Your Location',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () async {
                      setState(() {
                        _loading = true;
                      });
                      await _locationProvider.getCurrentPosition();
                      if (_locationProvider.permissionAllowed == true) {
                        Navigator.pushReplacementNamed(context, MapScreen.id);
                      } else {
                        Future.delayed(Duration(seconds: 4), () {
                          if (_locationProvider.permissionAllowed == false) {
                            print('Permission not allowed');
                            setState(() {
                              _loading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Please allow Permission to find nearest stores for you'),
                            ));
                          }
                        });
                        Navigator.pushReplacementNamed(context, HomeScreen.id);
                      }
                    }),
          ],
        ),
      ),
    );
  }
}
