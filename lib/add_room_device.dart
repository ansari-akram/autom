// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:autom/database_helper.dart';
import 'package:autom/room_widget.dart';
import 'package:autom/server_comms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'custom_color_code.dart';
import 'adaptive_text.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AddRoomDevice extends StatefulWidget {
  const AddRoomDevice({Key? key}) : super(key: key);

  @override
  State<AddRoomDevice> createState() => _AddRoomDeviceState();
}

class _AddRoomDeviceState extends State<AddRoomDevice> {
  String mcuDevice = '';
  String mcuDeviceId = '';
  String btnNo = "";

  bool _isBtnDropDownDisabled = true;
  TextEditingController appliance = TextEditingController();
  dynamic _selectedAppliance;

  List applianceList = [
    "AC",
    "AIR PURIFIER",
    "BULB",
    "CEILING FAN",
    "CEILING LIGHT",
    "CFL",
    "CHANDELIER",
    "CHARGER",
    "CHIMNEY",
    "COFFEE MACHINE",
    "COMPUTER",
    "CURTAIN",
    "DISH WASHER",
    "DOOR BELL",
    "EXHAUST FAN",
    "FILTER",
    "FRIDGE",
    "GEYSER",
    "HANGING LAMP",
    "HEATER",
    "INDUCTION",
    "IRON",
    "MIXER",
    "OVEN",
    "PRINTER",
    "PUMP",
    "RADIO",
    "ROUTER",
    "SPEAKERS",
    "SWITCH SOCKET",
    "TABLE FAN",
    "TABLE LAMP",
    "TELEVISION",
    "TOASTER",
    "TUBE LIGHT",
    "WASHING MACHINE",
    "WATER DISPENSER"
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
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(applianceList);
    _selectedAppliance = _dropdownMenuItems[0].value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)!.settings.arguments as Map;
    Map roomData = data['room'];
    List deviceData = data['mcu'];
    List roomDetailsData = data['roomDetailsData'];
    List roomDetailsDataWhole = data['roomDetailsDataWhole'];
    var userId = data['user_id'];
    // print(roomData);
    // print(deviceData);
    // print(roomDetailsData);
    // print(roomDetailsDataWhole);

    List<String> deviceNames = [];

    for (var element in deviceData) {
      deviceNames.add(element['mcu_name']);
    }

    // for (var element in roomDetailsData) {
    //   print('btn ${element['btn_no']}}');
    //   if (element['btn_no'].toString())
    //   // btnNos.add(element['mcu_name']);
    // }

    // print(deviceNames);

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
                  30,
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
                        for (var element in deviceData) {
                          if (element['mcu_name'] == newValue) {
                            mcuDeviceId = element['id'].toString();
                          }
                        }

                        for (var element in deviceData) {
                          if (element['id'].toString() == mcuDeviceId &&
                              element['mcu_type'].toString() == device8) {
                            btnNos = [btn8List, element['id']];
                            break;
                          } else if (element['id'].toString() == mcuDeviceId &&
                              element['mcu_type'].toString() == device4) {
                            btnNos = [btn4List, element['id']];
                            break;
                          }
                        }

                        for (var roomDetails in roomDetailsDataWhole) {
                          if (btnNos[1] == roomDetails['mcu']) {
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
                  // Expanded(
                  //   child: Padding(
                  //     padding: EdgeInsets.all(20),
                  //     child: GridView.builder(
                  //       itemCount: applianceList.length,
                  //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //         crossAxisCount: 4,
                  //       ),
                  //       itemBuilder: (context, index) {
                  //         var appliance = applianceList[index];
                  //         return GestureDetector(
                  //           onTap: () {
                  //             // if (btnStates[index] == true) {
                  //             //   btnStates = [
                  //             //     false,
                  //             //     false,
                  //             //     false,
                  //             //     false,
                  //             //     false,
                  //             //     false,
                  //             //     false,
                  //             //     false,
                  //             //     false,
                  //             //     false,
                  //             //     false,
                  //             //     false,
                  //             //     false,
                  //             //     false
                  //             //   ];
                  //             // } else {
                  //             //   btnStates = [
                  //             //     false,
                  //             //     false,
                  //             //     false,
                  //             //     false,
                  //             //     false,
                  //             //     false,
                  //             //     false,
                  //             //     false,
                  //             //     false,
                  //             //     false,
                  //             //     false,
                  //             //     false,
                  //             //     false,
                  //             //     false
                  //             //   ];
                  //             //   btnStates[index] = btnStates[index] ? false : true;
                  //             // }
                  //             // setState(() {});
                  //           },
                  //           child: ApplianceDisplay(appliance, true),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
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
                          await DatabaseHelper.db.insert(
                              'INSERT INTO ${DatabaseHelper.applianceTable}(room, mcu, btn_no, btn_state, appliance_name) VALUES(?, ?, ?, ?, ?)',
                              [
                                await DatabaseHelper.db
                                    .getIdByRoomName(roomData['room_name']),
                                await DatabaseHelper.db
                                    .getIdByDeviceName(mcuDevice),
                                btnNo,
                                "OFF",
                                applianceName +
                                    "`|`" +
                                    applianceList[_currentAppliance]
                                        .toString()
                                        .toLowerCase()
                                        .replaceAll(' ', '_')
                              ]);

                          status = await createRoomDevice(
                              userId,
                              roomData['id'].toString(),
                              applianceName +
                                  "`|`" +
                                  applianceList[_currentAppliance]
                                      .toString()
                                      .toLowerCase()
                                      .replaceAll(' ', '_'),
                              btnNo,
                              mcuDeviceId);
                          if (status) {
                            List rdd = await getRoomDetails(
                                userId, roomData['id'].toString());
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/room', arguments: {
                              'room': roomData,
                              'rdd': rdd,
                              'user_id': userId,
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
                                    .getAdaptiveTextSize(context, 20)),
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
