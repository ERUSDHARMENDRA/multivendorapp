import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shapeyou/provider/location_provider.dart';

class MapScreen extends StatefulWidget {
  static const String id = 'map-screen';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng currentLocation;
  GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);

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
                    child: Image.asset('images/shapeyou_logo.png'),
                    color: Colors.white,
                  ),
                ),

                Positioned(
                  bottom: 0.0,
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Text(locationData.selectedAddress.featureName),
                        Text(locationData.selectedAddress.addressline),
                    ],
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
