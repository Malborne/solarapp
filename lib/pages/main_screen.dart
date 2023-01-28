import 'package:flutter/material.dart';
import 'package:solar/pages/home_page.dart';
import 'package:solar/pages/solar_page.dart';

import 'energy_page.dart';
import 'loading_screen.dart';

class MainScreen extends StatefulWidget {
  final weatherData;
  final priceData;
  const MainScreen({super.key, required this.weatherData, required this.priceData});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
    late final List<Widget> _widgetOptions;
  @override
  void initState() {
     _widgetOptions = <Widget>[
      Center(child: HomePage(weatherData: widget.weatherData)),
       Center(child: SolarPage(priceData: widget.priceData,)),
       Center(child: EnergyPage()),
      const Text(
        'Settings',
        style: optionStyle,
      ),
    ];
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solar Solutions'),
        backgroundColor: Colors.purple,
        elevation: 0,
        actions: <Widget>[
          // action button
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: (){},
            // onPressed: () => Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const HomePage()
            //   ),
            // ),
          ),

        ],
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
            icon: Icon(Icons.solar_power),
            label: 'Solar Production',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.energy_savings_leaf),
            label: 'Energy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
        onTap: _onItemTapped,
      ),
    );
  }
}