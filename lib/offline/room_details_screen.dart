// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, avoid_print, avoid_unnecessary_containers

import 'package:autom/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:autom/server_comms.dart';
import '../adaptive_text.dart';
import '../custom_color_code.dart';
import '../room_widget.dart';

class OfflineRoomDetailScreen extends StatefulWidget {
  const OfflineRoomDetailScreen({Key? key}) : super(key: key);

  @override
  State<OfflineRoomDetailScreen> createState() =>
      _OfflineRoomDetailScreenState();
}

class _OfflineRoomDetailScreenState extends State<OfflineRoomDetailScreen> {
  List roomDetailsData = [];
  List btnStateList = [];
  bool firstT = true;
  int roomId = 0;

  Future<void> refreshDevicesInsideRoom(String rid, String userId) async {
    // List rdd = await getRoomDetails(userId, rid);
    // setState(() {
    //   roomDetailsData = rdd;
    // });
  }

  Future<void> updateRoomsOnRefreshIndicator() async {
    // List rdd = await getRoomDetails(userId, roomId.toString());
    // setState(() {
    //   roomDetailsData = rdd;
    // });
  }

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)!.settings.arguments as Map;
    Map roomData = data['room'];
    roomId = roomData['id'];
    if (firstT) {
      roomDetailsData = data['rdd'];
      firstT = false;
    }
    // print("ROOM DATA $roomData");
    // print("ROOM DETAILS DATA $roomDetailsData");

    return Scaffold(
      backgroundColor: Colors.grey[300],
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
          List deviceData =
              await DatabaseHelper.db.getAll(DatabaseHelper.deviceTable);
          List rddw =
              await DatabaseHelper.db.getAll(DatabaseHelper.applianceTable);
          Navigator.pop(context);
          // print('room data $roomData');
          // print('device data $deviceData');
          // print('room details data $roomDetailsData');
          // print('room details data whole $rddw');

          Navigator.pushNamed(context, '/offline-add-appliance', arguments: {
            'room': roomData,
            'mcu': deviceData,
            'roomDetailsData': roomDetailsData,
            'roomDetailsDataWhole': rddw,
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
          height: MediaQuery.of(context).size.height,
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
                      child: Text(
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
                              // print('details $details');
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
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Appliance Name',
                                                style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: AdaptiveTextSize().getAdaptiveTextSize(context, 10),
                                                ),
                                              ),
                                              Text(
                                                details['appliance_name']
                                                    .toString()
                                                    .split('`|`')[0],
                                                style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: AdaptiveTextSize().getAdaptiveTextSize(context, 20),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'Button No.',
                                                style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: AdaptiveTextSize().getAdaptiveTextSize(context, 10),
                                                ),
                                              ),
                                              Text(
                                                details['btn_no']
                                                    .toString(),
                                                style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: AdaptiveTextSize().getAdaptiveTextSize(context, 20),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'Button State',
                                                style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: AdaptiveTextSize().getAdaptiveTextSize(context, 10),
                                                ),
                                              ),
                                              Text(
                                                details['btn_state'],
                                                style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: AdaptiveTextSize().getAdaptiveTextSize(context, 20),
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
                                              int result = await DatabaseHelper
                                                  .db
                                                  .delete(
                                                      'DELETE FROM ${DatabaseHelper.applianceTable} WHERE id = ?',
                                                      [details['id']]);
                                              // print(result);
                                              if (result == 1) {
                                                List rdd = await DatabaseHelper
                                                    .db
                                                    .getAll(DatabaseHelper
                                                        .applianceTable);
                                                List rddActual = [];
                                                for (var _rdd in rdd) {
                                                  if (_rdd['room'].toString() == roomData['id'].toString()) {
                                                    rddActual.add(_rdd);
                                                  }
                                                }
                                                setState(() {
                                                  roomDetailsData = rddActual;
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
                                  Map deviceData = await DatabaseHelper.db
                                      .getByQuery(
                                          'SELECT * FROM ${DatabaseHelper.deviceTable} WHERE id = ?',
                                          [details['mcu']]);
                                  String localIp =
                                      "${deviceData['mcu_ip']}:9892/${details['btn_no'].toString()}/${details['btn_state'] == "OFF" ? "on" : "off"}";

                                  toggleLocalOnOff(localIp);
                                  // print('details $details');

                                  await DatabaseHelper.db.update(
                                      'UPDATE ${DatabaseHelper.applianceTable} SET btn_state = ?, state_changed = ? WHERE id = ?',
                                      [
                                        details['btn_state'] == "OFF"
                                            ? "ON"
                                            : "OFF",
                                        '1',
                                        details['id'].toString()
                                      ]);

                                  List rdd = await DatabaseHelper.db
                                      .getAll(DatabaseHelper.applianceTable);
                                  List rddActual = [];
                                  for (var _rdd in rdd) {
                                    if (_rdd['room'].toString() == roomData['id'].toString()) {
                                      rddActual.add(_rdd);
                                    }
                                  }
                                  setState(() {
                                    roomDetailsData = rddActual;
                                  });
                                },
                                child: OfflineApplianceNew(
                                  '${details['btn_no']}',
                                  details['appliance_name'],
                                  details['btn_state'] == "OFF" ? false : true,
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
