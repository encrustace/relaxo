import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFloatButton extends StatefulWidget {
  @override
  _CustomFloatButtonState createState() => _CustomFloatButtonState();
}

class _CustomFloatButtonState extends State<CustomFloatButton>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  //Timer
  String timerValue = "0";
  bool yes = false;
  IconData timerIcon = Icons.timer;
  Timer timer;

  Widget mainIcon() {
    if (timerValue == "0") {
      return AnimatedIcon(
        icon: AnimatedIcons.view_list,
        progress: _animateIcon,
      );
    } else {
      return IconButton(
        icon: Text(
          formatDate(
              DateTime(0, 0, 0, 0, 0, int.parse(timerValue)), [nn, ':', ss]),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.red,
            fontSize: 10.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          setState(() {
            setTimer(1);
          });
        },
      );
    }
  }

  void setTimer(int value) async {
    var methodChannel = MethodChannel("setTimer");
    String data = await methodChannel.invokeMethod('$value');
    if (data == "started") {
      fetchTimer();
    } else if (data == "cancelled") {
      setState(() {
        timerValue = "0";
      });
    } else {
      setState(() {
        timerValue = data;
      });
    }
  }

  void fetchTimer() async {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timerValue == "0") {
        timer.cancel();
      } else {
        setTimer(0);
      }
    });
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.greenAccent,
      end: Colors.red,
    ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.00, 1.00, curve: Curves.linear)));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    fetchTimer();
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget ten() {
    return Container(
      child: FloatingActionButton(
        heroTag: '10',
        onPressed: () {
          timerValue = "600";
          setTimer(600);
          animate();
        },
        child: Text("10:00"),
      ),
    );
  }

  Widget twenty() {
    return Container(
      child: FloatingActionButton(
        heroTag: '20',
        onPressed: () {
          timerValue = "1200";
          setTimer(1200);
          animate();
        },
        child: Text("20:00"),
      ),
    );
  }

  Widget thirty() {
    return Container(
      child: FloatingActionButton(
        heroTag: '30',
        onPressed: () {
          timerValue = "1800";
          setTimer(1800);
          animate();
        },
        child: Text("30:00"),
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        heroTag: 'toggle',
        backgroundColor: _buttonColor.value,
        child: mainIcon(),
        onPressed: animate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 3.0,
            0.0,
          ),
          child: ten(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: twenty(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 1.0,
            0.0,
          ),
          child: thirty(),
        ),
        toggle(),
      ],
    );
  }
}
