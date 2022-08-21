// ignore_for_file: prefer_const_constructors, avoid_print
// import 'package:flutter/cupertino.dart';
import 'package:autom/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'server_comms.dart';
import 'custom_formats.dart';
import 'custom_color_code.dart';
import 'adaptive_text.dart';
import 'database_helper.dart';

class AddIotDevice extends StatefulWidget {
  const AddIotDevice({Key? key}) : super(key: key);

  @override
  State<AddIotDevice> createState() => _AddIotDeviceState();
}

class _AddIotDeviceState extends State<AddIotDevice> {
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
    var data = ModalRoute.of(context)?.settings.arguments as Map;
    var userId = data['user_id'];
    var username = data['username'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text('Add Device'),
        titleTextStyle: TextStyle(
          fontSize: AdaptiveTextSize().getAdaptiveTextSize(context, 25),
          color: primaryColor,
        ),
      ),
      body: SafeArea(
        child: Container(
          color: primaryColor,
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 13),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 13),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 13),
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
                  ],
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
                      await DatabaseHelper.db.insert(
                          'INSERT INTO ${DatabaseHelper.deviceTable}(mcu_name, mcu_type, mcu_ip, is_new) VALUES(?, ?, ?, ?)',
                          [deviceSR.text, dropdownValue == '8' ? '2': '1', deviceIp.text, '0']);

                      bool status = await createIp(
                          userId, deviceSR.text, deviceIp.text, dropdownValue);
                      if (status) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/home', arguments: {
                          'user_id': userId,
                          'username': username,
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(notCreated);
                      }
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(enterValidData);
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
