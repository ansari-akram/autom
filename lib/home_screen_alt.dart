// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, avoid_print
import 'add_room_screen.dart';
import 'package:flutter/material.dart';
import 'show_rooms_screen.dart';
import 'device_list.dart';
import 'custom_color_code.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // int _selectedIndex = 2;
  // int _selectedIndex = 4;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _pages(String userId, String uName) => [
        ShowRoom(userId: userId, username: uName),
        // Center(
        //     child: Icon(
        //   Icons.timelapse_sharp,
        //   size: 150,
        //   color: secondaryColor,
        // )),
        AddRoom(userId: userId, username: uName),
        // Center(
        //     child: Icon(
        //   Icons.cell_tower,
        //   size: 150,
        //   color: secondaryColor,
        // )),
        DeviceList(userId: userId, username: uName),
      ];

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)!.settings.arguments as Map;
    var uName = data['username'];

    final List<Widget> pages = _pages(data['user_id'], uName);

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
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.timelapse_sharp, color: primaryColor),
          //   label: 'Alarm',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_sharp, color: primaryColor),
            label: 'Add Room',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.cell_tower, color: primaryColor),
          //   label: 'Connectivity',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_sharp, color: primaryColor),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
