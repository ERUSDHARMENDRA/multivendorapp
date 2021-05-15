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
      backgroundColor: Colors.grey[200],
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [MyAppBar()];
        },
        body: ListView(
          padding: EdgeInsets.only(top: 0.0),
          children: [
            ImageSlider(),
            Container(
              color: Colors.white,
              child: TopPickStore(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: NearByStores(),
            ),
          ],
        ),
      ),
    );
  }
}
