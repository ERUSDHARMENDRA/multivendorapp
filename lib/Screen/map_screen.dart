import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shapeyou/Screen/homeScreen.dart';
import 'package:shapeyou/provider/auth_provider.dart';
import 'package:shapeyou/provider/location_provider.dart';

import 'login_screen.dart';

class MapScreen extends StatefulWidget {
  static const String id = 'map-screen';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng currentLocation;
  GoogleMapController _mapController;
  bool _locating = false;
  bool _loggedIn = false;
  User user;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });

    if (user != null) {
      setState(() {
        user = FirebaseAuth.instance.currentUser;
        _loggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    final _auth = Provider.of<AuthProvider>(context);

    setState(() {
      currentLocation = LatLng(locationData.latitude, locationData.longitude);
    });

    void onCreated(GoogleMapController controller) {
      setState(() {
        _mapController = controller;
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: currentLocation,
                    zoom: 14.4746,
                  ),
                  zoomControlsEnabled: false,
                  minMaxZoomPreference: MinMaxZoomPreference(1.5, 20.8),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  mapToolbarEnabled: true,
                  mapType: MapType.normal,
                  onCameraMove: (CameraPosition position) {
                    setState(() {
                      _locating = true;
                    });
                    locationData.onCameraMove(position);
                  },
                  onMapCreated: onCreated,
                  onCameraIdle: () {
                    locationData.getMoveCamera();
                  },
                ),
                Center(
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.only(bottom: 40),
                    child: Image.asset(
                      'images/shapeyou_logo.png',
                      color: Colors.black,
                    ),
                    color: Colors.white,
                  ),
                ),

                Center(
                  child: SpinKitPulse(
                    color: Theme.of(context).primaryColor,
                    size: 100.0,
                  ),
                ),

                Positioned(
                  bottom: 0.0,
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _locating
                              ? LinearProgressIndicator(
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor),
                                )
                              : Container(),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 20),
                            child: TextButton.icon(
                              onPressed: () {},
                              icon: Icon(
                                Icons.location_searching,
                                color: Theme.of(context).primaryColor,
                              ),
                              label: Flexible(
                                child: Text(
                                  _locating
                                      ? ('Locating....')
                                      : locationData
                                          .selectedAddress.featureName,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                              _locating
                                  ? ''
                                  : locationData.selectedAddress.addressline,
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 40,
                              child: AbsorbPointer(
                                absorbing: _locating ? true : false,
                                child: FlatButton(
                                  onPressed: () {
                                    if (_loggedIn == false) {
                                      Navigator.pushNamed(
                                          context, LoginScreen.id);
                                    } else {
                                      _auth.updateUser(
                                        id: user.uid,
                                        number: user.phoneNumber,
                                        latitude: locationData.latitude,
                                        longitude: locationData.longitude,
                                        address: locationData
                                            .selectedAddress.addressLine,
                                      );

                                    }
                                  },
                                  color: _locating
                                      ? Colors.grey
                                      : Theme.of(context).primaryColor,
                                  child: Text(
                                    'CONFIRM LOCATION',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//got current latitude nad longitude . now will display our current position
