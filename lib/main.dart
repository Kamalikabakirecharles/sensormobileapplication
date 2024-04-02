import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensormobileapplication/components/ThemeProvider.dart';
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
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    Text(
      'Home Page',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
    MapPage(),
    ProximityPage(), // Add ProximityPage to the widget options
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem( // Add BottomNavigationBarItem for ProximityPage
            icon: Icon(Icons.sensors),
            label: 'Proximity',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: theme.primaryColor,
        unselectedItemColor: theme.primaryColor,
        backgroundColor: theme.hintColor,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          themeNotifier.toggleTheme();
        },
        backgroundColor: theme.hintColor,
        child: Icon(
          Icons.color_lens,
          color: theme.primaryColor,
        ),
      ),
    );
  }
}
