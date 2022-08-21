// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:autom/server_comms.dart';
import 'package:flutter/material.dart';
import '../room_widget.dart';
import '../database_helper.dart';
import '../custom_color_code.dart';
import 'package:flutter/services.dart';
import 'package:autom/adaptive_text.dart';
import 'package:carousel_slider/carousel_slider.dart';

class OfflineAddApplianceScreen extends StatefulWidget {
  const OfflineAddApplianceScreen({Key? key}) : super(key: key);

  @override
  State<OfflineAddApplianceScreen> createState() =>
      _OfflineAddApplianceScreenState();
}

class _OfflineAddApplianceScreenState extends State<OfflineAddApplianceScreen> {
  String mcuDevice = '';
  String mcuDeviceId = '';
  String btnNo = "";

  bool _isBtnDropDownDisabled = true;
  TextEditingController appliance = TextEditingController();
  dynamic _selectedAppliance;
  List applianceList = [
    "AC",
    "BULB",
    "CFL",
    "CEILING FAN",
    "EXHAUST FAN",
    "FRIDGE",
    "GEYSER",
    "HANGING LAMP",
    "CHANDELIER",
    "OVEN",
    "TABLE FAN",
    "TABLE LAMP",
    "TELEVISION",
    "WASHING MACHINE"
  ];

  int _currentAppliance = 0;

  List<DropdownMenuItem> buildDropdownMenuItems(List appliances) {
    List<DropdownMenuItem> items = [];
    for (dynamic appliance in appliances) {
      if (appliance.toString().toLowerCase().split(' ').length > 1) {
        // print('SPACE IN THE NAME');
      } else {
        items.add(
          DropdownMenuItem(
            value: appliance,
            child: Container(
              // width: ,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Image.asset(
                    "images/appliances/${appliance.toString().toLowerCase()}/off_100.png",
                    // width: 10,
                    // height: 10,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    appliance,
                    style: TextStyle(
                      color: secondaryColor,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
    }
    return items;
  }

  onChangeDropdownItem(selectedAppliance) {
    setState(() {
      _selectedAppliance = selectedAppliance;
    });
  }

  final SnackBar _enterDeviceName = SnackBar(
    content: Text('Please enter Device name.'),
  );
  final SnackBar _selectDevice = SnackBar(
    content: Text('Please select a Device.'),
  );
  final SnackBar _selectButton = SnackBar(
    content: Text('Please select a Button.'),
  );
  final SnackBar _selectAppliance = SnackBar(
    content: Text('Please select an Appliance.'),
  );

  List btnNos = [
    [''],
    0
  ];

  List<String> btn8List = ['1', '2', '3', '4', '5', '6', '7', '8'];
  List<String> btn4List = ['1', '2', '3', '4'];
  late List<DropdownMenuItem> _dropdownMenuItems;

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)!.settings.arguments as Map;
    Map roomData = data['room'];
    List deviceData = data['mcu'];
    List roomDetailsData = data['roomDetailsData'];
    List roomDetailsDataWhole = data['roomDetailsDataWhole'];
    // print("ROOM DATA $roomData");
    // print("DEVICE DATA $deviceData");
    // print("ROOM DETAILS DATA $roomDetailsData");
    // print("RDDW $roomDetailsDataWhole");

    List<String> deviceNames = [];

    for (var element in deviceData) {
      deviceNames.add(element['mcu_name']);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Room Appliance',
          style: TextStyle(color: primaryColor),
        ),
        backgroundColor: secondaryColor,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              color: primaryColor,
              width: double.infinity,
              height: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: appliance,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 2,
                          color: secondaryColor,
                        )),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 2,
                          color: secondaryColor,
                        )),
                        labelStyle: TextStyle(
                          color: secondaryColor,
                        ),
                        labelText: 'Device name',
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
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: 'Select device',
                        labelStyle: TextStyle(
                          color: secondaryColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 2,
                          color: secondaryColor,
                        )),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 2,
                          color: secondaryColor,
                        )),
                      ),
                      dropdownColor: primaryColor,
                      onChanged: (String? newValue) {
                        // print('deviceData $deviceData $newValue');
                        for (var element in deviceData) {
                          if (element['mcu_name'] == newValue) {
                            mcuDeviceId = element['id'].toString();
                          }
                        }
                        print('mcuDeviceId $mcuDeviceId');
                        print('deviceData $deviceData');

                        for (var element in deviceData) {
                          var _temp = element['mcu_type'].toString();
                          if (element['id'].toString() == mcuDeviceId &&
                              _temp == device8) {
                            btnNos = [btn8List, element['id']];
                            break;
                          } else if (element['id'].toString() == mcuDeviceId &&
                              _temp == device4) {
                            btnNos = [btn4List, element['id']];
                            break;
                          }
                        }
                        print('btnNos $btnNos');
                        print('roomDetailsDataWhole $roomDetailsDataWhole');

                        for (var roomDetails in roomDetailsDataWhole) {
                          // print(btnNos[1].toString() == roomDetails['mcu_type']);
                          if (btnNos[1].toString() == roomDetails['mcu']) {
                            btnNos[0].remove(roomDetails['btn_no'].toString());
                          }
                        }

                        setState(() {
                          mcuDevice = newValue!;
                          _isBtnDropDownDisabled = false;
                        });
                      },
                      items: deviceNames
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
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: DropdownButtonFormField(
                      disabledHint: Text(
                        'FIRST SELECT DEVICE',
                        style: TextStyle(
                          color: secondaryColor,
                        ),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Select Button Number',
                        labelStyle: TextStyle(
                          color: secondaryColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 2,
                          color: secondaryColor,
                        )),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 2,
                          color: secondaryColor,
                        )),
                      ),
                      dropdownColor: primaryColor,
                      onChanged: _isBtnDropDownDisabled
                          ? null
                          : (String? newValue) {
                              setState(() {
                                btnNo = newValue!;
                              });
                            },
                      items: btnNos[0]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem(
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
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'SELECT APPLIANCE TYPE',
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize:
                            AdaptiveTextSize().getAdaptiveTextSize(context, 20),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: CarouselSlider(
                      options: CarouselOptions(
                          height: AdaptiveTextSize()
                              .getAdaptiveTextSize(context, 200),
                          enableInfiniteScroll: true,
                          enlargeCenterPage: true,
                          onPageChanged: (index, reason) {
                            _currentAppliance = index;
                            setState(() {});
                          }),
                      items: applianceList
                          .map((e) => ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  color: secondaryColor,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 50, vertical: 50),
                                          child: Image.asset(
                                            'assets/images/appliance/' +
                                                e
                                                    .toLowerCase()
                                                    .replaceAll(' ', '_') +
                                                '/w300.png',
                                          ),
                                        ),
                                      ),
                                      Container(
                                        // color: primaryColor,
                                        // margin: EdgeInsets.only(top: 230),
                                        alignment: Alignment.bottomCenter,
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          e,
                                          style: TextStyle(
                                              fontSize: AdaptiveTextSize()
                                                  .getAdaptiveTextSize(
                                                      context, 20),
                                              color: primaryColor,
                                              fontWeight: FontWeight.bold
                                              // color:
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
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
                        if (appliance.text == "") {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(_enterDeviceName);
                        } else if (mcuDevice == "") {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(_selectDevice);
                        } else if (btnNo == "") {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(_selectButton);
                        } else {
                          bool status = false;
                          String applianceName = appliance.text;
                          // for (var i = 0; i < btnStates.length; i++) {
                          //   if (btnStates[i] == true) {
                          int result = await DatabaseHelper.db.insert(
                              'INSERT INTO ${DatabaseHelper.applianceTable}(room, mcu, btn_no, btn_state, appliance_name, is_new, state_changed) VALUES(?, ?, ?, ?, ?, ?, ?)',
                              [
                                roomData['id'].toString(),
                                mcuDeviceId,
                                btnNo,
                                "OFF",
                                applianceName +
                                    "`|`" +
                                    applianceList[_currentAppliance]
                                        .toString()
                                        .toLowerCase()
                                        .replaceAll(' ', '_'),
                                '1',
                                '1'
                              ]);
                          // print(result);
                          if (result > 0) {
                            List rdd = await DatabaseHelper.db
                                .getAll(DatabaseHelper.applianceTable);
                            // print('roomData $roomData');
                            List rddActual = [];
                            for (var _rdd in rdd) {
                              if (_rdd['room'].toString() ==
                                  roomData['id'].toString()) {
                                rddActual.add(_rdd);
                              }
                            }
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pushNamed(
                                context, '/offline-room-details',
                                arguments: {
                                  'room': roomData,
                                  'rdd': rddActual,
                                });
                          }
                          // }
                          // }
                          if (!status) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(_selectAppliance);
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: Text(
                            'ADD APPLIANCE',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: AdaptiveTextSize()
                                  .getAdaptiveTextSize(context, 20),
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
      ),
    );
  }
}
