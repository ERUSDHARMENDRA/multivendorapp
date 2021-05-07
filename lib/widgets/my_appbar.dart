import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shapeyou/Screen/map_screen.dart';
import 'package:shapeyou/provider/location_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppBar extends StatefulWidget {
  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  String _location = 'Choose Your Location';
  String _address = 'Choose Your Address';

  @override
  void initState() {
    getPrefs();
    // TODO: implement initState
    super.initState();
  }

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String location = prefs.getString('location');
    String address = prefs.getString('address');
    setState(() {
      _location = location;
      _address = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);

    return SliverAppBar(
      //now the app bar is scrollable. U can play with this silver app bar
      expandedHeight: 200,
      automaticallyImplyLeading: false,
      elevation: 0.0,
      leading: Container(),
      title: FlatButton(
        onPressed: () {
          locationData.getCurrentPosition();
          if (locationData.permissionAllowed == true) {
            pushNewScreenWithRouteSettings(
              context,
              screen: MapScreen(),
              settings: RouteSettings(name: MapScreen.id),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          } else {
            print('Permission not Allowed');
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    _location == null ? 'Address not Set' : _location,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                  size: 15,
                ),
              ],
            ),
            Flexible(
              child: Text(
                _address == null
                    ? 'Press here to set Delivery Location'
                    : _address,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search ',
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
