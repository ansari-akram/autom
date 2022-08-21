// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'custom_color_code.dart';
import 'server_comms.dart';
import 'adaptive_text.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cPassword = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  bool showPassword = true;

  SnackBar enterValidDetailsSB = SnackBar(content: Text('Enter Valid details'));
  SnackBar passwordNotMatchSB =
      SnackBar(content: Text('Passwords don\'t match'));
  SnackBar enterValidEmailSB =
      SnackBar(content: Text('Enter a valid Email address'));
  SnackBar enterValidPhoneSB =
      SnackBar(content: Text('Enter a valid Phone Number'));
  SnackBar passwordLengthSB =
      SnackBar(content: Text('Passwords length should be greater than 8'));
  SnackBar userCreatedSB = SnackBar(content: Text('User created please login'));
  SnackBar userNotCreatedSB =
      SnackBar(content: Text('Username already exists'));

  bool validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            // color: primaryColor,
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
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
                    Text(
                      'SIGN UP',
                      style: TextStyle(
                        fontSize: AdaptiveTextSize()
                            .getAdaptiveTextSize(context, 30),
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                        letterSpacing: 2,
                        color: secondaryColor,
                      ),
                    ),
                    SizedBox(
                        width: AdaptiveTextSize()
                            .getAdaptiveTextSize(context, 30)),
                  ],
                ),
                Spacer(),
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
                    // autofocus: true,
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
                    // autofocus: true,
                    style: TextStyle(
                      color: secondaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 15),
                  child: TextFormField(
                    controller: cPassword,
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
                    // autofocus: true,
                    style: TextStyle(
                      color: secondaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 15),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: email,
                    autovalidateMode: AutovalidateMode.disabled,
                    decoration: InputDecoration(
                      labelText: 'Email',
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
                    // autofocus: true,
                    style: TextStyle(
                      color: secondaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 15),
                  child: TextFormField(
                    controller: phone,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
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
                    // autofocus: true,
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
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => secondaryColor),
                    ),
                    onPressed: () async {
                      if (userName.text == "" ||
                          password.text == "" ||
                          cPassword.text == "" ||
                          email.text == "" ||
                          phone.text == "") {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(enterValidDetailsSB);
                      } else if (password.text.length < 8 ||
                          cPassword.text.length < 8) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(passwordLengthSB);
                      } else if (password.text != cPassword.text) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(passwordNotMatchSB);
                      } else if (!validateEmail(email.text)) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(enterValidEmailSB);
                      } else if (phone.text.length < 10) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(enterValidPhoneSB);
                      } else {
                        bool status = await register(userName.text,
                            password.text, email.text, phone.text);
                        if (status) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(userCreatedSB);
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(userNotCreatedSB);
                        }
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          'SIGN UP',
                          style: TextStyle(
                            fontSize: AdaptiveTextSize()
                                .getAdaptiveTextSize(context, 20),
                            color: primaryColor,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
