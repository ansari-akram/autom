// ignore_for_file: avoid_print, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_const_constructors

import 'dart:async';

import 'package:autom/adaptive_text.dart';
import 'package:autom/common_function.dart';
import 'package:autom/custom_color_code.dart';
import 'package:autom/room_widget.dart';
import 'package:autom/server_comms.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool isInternetWorking = false;
  String? preUserName;
  String? prePassWord;
  bool isDone = false;

  SnackBar enterValidCreds = SnackBar(
    content: Text('Enter valid login credentials'),
  );

  @override
  void initState() {
    Timer(Duration(seconds: 3), () async {
      bool res = await checkInternetConnection();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      preUserName = prefs.getString('username');
      prePassWord = prefs.getString('password');

      // print('LOADING SCREEN ' + res.toString());

      if (res) {
        try {
          String status = await login(preUserName!, prePassWord!);
          String uId = status.split("`|`")[0];
          String uName = status.split("`|`")[1];
          // print("AUTO LOGIN LOADING SCREEN $preUserName $prePassWord $uId, $uName");
          if (uId == "" || uName == "") {
            Navigator.of(context).pushReplacementNamed('/login', arguments: {
              'connection': res,
            });
          } else {
            await checkData(uId);
            Navigator.pushReplacementNamed(context, '/home', arguments: {
              'user_id': uId,
              'username': uName,
            });
          }
        } catch (e) {
          Navigator.of(context).pushReplacementNamed('/login', arguments: {
            'connection': res,
          });
        }
      }
      else {
        Navigator.pushReplacementNamed(context, '/offline-home');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Timer(Duration(seconds: 3), () async {
    //   bool res = await checkInternetConnection();
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   preUserName = prefs.getString('username');
    //   prePassWord = prefs.getString('password');
    //
    //   print('LOADING SCREEN ' + res.toString());
    //
    //   if (res) {
    //     String status = await login(preUserName!, prePassWord!);
    //     String uId = status.split("`|`")[0];
    //     String uName = status.split("`|`")[1];
    //     print("AUTO LOGIN LOADING SCREEN $preUserName $prePassWord $uId, $uName");
    //     if (uId == "" || uName == "") {
    //       Navigator.of(context).pushReplacementNamed('/login', arguments: {
    //         'connection': res,
    //       });
    //     } else {
    //       Navigator.pushReplacementNamed(context, '/home', arguments: {
    //         'user_id': uId,
    //         'username': uName,
    //       });
    //     }
    //   }
    //   else {
    //     Navigator.pushReplacementNamed(context, '/offline-home');
    //   }
    // });

    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo/logo_500.png',
              height: AdaptiveTextSize().getAdaptiveTextSize(context, 250),
              width: AdaptiveTextSize().getAdaptiveTextSize(context, 250),
            ),
            CircularProgressIndicator(
              color: secondaryColor,
              backgroundColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
