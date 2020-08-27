import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThunderWidget extends StatefulWidget {
  @override
  _ThunderWidgetState createState() => _ThunderWidgetState();
}

class _ThunderWidgetState extends State<ThunderWidget> {
  double volume = 1.0;
  IconData playerIcon = Icons.play_arrow;

  void playPause(String value) async {
    var methodChannel = MethodChannel("thunderPlayPause");
    String data = await methodChannel.invokeMethod(value);
    if (data == "playing") {
      setState(() {
        playerIcon = Icons.pause;
      });
    } else if (data == "paused") {
      setState(() {
        playerIcon = Icons.play_arrow;
      });
    }
  }

  void volumeAction(String value) async{
    var methodChannel = MethodChannel("thunderVolumeAction");
    String data = await methodChannel.invokeMethod(value);
    volume = double.parse(data);
  }

  @override
  void initState() {
    playPause("thunderInit");
    volumeAction("thunderInit");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 100.0,
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            color: Colors.greenAccent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Image(image: AssetImage('assets/images/thunder.png')),
              IconButton(
                icon: Icon(playerIcon),
                onPressed: () {
                  setState(() {
                    playPause("thunderPlayPause");
                  });
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Container(
          height: 28.0,
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            color: Colors.greenAccent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Slider(
            divisions: 10,
            value: volume,
            onChanged: (mValue) {
              setState(() {
                volumeAction(mValue.toString());
                volume = mValue;
              });
            },
          ),
        )
      ],
    );
  }
}
