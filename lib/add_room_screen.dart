// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, avoid_unnecessary_containers

import 'package:autom/database_helper.dart';
import 'package:autom/room_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'server_comms.dart';
import 'custom_color_code.dart';
import 'adaptive_text.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AddRoom extends StatefulWidget {
  final String userId;
  final String username;

  const AddRoom({Key? key, required this.userId, required this.username})
      : super(key: key);

  @override
  State<AddRoom> createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  TextEditingController roomName = TextEditingController();
  List<String> roomList = [
    'AQUARIUM',
    'BALCONY',
    'BASEMENT',
    'BATH ROOM',
    'BED ROOM',
    'CUBICAL',
    'DINING ROOM',
    'GARAGE',
    'GARDEN',
    'GYM',
    'KITCHEN',
    'LIBRARY',
    'LIVING ROOM',
    'OFFICE',
    'STORE ROOM',
    'STUDY',
    'TOILET',
    'UTILITY',
    'WASH ROOM'
  ];

  int _currentRoom = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text(
          'Add Room',
          style: TextStyle(
            color: primaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height - AppBar().preferredSize.height - 107,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              color: primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: roomName,
                      decoration: InputDecoration(
                        labelText: 'Room Name',
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
                        hintStyle: TextStyle(
                          color: secondaryColor,
                        ),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(40),
                      ],
                      // autofocus: true,
                      style: TextStyle(
                        color: secondaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'SELECT ROOM TYPE',
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize:
                            AdaptiveTextSize().getAdaptiveTextSize(context, 20),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                  // TODO: Room image slider working [done]
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: CarouselSlider(
                      options: CarouselOptions(
                          height: AdaptiveTextSize()
                              .getAdaptiveTextSize(context, 250),
                          enableInfiniteScroll: true,
                          enlargeCenterPage: true,
                          onPageChanged: (index, reason) {
                            _currentRoom = index;
                            setState(() {});
                          }
                          // disableCenter: true,
                          // initialPage: 0,
                          ),
                      items: roomList
                          .map(
                            (e) => ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                color: secondaryColor,
                                child: Stack(
                                  fit: StackFit.expand,
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 50, vertical: 50),
                                        child: Image.asset(
                                          'assets/images/room/' +
                                              e
                                                  .toLowerCase()
                                                  .replaceAll(' ', '_') +
                                              '/w300.png',
                                          // width: 100,
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
                                              .getAdaptiveTextSize(context, 20),
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold
                                          // color:
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Spacer(),
                  // Expanded(
                  //   child: Padding(
                  //     padding: EdgeInsets.all(20),
                  //     child: GridView.builder(
                  //       itemCount: roomList.length,
                  //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //         crossAxisCount: 2,
                  //       ),
                  //       itemBuilder: (context, index) {
                  //         var room = roomList[index];
                  //         return GestureDetector(
                  //           onTap: () {
                  //             if (btnStates[index] == true) {
                  //               btnStates = [
                  //                 false,
                  //                 false,
                  //                 false,
                  //                 false,
                  //                 false,
                  //                 false,
                  //                 false
                  //               ];
                  //             } else {
                  //               btnStates = [
                  //                 false,
                  //                 false,
                  //                 false,
                  //                 false,
                  //                 false,
                  //                 false,
                  //                 false
                  //               ];
                  //               btnStates[index] = btnStates[index] ? false : true;
                  //             }
                  //             setState(() {});
                  //           },
                  //           child: RoomDisplay(room, btnStates[index]),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 10),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        String _roomName = roomName.text;
                        await DatabaseHelper.db.insert(
                            'INSERT INTO ${DatabaseHelper.roomTable}(room_name) VALUES(?)',
                            [
                              _roomName +
                                  "`|`" +
                                  roomList[_currentRoom]
                                      .toString()
                                      .toLowerCase()
                                      .replaceAll(' ', '_')
                            ]);

                        bool status = await createRoom(
                            widget.userId,
                            _roomName +
                                "`|`" +
                                roomList[_currentRoom]
                                    .toString()
                                    .toLowerCase()
                                    .replaceAll(' ', '_'));
                        print('Room Creation status: $status');
                        if (status) {
                          roomName.clear();
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/home', arguments: {
                            'user_id': widget.userId,
                            'username': widget.username,
                          });
                        }
                      },
                      child: Container(
                        width: 250,
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'ADD ROOM',
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: AdaptiveTextSize()
                                    .getAdaptiveTextSize(context, 20)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
