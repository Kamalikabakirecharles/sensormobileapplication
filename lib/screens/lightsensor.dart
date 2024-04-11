import 'dart:async';
import 'package:flutter/material.dart';
import 'package:light_sensor/light_sensor.dart';

class LightSensorPage extends StatefulWidget {
  @override
  _LightSensorPageState createState() => _LightSensorPageState();
}

class _LightSensorPageState extends State<LightSensorPage> {
  double _lightIntensity = 0.0;
  late StreamSubscription<int> _lightSubscription;

  @override
  void initState() {
    super.initState();
    _startListeningToLightSensor();
  }

  @override
  void dispose() {
    _lightSubscription.cancel();
    super.dispose();
  }

  void _startListeningToLightSensor() {
    LightSensor.hasSensor().then((hasSensor) {
      if (hasSensor) {
        _lightSubscription = LightSensor.luxStream().listen((int luxValue) {
          setState(() {
            _lightIntensity = luxValue.toDouble();
          });
        });
      } else {
        print("Device does not have a light sensor");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double containerOpacity =
        1 - (_lightIntensity / 40000);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.hintColor,
        title: Text(
          'Light Sensor',
          style: TextStyle(color: theme.primaryColor),
        ),
        iconTheme: IconThemeData(
          color: theme.primaryColor,
        ),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 26,
              left: 100,
              child: Container(
                width: 196,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 255, 221, 1)
                      .withOpacity(containerOpacity),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 255, 221, 1)
                          .withOpacity(containerOpacity),
                      blurRadius: 10,
                      spreadRadius: 10,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
            Image.asset(
              'lib/assets/bulb.png',
              width: 400,
              height: 400,
            ),
          ],
        ),
      ),
    );
  }
}
