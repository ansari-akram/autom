// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, use_key_in_widget_constructors, unnecessary_string_interpolations, avoid_unnecessary_containers, avoid_print

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'server_comms.dart';
import 'custom_color_code.dart';
import 'adaptive_text.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Room extends StatelessWidget {
  final String roomName;
  final int devices;

  Room(this.roomName, this.devices);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            roomName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            '$devices devices',
            style: TextStyle(
                // fontSize: 20,
                ),
          ),
        ],
      ),
    );
  }
}

class Device extends StatelessWidget {
  final String deviceIp;
  final int devices;

  Device(this.deviceIp, this.devices);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            deviceIp,
            style: TextStyle(
              fontSize: AdaptiveTextSize().getAdaptiveTextSize(context, 16),
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          Text(
            devices == 2 ? "8" : "4",
            style: TextStyle(
              fontSize: AdaptiveTextSize().getAdaptiveTextSize(context, 16),
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class Room2 extends StatelessWidget {
  final String roomName;
  final String roomId;
  final String userId;

  Room2(this.roomName, this.roomId, this.userId);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(10),
      child: Column(

        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Center(
            child: Image.asset(
              'assets/images/room/' +
                  roomName.toLowerCase().split("`|`")[1].replaceAll(' ', '_') +
                  '/w300.png',
              height: 95,
              width: 95,
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              roomName.split("`|`")[0],
              style: TextStyle(
                fontSize: AdaptiveTextSize().getAdaptiveTextSize(context, 16),
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class OfflineApplianceNew extends StatelessWidget {
  final String btnNo;
  final String applianceName;
  final bool btnState;

  OfflineApplianceNew(this.btnNo, this.applianceName, this.btnState);

  // const Appliance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: btnState ? secondaryColor : primaryColor,
        // color: Colors.greenAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          btnState
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    image: AssetImage(
                        'assets/images/appliance/${applianceName.split('`|`')[1]}/w300.png'),
                    width: AdaptiveTextSize().getAdaptiveTextSize(context, 40),
                    height: AdaptiveTextSize().getAdaptiveTextSize(context, 40),
                  ))
              //   child:
              //       Image.asset('images/appliance/ac/off_100.png'),
              // )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    image: AssetImage(
                        'assets/images/appliance/${applianceName.split('`|`')[1]}/300.png'),
                    height: AdaptiveTextSize().getAdaptiveTextSize(context, 40),
                    width: AdaptiveTextSize().getAdaptiveTextSize(context, 40),
                  )),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  applianceName.split('`|`')[0],
                  style: TextStyle(
                    color: btnState ? primaryColor : Colors.black,
                    fontSize:
                        AdaptiveTextSize().getAdaptiveTextSize(context, 16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ApplianceNew extends StatelessWidget {
  final String btnNo;
  final String applianceName;
  final String userId;
  final bool btnState;

  ApplianceNew(this.btnNo, this.applianceName, this.userId, this.btnState);

  // const Appliance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: btnState ? secondaryColor : primaryColor,
        // color: Colors.greenAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          btnState
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    image: AssetImage(
                        'assets/images/appliance/${applianceName.split('`|`')[1]}/w300.png'),
                    width: AdaptiveTextSize().getAdaptiveTextSize(context, 40),
                    height: AdaptiveTextSize().getAdaptiveTextSize(context, 40),
                  ))
              //   child:
              //       Image.asset('images/appliance/ac/off_100.png'),
              // )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    image: AssetImage(
                        'assets/images/appliance/${applianceName.split('`|`')[1]}/300.png'),
                    height: AdaptiveTextSize().getAdaptiveTextSize(context, 40),
                    width: AdaptiveTextSize().getAdaptiveTextSize(context, 40),
                  )),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  applianceName.split('`|`')[0],
                  style: TextStyle(
                    color: btnState ? primaryColor : Colors.black,
                    fontSize:
                        AdaptiveTextSize().getAdaptiveTextSize(context, 16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Appliance extends StatelessWidget {
  final String btnNo;
  final String applianceName;
  final String userId;
  final bool btnState;

  Appliance(this.btnNo, this.applianceName, this.userId, this.btnState);

  // const Appliance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: btnState ? secondaryColor : primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          btnState
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    image: AssetImage(
                        'assets/images/appliance/${applianceName.split('`|`')[1]}/on_100.png'),
                    width: 50,
                    height: 50,
                  ))
              //   child:
              //       Image.asset('images/appliance/ac/off_100.png'),
              // )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    image: AssetImage(
                        'assets/images/appliance/${applianceName.split('`|`')[1]}/off_100.png'),
                    height: 50,
                    width: 50,
                  )),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  applianceName.split('`|`')[0],
                  style: TextStyle(
                    color: btnState ? primaryColor : Colors.black,
                    fontSize:
                        AdaptiveTextSize().getAdaptiveTextSize(context, 16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RoomDisplay extends StatelessWidget {
  final String roomName;
  final bool selected;

  RoomDisplay(this.roomName, this.selected);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          selected
              ? Image.asset(
                  'assets/images/room/' +
                      roomName.toLowerCase().replaceAll(' ', '_') +
                      '/w300.png',
                  height: 50,
                  width: 50,
                )
              : Image.asset(
                  'assets/images/room/' +
                      roomName.toLowerCase().replaceAll(' ', '_') +
                      '/300.png',
                  height: 50,
                  width: 50,
                ),
          SizedBox(height: 10),
          Text(
            '$roomName',
            style: TextStyle(
              fontSize: AdaptiveTextSize().getAdaptiveTextSize(context, 13),
              color: selected ? primaryColor : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class ApplianceDisplay extends StatelessWidget {
  final String applianceName;
  final bool selected;

  const ApplianceDisplay(this.applianceName, this.selected);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          selected
              ? Image.asset(
                  'assets/images/appliance/' +
                      applianceName.toLowerCase().replaceAll(' ', '_') +
                      '/w300.png',
                  height: 50,
                  width: 50,
                )
              : Image.asset(
                  'assets/images/appliance/' +
                      applianceName.toLowerCase().replaceAll(' ', '_') +
                      '/300.png',
                  height: 50,
                  width: 50,
                ),
          // SizedBox(height: 10),
          // Text(
          //   '$applianceName',
          //   style: TextStyle(
          //     fontSize: 16,
          //     color: selected ? primaryColor : Colors.black,
          //   ),
          // ),
        ],
      ),
    );
  }
}

Future<bool> checkInternetConnection() async {
  bool isInternetWorking;
  bool result = await InternetConnectionChecker().hasConnection;
  if (result == true) {
    isInternetWorking = true;
  } else {
    isInternetWorking = false;
  }
  return isInternetWorking;
}

class RoomImageSlider extends StatelessWidget {
  final List images;

  RoomImageSlider(this.images);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: AdaptiveTextSize().getAdaptiveTextSize(context, 350),
        enableInfiniteScroll: true,
        enlargeCenterPage: true,
        // disableCenter: true,
        // initialPage: 0,
      ),
      items: images
          .map((e) => ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: secondaryColor,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(50),
                        child: Image.asset(
                          'assets/images/room/' +
                              e.toLowerCase().replaceAll(' ', '_') +
                              '/300.png',
                          // width: 100,
                        ),
                      ),
                      Text(
                        e,
                        style: TextStyle(
                          fontSize: AdaptiveTextSize()
                              .getAdaptiveTextSize(context, 30),
                          // color:
                        ),
                      ),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}
