import 'package:flutter/material.dart';
import 'package:shapeyou/Screen/top_picke_storer.dart';
import 'package:shapeyou/widgets/image_slider.dart';
import 'package:shapeyou/widgets/my_appbar.dart';
import 'package:shapeyou/widgets/near_by_store.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[280],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(112),
        child: MyAppBar(),
      ),
      body: ListView(
        children: [
          ImageSlider(),
          Container(color: Colors.white, height: 200, child: TopPickStore()),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: NearbyStores(),
          ),
        ],
      ),
    );
  }
}
