import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shapeyou/Screen/welcome_screen.dart';
import 'package:shapeyou/services/store_services.dart';
import 'package:shapeyou/services/user_services.dart';

class TopPickStore extends StatefulWidget {
  const TopPickStore({Key key}) : super(key: key);

  @override
  _TopPickStoreState createState() => _TopPickStoreState();
}

class _TopPickStoreState extends State<TopPickStore> {
  StoreServices _storeServices = StoreServices();
  UserServices _userServices = UserServices();
  User user = FirebaseAuth.instance.currentUser;
  var _userLatitude = 0.0;
  var _userLongitude = 0.0;

  //need to calculate user LatLong then can calculate distance
  @override
  void initState() {
    _userServices.getUserById(user.uid).then((result) {
      if (user != null) {
        if (mounted) {
          setState(() {
            _userLatitude = result.data()['latitude'];
            _userLongitude = result.data()['longitude'];
          });
        }
      } else {
        Navigator.pushReplacementNamed(context, WelcomeScreen.id);
      }
    });
    super.initState();
  }

  String getDistance(location) {
    var distance = Geolocator.distanceBetween(
        _userLatitude, _userLongitude, location.latitude, location.longitude);
    var distanceInKm = distance / 1000;
    return distanceInKm.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _storeServices.getTopPickedStore(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
          if (!snapShot.hasData) return CircularProgressIndicator();
          List shopDistance = [];
          for (int i = 0; i <= snapShot.data.docs.length - 1; i++) {
            var distance = Geolocator.distanceBetween(
                _userLatitude,
                _userLongitude,
                snapShot.data.docs[i]['location'].latitude,
                snapShot.data.docs[i]['location'].longitude);
            var distanceInKm = distance / 1000;
            shopDistance.add(distanceInKm);
          }
          shopDistance.sort(); // this will sort with nearby location
          if (shopDistance[0] > 10) {
            return Container();
          }
          return Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(height: 20, child: Image.asset('images/like.gif')),
                    Text(
                      'Top Picked Stores For You',
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                    ),
                  ],
                ),
                Container(
                  child: Flexible(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children:
                          snapShot.data.docs.map((DocumentSnapshot document) {
                        if (double.parse(getDistance(document['location'])) <=
                            10) {
                          //show stores only within 10km
                          //need to confirm even no shop nearby or not
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              width: 80,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: Card(
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            child: Image.network(
                                              document['imageUrl'],
                                              fit: BoxFit.cover,
                                            ))),
                                  ),
                                  Container(
                                    height: 35,
                                    child: Text(
                                      document['shopName'],
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    '${getDistance(document['location'])}Km',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          //if no stores
                          return Container();
                        }
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
