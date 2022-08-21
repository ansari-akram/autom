// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, avoid_print, prefer_const_literals_to_create_immutables

import 'package:autom/custom_color_code.dart';
import 'package:flutter/material.dart';
import 'adaptive_text.dart';
import 'server_comms.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController userName = TextEditingController();
  SnackBar checkEmailSB = SnackBar(
    content: Text(
      'Unique ID sent to your registered email',
    ),
  );
  SnackBar emailNotValidSB = SnackBar(
    content: Text(
      'Username not found',
    ),
  );
  bool tap = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
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
                          'FORGOT',
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
                SizedBox(height: 70),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 10),
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
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    'A Unique ID will be sent to your registered mail',
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
                      if (userName.text != "") {
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
                        bool result = await forgetPassword(userName.text);
                        if (result) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(checkEmailSB);
                          Navigator.pushNamed(context, '/set-password', arguments: {
                            'username': userName.text,
                          });
                        } else {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(emailNotValidSB);
                        }
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          'SUBMIT',
                          style: TextStyle(
                            fontSize: AdaptiveTextSize().getAdaptiveTextSize(context, 20),
                            color: primaryColor,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
