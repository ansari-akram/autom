// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:io';

import 'package:autom/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../custom_formats.dart';
import '../custom_color_code.dart';
import '../adaptive_text.dart';

class OfflineAddDevice extends StatefulWidget {
  const OfflineAddDevice({Key? key}) : super(key: key);

  @override
  State<OfflineAddDevice> createState() => _OfflineAddDeviceState();
}

class _OfflineAddDeviceState extends State<OfflineAddDevice> {
  TextEditingController deviceIp = TextEditingController();
  TextEditingController deviceSR = TextEditingController();
  String dropdownValue = '';

  SnackBar notCreated = SnackBar(
    content: Text('Device creation failed.'),
  );
  SnackBar enterValidData = SnackBar(
    content: Text('Enter valid data.'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text('Add Device'),
        titleTextStyle: TextStyle(
          fontSize: AdaptiveTextSize().getAdaptiveTextSize(context, 25),
          color: primaryColor,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  AppBar().preferredSize.height,
              width: double.infinity,
              color: primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 13),
                    child: TextFormField(
                      controller: deviceSR,
                      decoration: InputDecoration(
                        labelText: 'Device Serial Number',
                        labelStyle: TextStyle(
                          color: secondaryColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: secondaryColor,
                          width: 2,
                        )),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: secondaryColor,
                          width: 2,
                        )),
                        hintStyle: TextStyle(
                          color: secondaryColor,
                        ),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(40),
                      ],
                      style: TextStyle(
                        color: secondaryColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 13),
                    child: TextFormField(
                      controller: deviceIp,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Device IP Address',
                        labelStyle: TextStyle(
                          color: secondaryColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: secondaryColor,
                          width: 2,
                        )),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: secondaryColor,
                          width: 2,
                        )),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(15),
                        IpAddressInputFormatter(),
                      ],
                      style: TextStyle(
                        color: secondaryColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 13),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: 'Select Device type',
                        labelStyle: TextStyle(
                          color: secondaryColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: secondaryColor,
                          width: 2,
                        )),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 2,
                          color: secondaryColor,
                        )),
                        iconColor: secondaryColor,
                      ),
                      dropdownColor: primaryColor,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: <String>['8', '4']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                          ),
                        );
                      }).toList(),
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
                      // autofocus: true,
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: Text(
                            'ADD',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: AdaptiveTextSize()
                                  .getAdaptiveTextSize(context, 20),
                              letterSpacing: 2.0,
                            ),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if (deviceSR.text != "" && dropdownValue != "") {
                          int status = await DatabaseHelper.db.insert(
                              'INSERT INTO ${DatabaseHelper.deviceTable}(mcu_name, mcu_type, mcu_ip, is_new) VALUES(?, ?, ?, ?)',
                              [deviceSR.text, dropdownValue == '8' ? '2': '1', deviceIp.text, '1']);
                          if (status > 0) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/offline-home');
                          }
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(notCreated);
                          }
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(enterValidData);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
