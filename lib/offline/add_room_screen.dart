// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:autom/database_helper.dart';
import 'package:flutter/material.dart';
import '../custom_color_code.dart';
import '../adaptive_text.dart';
import '../room_widget.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';

class OfflineAddRoomScreen extends StatefulWidget {
  const OfflineAddRoomScreen({Key? key}) : super(key: key);

  @override
  State<OfflineAddRoomScreen> createState() => _OfflineAddRoomScreenState();
}

class _OfflineAddRoomScreenState extends State<OfflineAddRoomScreen> {
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
                            AdaptiveTextSize().getAdaptiveTextSize(context, 16),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  // TODO: Room image slider working [done]
                  Expanded(
                    child: Padding(
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
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        String _roomName = roomName.text;
                        int status = await DatabaseHelper.db.insert(
                            'INSERT INTO ${DatabaseHelper.roomTable}(room_name, is_new) VALUES (?, ?)',
                            [
                              _roomName +
                                  "`|`" +
                                  roomList[_currentRoom]
                                      .toString()
                                      .toLowerCase()
                                      .replaceAll(' ', '_'),
                              '1'
                            ]);
                        // print('Room Creation status: $status');
                        if (status > 0) {
                          roomName.clear();
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/offline-home');
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
                                    .getAdaptiveTextSize(context, 16)),
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
