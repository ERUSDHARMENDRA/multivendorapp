import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shapeyou/Screen/onboard_screen.dart';
import 'package:shapeyou/provider/auth_provider.dart';
import 'package:shapeyou/provider/location_provider.dart';
import 'map_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome-screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    bool _validPhoneNumber = false;
    var _phoneNumberController = TextEditingController();

    void showBottomSheet(context) {
      showModalBottomSheet(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, StateSetter myState) {
          return SingleChildScrollView(
            child: Container(
          child: Padding(
          padding: const EdgeInsets.all(20.0),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Visibility(
              visible: auth.error == 'Invalid OTP' ? false:true,
              child: Container(
              child: Column(
              children: [
              Text(
              auth.error,
              style: TextStyle(color: Colors.red, fontSize: 12),
              ),
              SizedBox(
              height: 5,
              ),
              ],
              ),
              ),
              ),

              Text(
              'LOGIN',
              style:
              TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Text(
              'Enter your phone number to proceed',
              style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              ),
              ),

              SizedBox(
              height: 30,
              ),

              TextField(
              decoration: InputDecoration(
              prefixText: '+91',
              helperText: '10 digit mobile number',
              ),
              autofocus: true,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              controller: _phoneNumberController,
              onChanged: (value) {
              if (value.length == 10) {
              myState(() {
              _validPhoneNumber = true;
              });
              } else {
              myState(() {
              _validPhoneNumber = false;
              });
              }
              },
              ),

              SizedBox(
              height: 10,
              ),

              Row(
              children: [
              Expanded(
              child: AbsorbPointer(
              absorbing: _validPhoneNumber ? false : true,
              child: FlatButton(
              onPressed: () {
              myState((){
              auth.loading= true;
              });

              String number =
              '+91${_phoneNumberController.text}';
              //we don't have locationData here so we send null value
              auth.verifyPhone(context:context, number:number, latitude: null, longitude: null, address: null).then((value) {
              _phoneNumberController.clear();
              auth.loading=false;

              });
              },
              color: _validPhoneNumber ? Theme.of(context).primaryColor : Colors.grey,
              child: auth.loading?CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),):Text(_validPhoneNumber ? 'CONTINUE' : 'ENTER PHONE NUMBER',
              style: TextStyle(
              color: Colors.white,
              ),
              ),

              ),
              ),
              ),
              ],
              ),
              ],
              ),
              ),
              ),
          );
        }),
      );
    }

    final locationData = Provider.of<LocationProvider>(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Positioned(
              right: 0.0,
              top: 10.0,
              child: FlatButton(
                child: Text(
                  'SKIP',
                  style: TextStyle(color: Colors.deepOrangeAccent),
                ),
                onPressed: () {},
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: OnBoardScreen(),
                ),
                Text(
                  'Ready to order from your nearest shop',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  height: 20.0,
                ),
                FlatButton(
                  color: Colors.deepOrangeAccent,
                  child: locationData.loading?CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ):Text(
                    'SET DELIVERY LOCATION',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    setState(() {
                      locationData.loading=true;
                    });
                 await locationData.getCurrentPosition();
                 if (locationData.permissionAllowed==false) {
                   Navigator.pushReplacementNamed(context, MapScreen.id);
                   setState(() {
                     locationData.loading=true;
                   });
                 }else{
                   print('Permission not allowed');
                 }
                  },
                ),
                FlatButton(
                  child: RichText(
                    text: TextSpan(
                      text: 'Already a Customer ?',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orangeAccent,
                            )),
                      ],
                    ),
                  ),
                  onPressed: () {
                    showBottomSheet(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
