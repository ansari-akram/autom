// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, avoid_print, sized_box_for_whitespace

import 'package:autom/common_function.dart';
import 'package:autom/offline/home_screen.dart';
import 'package:flutter/material.dart';
import 'server_comms.dart';
import 'custom_color_code.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'adaptive_text.dart';
import 'database_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  bool showPassword = true;
  String? preUserName;
  String? prePassWord;

  //_counter = _prefs.then((SharedPreferences prefs) {
  //       return prefs.getInt('counter') ?? 0;
  //     });

  //Already have an account? Log In

  void autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    preUserName = prefs.getString('username');
    prePassWord = prefs.getString('password');

    try {
      String status = await login(preUserName!, prePassWord!);
      String uId = status.split("`|`")[0];
      String uName = status.split("`|`")[1];
      // print("AUTO LOGIN $preUserName $prePassWord $uId, $uName");
      if (uId == "" || uName == "") {
        // ScaffoldMessenger.of(context).showSnackBar(enterValidCreds);
      } else {
        await DatabaseHelper.db
            .query('DELETE FROM ${DatabaseHelper.applianceTable}');
        await DatabaseHelper.db
            .query('DELETE FROM ${DatabaseHelper.roomTable}');
        await DatabaseHelper.db
            .query('DELETE FROM ${DatabaseHelper.deviceTable}');
        await checkData(uId);
        await insertOfflineFromOnline(uId);
        Navigator.pushReplacementNamed(context, '/home', arguments: {
          'user_id': uId,
          'username': uName,
        });
      }
    } finally {}
  }

  SnackBar enterValidCreds = SnackBar(
    content: Text('Enter valid login credentials'),
  );

  @override
  void initState() {
    super.initState();
    // preUserName = _prefs.then((SharedPreferences prefs) {
    //   return prefs.getString('username') ?? '';
    // });
    // print("PRE USER NAME $preUserName");
    // prePassWord = _prefs.then((SharedPreferences prefs) {
    //   return prefs.getString('password') ?? '';
    // });
    // print("PRE PASS WORD $prePassWord");
    //
    // if (preUserName.toString() != "" && prePassWord.toString() != "") {
    try {
      autoLogin();
    } catch (e) {
      // print('DEVICE OFFLINE');
    }
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)?.settings.arguments as Map;
    return data['connection']
        ? Scaffold(
            backgroundColor: primaryColor,
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  // padding: EdgeInsets.all(20),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 150),
                      Image.asset(
                        'assets/images/logo/logo_250.png',
                        height: 200,
                        width: 200,
                      ),
                      // Text(
                      //   'LOGIN',
                      //   style: TextStyle(
                      //     fontSize: AdaptiveTextSize()
                      //         .getAdaptiveTextSize(context, 30),
                      //     fontWeight: FontWeight.bold,
                      //     overflow: TextOverflow.ellipsis,
                      //     letterSpacing: 2,
                      //     color: secondaryColor,
                      //   ),
                      // ),
                      // SizedBox(height: 70),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        child: TextFormField(
                          controller: userName,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(
                              color: secondaryColor,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: secondaryColor,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: secondaryColor,
                                width: 2,
                              ),
                            ),
                            hintStyle: TextStyle(
                              color: secondaryColor,
                            ),
                          ),
                          style: TextStyle(
                            color: secondaryColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        child: TextFormField(
                          controller: password,
                          obscureText: showPassword,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: secondaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: secondaryColor,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: secondaryColor,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: secondaryColor,
                                width: 2,
                              ),
                            ),
                            hintStyle: TextStyle(
                              color: secondaryColor,
                            ),
                          ),
                          style: TextStyle(
                            color: secondaryColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/forget');
                        },
                        child: Text(
                          'Forget your password?',
                          style: TextStyle(
                              color: secondaryColor,
                              fontSize: AdaptiveTextSize()
                                  .getAdaptiveTextSize(context, 15)),
                        ),
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              fontSize: AdaptiveTextSize()
                                  .getAdaptiveTextSize(context, 18),
                              color: secondaryColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/sign_up');
                            },
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                fontSize: AdaptiveTextSize()
                                    .getAdaptiveTextSize(context, 20),
                                color: secondaryColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(height: 70),
                      SizedBox(height: 30),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => secondaryColor),
                          ),
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setString('username', userName.text);
                            prefs.setString('password', password.text);

                            autoLogin();
                          },
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                  fontSize: AdaptiveTextSize()
                                      .getAdaptiveTextSize(context, 20),
                                  color: primaryColor,
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          )
        : OfflineHomeScreen();
  }
}
