// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, avoid_print

import 'package:autom/database_helper.dart';
import 'package:flutter/material.dart';
import 'room_widget.dart';
import 'server_comms.dart';
import 'custom_color_code.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'adaptive_text.dart';

class ShowRoom extends StatefulWidget {
  final String userId;
  final String username;

  const ShowRoom({Key? key, required this.userId, required this.username})
      : super(key: key);

  @override
  State<ShowRoom> createState() => _ShowRoomState();
}

class _ShowRoomState extends State<ShowRoom> {
  List roomData = [];
  String username = '';

  Future<void> updateRoomsOnRefreshIndicator() async {
    List rd = await getRooms(widget.userId);
    setState(() {
      roomData = rd;
    });
  }

  @override
  void initState() {
    getRooms(widget.userId).then((value) {
      setState(() {
        roomData = value;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                        'Hi ${widget.username}',
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: AdaptiveTextSize()
                              .getAdaptiveTextSize(context, 30),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Welcome to Home',
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: AdaptiveTextSize()
                              .getAdaptiveTextSize(context, 15),
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: secondaryColor,
                            title: Text(
                              'Logout?',
                              style: TextStyle(
                                color: primaryColor,
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: Text(
                                  'NO',
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
                                  'YES',
                                  style: TextStyle(
                                    color: primaryColor,
                                  ),
                                ),
                                onPressed: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString('username', "");
                                  await prefs.setString('password', "");
                                  Navigator.pop(context);
                                  bool res = await checkInternetConnection();
                                  // print(res);
                                  Navigator.pushReplacementNamed(context, '/login', arguments: {
                                    'connection': res,
                                  });
                                },
                              ),
                            ],
                          );
                        });
                  },
                  icon: Icon(
                    Icons.logout,
                    size: AdaptiveTextSize().getAdaptiveTextSize(context, 35),
                    color: secondaryColor,
                  ),
                ),
              ],
            ),
            roomData.isNotEmpty
                ? Flexible(
                    child: Container(
                      // padding: EdgeInsets.all(10),
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
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text(
                                              'NO',
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
                                              'YES',
                                              style: TextStyle(
                                                color: primaryColor,
                                              ),
                                            ),
                                            onPressed: () async {
                                              Map _roomDetails =
                                                  await DatabaseHelper.db
                                                      .getByQuery(
                                                          'SELECT * FROM ${DatabaseHelper.roomTable} WHERE room_name = ?',
                                                          [room['room_name']]);

                                              await DatabaseHelper.db.delete('DELETE FROM ${DatabaseHelper.roomTable} where id = ?', [_roomDetails['id']]);

                                              await DatabaseHelper.db.delete('DELETE FROM ${DatabaseHelper.applianceTable} WHERE room = ?',
                                                  [_roomDetails['id']]);

                                              bool status = await deleteRoom(
                                                  room['id'].toString());
                                              if (status) {
                                                List rd = await getRooms(
                                                    widget.userId);
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
                                List rdd = await getRoomDetails(
                                    widget.userId, room['id'].toString());
                                // print(rdd);
                                // print(room);
                                Navigator.pushNamed(context, '/room',
                                    arguments: {
                                      'room': room,
                                      'rdd': rdd,
                                      'user_id': widget.userId,
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
