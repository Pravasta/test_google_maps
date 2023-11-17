import 'package:flutter/material.dart';
import 'package:maps_flutter/pages/direction_screen.dart';
import 'package:maps_flutter/pages/maps_screen.dart';
import 'package:maps_flutter/pages/picker_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _pages = [
    "Maps Screen",
    "Picker Screen",
    "Direction Screen",
  ];
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: _pages
              .map(
                (e) => ListTile(
                  title: Text(e),
                  onTap: () {
                    setState(() {
                      _index = _pages.indexWhere((element) => element == e);
                    });
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        ),
      ),
      appBar: AppBar(
        title: const Text('Home Page'),
        elevation: 0,
      ),
      body: IndexedStack(
        index: _index,
        children: const [
          MapsScreen(),
          PickerScreen(),
          DirectionScreen(),
        ],
      ),
    );
  }
}
