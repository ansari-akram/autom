// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, avoid_unnecessary_containers, avoid_print

import 'package:flutter/material.dart';
import '../room_widget.dart';
import 'package:uuid/uuid.dart';
import '../custom_color_code.dart';
import '../adaptive_text.dart';
import '../mqtt_comms.dart';
import '../database_helper.dart';

class OfflineRoomScreen extends StatefulWidget {
  const OfflineRoomScreen({Key? key}) : super(key: key);

  @override
  State<OfflineRoomScreen> createState() => _OfflineRoomScreenState();
}

class _OfflineRoomScreenState extends State<OfflineRoomScreen> {
  List roomData = [];

  Future<void> updateRoomsOnRefreshIndicator() async {
    List rd = await DatabaseHelper.db.getAll(DatabaseHelper.roomTable);
    setState(() {
      roomData = rd;
    });
  }

  @override
  void initState() {
    DatabaseHelper.db.getAll(DatabaseHelper.roomTable).then((value) {
      setState(() {
        roomData = value;
      });
    });
    super.initState();
  }

  // Future<void> refreshDevicesInsideRoom(String rid, String userId) async {
  //   List rdd = await getRoomDetails(userId, rid);
  //   setState(() {
  //     roomDetailsData = rdd;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // var data = ModalRoute.of(context)!.settings.arguments as Map;
    // Map roomData = data['room'];
    // roomId = roomData['id'];
    // if (firstT) {
    //   roomDetailsData = data['rdd'];
    //   firstT = false;
    // }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: primaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        'Offline Mode',
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: AdaptiveTextSize()
                              .getAdaptiveTextSize(context, 25),
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        'Welcome to Home',
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: AdaptiveTextSize()
                              .getAdaptiveTextSize(context, 14),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'NOTE: In Offline Mode, your data is not saved on our server.',
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: AdaptiveTextSize()
                              .getAdaptiveTextSize(context, 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            roomData.isNotEmpty
                ? Flexible(
                    child: Container(
                      // padding: EdgeInsets.all(25),
                      child: RefreshIndicator(
                        backgroundColor: secondaryColor,
                        color: primaryColor,
                        triggerMode: RefreshIndicatorTriggerMode.onEdge,
                        onRefresh: updateRoomsOnRefreshIndicator,
                        child: GridView.builder(
                          itemCount: roomData.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (context, index) {
                            var room = roomData[index];
                            // print(room);
                            // return Room(rooms.keys.elementAt(index), room!);
                            return GestureDetector(
                              onLongPress: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: secondaryColor,
                                        title: Text(
                                          'Remove "${room['room_name'].toString().split("`|`")[0]}"?',
                                          style: TextStyle(
                                            color: primaryColor,
                                            // fontSize: AdaptiveTextSize().getAdaptiveTextSize(context, 12),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text(
                                              'NO',
                                              style: TextStyle(
                                                color: primaryColor,
                                                  fontSize: AdaptiveTextSize().getAdaptiveTextSize(context, 12),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              'YES',
                                              style: TextStyle(
                                                color: primaryColor,
                                              ),
                                            ),
                                            onPressed: () async {
                                              int status = await DatabaseHelper.db.delete('DELETE FROM ${DatabaseHelper.roomTable} WHERE id = ?', [room['id']]);
                                              await DatabaseHelper.db.delete('DELETE FROM ${DatabaseHelper.applianceTable} WHERE room = ?', [room['id']]);

                                              if (status == 1) {
                                                List rd = await DatabaseHelper.db.getAll(DatabaseHelper.roomTable);
                                                setState(() {
                                                  roomData = rd;
                                                });
                                                Navigator.pop(context);
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              onTap: () async {
                                List rdd = await DatabaseHelper.db.getAll(DatabaseHelper.applianceTable);
                                List rddActual = [];
                                for (var _rdd in rdd) {
                                  if (_rdd['room'].toString() == room['id'].toString()) {
                                    rddActual.add(_rdd);
                                  }
                                }
                                Navigator.pushNamed(
                                    context, '/offline-room-details',
                                    arguments: {
                                      'room': room,
                                      'rdd': rddActual,
                                    });
                              },
                              child: Room2(
                                '${room['room_name']}',
                                '${room['id']}',
                                '${room['user']}',
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
    );
  }
}
