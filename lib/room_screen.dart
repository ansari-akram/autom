// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:autom/database_helper.dart';

import 'server_comms.dart';
import 'package:flutter/material.dart';
import 'room_widget.dart';
import 'package:uuid/uuid.dart';
import 'mqtt_comms.dart';
import 'custom_color_code.dart';
import 'adaptive_text.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({Key? key}) : super(key: key);

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  List roomDetailsData = [];
  List btnStateList = [];
  bool firstT = true;
  int roomId = 0;
  String userId = "";

  // Future<void> updateRoomsOnRefreshIndicator(String rid, String userId) async {
  //   List rdd = await getRoomDetails(userId, rid);
  //   setState(() {
  //     roomDetailsData = rdd;
  //   });
  // }

  Future<void> updateRoomsOnRefreshIndicator() async {
    List rdd = await getRoomDetails(userId, roomId.toString());
    setState(() {
      roomDetailsData = rdd;
    });
  }

  @override
  void initState() {
    // getRoomDetails(widget.userId, widget.roomName).then((value) {
    //   setState(() {
    //     roomDetailsData = value;
    //   });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)!.settings.arguments as Map;
    Map roomData = data['room'];
    userId = data['user_id'];
    roomId = roomData['id'];
    if (firstT) {
      roomDetailsData = data['rdd'];
      firstT = false;
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      // appBar: AppBar(
      //   title: Text(roomData['room_name']),
      //   backgroundColor: Color(0xffF76E11),
      // ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
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
          List deviceData = await getDevices(userId);
          List rddw = await getRoomDetailsWhole(userId);
          Navigator.pop(context);
          Navigator.pushNamed(context, '/add-room-device', arguments: {
            'room': roomData,
            'mcu': deviceData,
            'roomDetailsData': roomDetailsData,
            'roomDetailsDataWhole': rddw,
            'user_id': userId,
          });
        },
        label: Text(
          'ADD APPLIANCE',
          style: TextStyle(color: primaryColor),
        ),
        backgroundColor: secondaryColor,
        icon: Icon(
          Icons.add_sharp,
          color: primaryColor,
        ),
        isExtended: true,
        extendedTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        child: Container(
          // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          color: Colors.grey[300],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 175,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Icon(
                          Icons.arrow_back,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/room/' +
                                roomData['room_name']
                                    .toLowerCase()
                                    .split("`|`")[1]
                                    .replaceAll(' ', '_') +
                                '/w300.png',
                            height: 75,
                            width: 75,
                          ),
                          SizedBox(width: 10),
                          Text(
                            roomData['room_name']
                                .toString()
                                .split('`|`')[0]
                                .toUpperCase(),
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: AdaptiveTextSize()
                                  .getAdaptiveTextSize(context, 25),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              roomDetailsData.isNotEmpty
                  ? Flexible(
                      child: Container(
                        padding: EdgeInsets.all(25),
                        child: RefreshIndicator(
                          backgroundColor: Colors.grey[300],
                          color: primaryColor,
                          triggerMode: RefreshIndicatorTriggerMode.onEdge,
                          onRefresh: updateRoomsOnRefreshIndicator,
                          child: ListView.builder(
                            itemCount: roomDetailsData.length,
                            itemBuilder: (context, index) {
                              var details = roomDetailsData[index];
                              // return Room(rooms.keys.elementAt(index), room!);
                              return GestureDetector(
                                onLongPress: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: secondaryColor,
                                        title: Text(
                                          'Appliance Details',
                                          style: TextStyle(
                                            color: primaryColor,
                                          ),
                                        ),
                                        content: Container(
                                          height: 125,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Appliance Name',
                                                style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: AdaptiveTextSize()
                                                      .getAdaptiveTextSize(
                                                          context, 10),
                                                ),
                                              ),
                                              Text(
                                                details['device_name']
                                                    .toString()
                                                    .split('`|`')[0],
                                                style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: AdaptiveTextSize()
                                                      .getAdaptiveTextSize(
                                                          context, 20),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'Button No.',
                                                style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: AdaptiveTextSize()
                                                      .getAdaptiveTextSize(
                                                          context, 10),
                                                ),
                                              ),
                                              Text(
                                                details['btn_no'].toString(),
                                                style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: AdaptiveTextSize()
                                                      .getAdaptiveTextSize(
                                                          context, 20),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'Button State',
                                                style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: AdaptiveTextSize()
                                                      .getAdaptiveTextSize(
                                                          context, 10),
                                                ),
                                              ),
                                              Text(
                                                details['btn_state']
                                                    ? "ON"
                                                    : "OFF",
                                                style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: AdaptiveTextSize()
                                                      .getAdaptiveTextSize(
                                                          context, 20),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text(
                                              'CLOSE',
                                              style: TextStyle(
                                                color: primaryColor,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              'REMOVE APPLIANCE',
                                              style: TextStyle(
                                                color: primaryColor,
                                              ),
                                            ),
                                            onPressed: () async {
                                              await DatabaseHelper.db.delete(
                                                  'DELETE FROM ${DatabaseHelper.applianceTable} WHERE room = ? AND mcu = ? AND btn_no = ? AND appliance_name = ?',
                                                  [
                                                    details['room'],
                                                    details['mcu'],
                                                    details['btn_no'],
                                                    details['appliance_name']
                                                  ]);

                                              bool status =
                                                  await deleteRoomDevice(
                                                      details['id'].toString());
                                              if (status) {
                                                List rdd = await getRoomDetails(
                                                    userId, roomId.toString());
                                                setState(() {
                                                  roomDetailsData = rdd;
                                                });
                                                Navigator.pop(context);
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                onTap: () async {
                                  List res = await getDetailsOfObject(
                                      userId, details['mcu'].toString(), 'mcu');
                                  var uID = Uuid().v4();
                                  toggleOnOff(
                                      uID,
                                      res[0].toString(),
                                      '${details['btn_no']}_${details['btn_state'] ? "OFF" : "ON"}_${res[0].toString()}',
                                      '${res[1].toString()}:9892/${details['btn_no'].toString()}/${details['btn_state'] == "OFF" ? "on" : "off"}');
                                  // List rdd = await getRoomDetails(
                                  //     userId, roomId.toString());
                                  // setState(() {
                                  //   roomDetailsData = rdd;
                                  // });
                                  details['btn_state'] =
                                      details['btn_state'] ? false : true;
                                  setState(() {});
                                },
                                child: ApplianceNew(
                                  '${details['btn_no']}',
                                  details['device_name'],
                                  '${details['user']}',
                                  details['btn_state'],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  : Flexible(
                      child: Container(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
