// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, avoid_print
import 'package:autom/offline/room_screen.dart';
import 'package:flutter/material.dart';
import '../custom_color_code.dart';
import 'add_room_screen.dart';
import 'device_screen.dart';

class OfflineHomeScreen extends StatefulWidget {
  const OfflineHomeScreen({Key? key}) : super(key: key);

  @override
  State<OfflineHomeScreen> createState() => _OfflineHomeScreenState();
}

class _OfflineHomeScreenState extends State<OfflineHomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _pages() => [
        OfflineRoomScreen(),
        OfflineAddRoomScreen(),
        OfflineDeviceScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = _pages();

    return Scaffold(
      body: SafeArea(
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: secondaryColor,
        elevation: 0,
        selectedIconTheme: IconThemeData(color: primaryColor, size: 50),
        selectedItemColor: primaryColor,
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_sharp, color: primaryColor),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_sharp, color: primaryColor),
            label: 'Add Room',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_sharp, color: primaryColor),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
