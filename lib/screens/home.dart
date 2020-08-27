import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:relaxo/screens/bird.dart';
import 'package:relaxo/screens/float.dart';
import 'package:relaxo/screens/grass.dart';
import 'package:relaxo/screens/rain.dart';
import 'package:relaxo/screens/tent.dart';
import 'package:relaxo/screens/thunder.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void donate() {
    showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: AlertDialog(
                title: Text(
                  'Donate a Pizza!',
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  'paypal.me/encrustace',
                  textAlign: TextAlign.center,
                ),
              ));
        });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Relaxo"),
        actions: [
          IconButton(
            icon: Icon(Icons.local_pizza),
            onPressed: () {
              donate();
            },
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        //color: Colors.indigoAccent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RainWidget(),
                TentWidget(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BirdWidget(),
                ThunderWidget(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GrassWidget(),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFloatButton(),
    );
  }
}
