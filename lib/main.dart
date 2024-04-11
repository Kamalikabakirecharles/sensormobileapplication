import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:sensormobileapplication/components/ThemeProvider.dart';
import 'package:sensormobileapplication/screens/StepCounter.dart';
import 'package:sensormobileapplication/screens/compass.dart';
import 'package:sensormobileapplication/screens/lightsensor.dart';
import 'package:sensormobileapplication/screens/maps.dart';
import 'package:sensormobileapplication/screens/proximitysensor.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: themeNotifier.currentTheme,
      home: const MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({required this.title, Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.hintColor,
        title: Text(
          widget.title,
          style: TextStyle(color: theme.primaryColor),
        ),
      ),
      body: Center(
        child: Text(
          'Welcome',
          style: TextStyle(color: theme.hintColor),
        ),
      ),
      floatingActionButton: _buildSpeedDial(context, themeNotifier, theme),
    );
  }

  Widget _buildSpeedDial(
      BuildContext context, ThemeNotifier themeNotifier, ThemeData theme) {
    return SpeedDial(
      icon: Icons.menu,
      activeIcon: Icons.close,
      backgroundColor: theme.hintColor,
      foregroundColor: theme.primaryColor,
      overlayColor: Colors.transparent,
      children: [
        SpeedDialChild(
          child: Icon(Icons.palette, color: theme.primaryColor),
          backgroundColor: theme.hintColor,
          label: 'Toggle Theme',
          onTap: () => themeNotifier.toggleTheme(),
        ),
        SpeedDialChild(
          child: Icon(Icons.map, color: theme.primaryColor),
          backgroundColor: theme.hintColor,
          label: 'Maps',
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => MapPage())),
        ),
        SpeedDialChild(
          child: Icon(Icons.sensor_door, color: theme.primaryColor),
          backgroundColor: theme.hintColor,
          label: 'Proximity Sensor',
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ProximityPage())),
        ),
        SpeedDialChild(
          child: Icon(Icons.run_circle_outlined, color: theme.primaryColor),
          backgroundColor: theme.hintColor,
          label: 'Step Counter',
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => StepCounterPage())),
        ),
        SpeedDialChild(
          child: Icon(Icons.compass_calibration_outlined,
              color: theme.primaryColor),
          backgroundColor: theme.hintColor,
          label: 'Compass',
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CompassPage())),
        ),
        SpeedDialChild(
          child: Icon(Icons.lightbulb_rounded, color: theme.primaryColor),
          backgroundColor: theme.hintColor,
          label: 'Light Sensor',
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LightSensorPage())),
        ),
      ],
    );
  }
}
