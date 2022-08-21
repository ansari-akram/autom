// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, avoid_print, sized_box_for_whitespace

import 'package:autom/server_comms.dart';
import 'package:flutter/material.dart';
import 'adaptive_text.dart';
import 'custom_color_code.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  TextEditingController uId = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  String userName = "";
  bool show = false;

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)?.settings.arguments as Map;
    userName = data['username'];

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: secondaryColor,
                        size: AdaptiveTextSize()
                            .getAdaptiveTextSize(context, 25),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Column(
                      children: [
                        Text(
                          'SET NEW',
                          style: TextStyle(
                            fontSize: AdaptiveTextSize()
                                .getAdaptiveTextSize(context, 30),
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: 2,
                            color: secondaryColor,
                          ),
                        ),
                        Text(
                          'PASSWORD',
                          style: TextStyle(
                            fontSize: AdaptiveTextSize()
                                .getAdaptiveTextSize(context, 30),
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: 2,
                            color: secondaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                        width: AdaptiveTextSize()
                            .getAdaptiveTextSize(context, 30)),
                  ],
                ),
                // SizedBox(height: 70),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 10),
                  child: TextFormField(
                    controller: uId,
                    decoration: InputDecoration(
                      labelText: 'Unique ID',
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
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    'Copy and Paste the Unique ID that has been sent to your registered mail',
                    style: TextStyle(
                      color: secondaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 10),
                  child: TextFormField(
                    controller: password,
                    decoration: InputDecoration(
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 10),
                  child: TextFormField(
                    controller: confirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
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
                Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.resolveWith((states) => secondaryColor),
                    ),
                    onPressed: () async {
                      if (uId.text != "" && password.text == confirmPassword.text) {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return Center(
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: CircularProgressIndicator(
                                    color: secondaryColor,
                                  ),
                                ),
                              );
                            });
                        List result =
                        await setNewPassword(userName, uId.text, password.text);
                        print(result);
                        if (result[0]) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          // Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result[1]),
                            ),
                          );
                        }
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          'SET PASSWORD',
                          style: TextStyle(
                            fontSize: AdaptiveTextSize().getAdaptiveTextSize(context, 20),
                            color: primaryColor,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
