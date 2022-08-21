// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import '../room_widget.dart';
import '../custom_color_code.dart';
import '../adaptive_text.dart';
import '../server_comms.dart';
import '../database_helper.dart';

class OfflineDeviceScreen extends StatefulWidget {
  const OfflineDeviceScreen({Key? key}) : super(key: key);

  @override
  State<OfflineDeviceScreen> createState() => _OfflineDeviceScreenState();
}

class _OfflineDeviceScreenState extends State<OfflineDeviceScreen> {
  List deviceData = [];

  Future<void> refreshDevicesOnRefreshIndicator() async {
    List dd = await DatabaseHelper.db.getAll(DatabaseHelper.deviceTable);
    setState(() {
      deviceData = dd;
    });
  }

  @override
  void initState() {
    DatabaseHelper.db.getAll(DatabaseHelper.deviceTable).then((value) {
      setState(() {
        deviceData = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text(
          'Devices List',
          style: TextStyle(
            color: primaryColor,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/add-offline-device');
        },
        label: Text(
          'Add Device',
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
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          color: primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              deviceData.isNotEmpty
                  ? Flexible(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        child: RefreshIndicator(
                          backgroundColor: secondaryColor,
                          color: primaryColor,
                          triggerMode: RefreshIndicatorTriggerMode.onEdge,
                          onRefresh: refreshDevicesOnRefreshIndicator,
                          child: ListView.builder(
                            // shrinkWrap: true,
                            itemCount: deviceData.length,
                            // gridDelegate:
                            //     SliverGridDelegateWithFixedCrossAxisCount(
                            //   crossAxisCount: 1,
                            // ),
                            itemBuilder: (context, index) {
                              var device = deviceData[index];
                              // print(device);
                              // return Room(rooms.keys.elementAt(index), room!);

                              return GestureDetector(
                                onLongPress: () {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        print('device $device');
                                        return AlertDialog(
                                          backgroundColor: secondaryColor,
                                          title: Text(
                                            'Device Details',
                                            style:
                                                TextStyle(color: primaryColor),
                                          ),
                                          content: SizedBox(
                                            height: 125,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Name',
                                                  style: TextStyle(
                                                    fontSize: AdaptiveTextSize()
                                                        .getAdaptiveTextSize(
                                                        context, 10),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    color: primaryColor,
                                                  ),
                                                ),
                                                Text(
                                                  device['mcu_name'],
                                                  style: TextStyle(
                                                    fontSize: AdaptiveTextSize()
                                                        .getAdaptiveTextSize(
                                                        context, 20),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    color: primaryColor,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  'IP Address',
                                                  style: TextStyle(
                                                    fontSize: AdaptiveTextSize()
                                                        .getAdaptiveTextSize(
                                                        context, 10),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    color: primaryColor,
                                                  ),
                                                ),
                                                Text(
                                                  device['mcu_ip'],
                                                  style: TextStyle(
                                                    fontSize: AdaptiveTextSize()
                                                        .getAdaptiveTextSize(
                                                        context, 20),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    color: primaryColor,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  'Buttons',
                                                  style: TextStyle(
                                                      fontSize: AdaptiveTextSize()
                                                          .getAdaptiveTextSize(
                                                          context, 10),
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      color: primaryColor),
                                                ),
                                                Text(
                                                  device['mcu_type']
                                                      .toString() ==
                                                      device8
                                                      ? '8'
                                                      : '4',
                                                  style: TextStyle(
                                                    fontSize: AdaptiveTextSize()
                                                        .getAdaptiveTextSize(
                                                        context, 20),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    color: primaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Text(
                                                'CANCEL',
                                                style: TextStyle(
                                                    color: primaryColor),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            TextButton(
                                              child: Text(
                                                'REMOVE',
                                                style: TextStyle(
                                                    color: primaryColor),
                                              ),
                                              onPressed: () async {
                                                int status = await DatabaseHelper.db.delete('DELETE FROM ${DatabaseHelper.deviceTable} WHERE id = ?', [device['id']]);
                                                await DatabaseHelper.db.delete('DELETE FROM ${DatabaseHelper.applianceTable} WHERE mcu = ?', [device['id']]);
                                                if (status == 1) {
                                                  Navigator.pop(context);
                                                  deviceData = await DatabaseHelper.db.getAll(DatabaseHelper.deviceTable);
                                                  setState(() {});
                                                }
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                  // ScaffoldMessenger.of(context)
                                },
                                child: Device(
                                    device['mcu_name'], device['mcu_type']),
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
