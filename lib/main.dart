// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, avoid_print
import 'package:autom/add_room_device.dart';
import 'package:autom/forgot_password.dart';
import 'package:autom/loading_screen.dart';
import 'package:autom/login_screen.dart';
import 'package:autom/offline/add_appliance_screen.dart';
import 'package:autom/offline/add_device_screen.dart';
import 'package:autom/offline/home_screen.dart';
import 'package:autom/offline/room_details_screen.dart';
import 'package:autom/room_screen.dart';
import 'package:autom/set_password.dart';
import 'package:flutter/material.dart';
import 'add_iot_device.dart';
import 'home_screen_alt.dart';
import 'custom_color_code.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      title: 'Autom',
      initialRoute: '/loading-screen',
      routes: {
        '/loading-screen': (context) => LoadingScreen(),

        // pre online screens
        '/login': (context) => LoginScreen(),
        '/forget': (context) => ForgotPasswordScreen(),
        '/set-password': (context) => SetPasswordScreen(),
        '/sign_up': (context) => SignUpScreen(),

        // online screens
        '/home': (context) => HomeScreen(),
        '/add-iot-device': (context) => AddIotDevice(),
        '/room': (context) => RoomScreen(),
        '/add-room-device': (context) => AddRoomDevice(),

        // offline screens
        '/offline-home': (context) => OfflineHomeScreen(),
        '/add-offline-device': (context) => OfflineAddDevice(),
        '/offline-room-details': (context) => OfflineRoomDetailScreen(),
        '/offline-add-appliance': (context) => OfflineAddApplianceScreen(),
      },
    );
  }
}
