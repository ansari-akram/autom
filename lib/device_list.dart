// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, avoid_print, prefer_const_literals_to_create_immutables

import 'package:autom/database_helper.dart';
import 'package:flutter/material.dart';
import 'room_widget.dart';
import 'server_comms.dart';
import 'custom_color_code.dart';
import 'adaptive_text.dart';

class DeviceList extends StatefulWidget {
  final String userId;
  final String username;

  const DeviceList({Key? key, required this.userId, required this.username})
      : super(key: key);

  @override
  State<DeviceList> createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  List deviceData = [];

  Future<void> refreshDevicesOnRefreshIndicator() async {
    List dd = await getDevices(widget.userId);
    setState(() {
      deviceData = dd;
    });
  }

  @override
  void initState() {
    getDevices(widget.userId).then((value) {
      setState(() {
        deviceData = value;
      });
    });
    // TODO: implement initState
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
          Navigator.pushNamed(context, '/add-iot-device', arguments: {
            'user_id': widget.userId,
            'username': widget.username,
          });
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
                                                // print("DEVICE, $device");
                                                Map _deviceDetails =
                                                    await DatabaseHelper.db
                                                        .getByQuery(
                                                            'SELECT * FROM ${DatabaseHelper.deviceTable} WHERE mcu_name = ? AND mcu_type = ? AND mcu_ip = ?',
                                                            [
                                                      device['mcu_name'],
                                                      device['mcu_type'].toString(),
                                                      device['mcu_ip'],
                                                    ]);

                                                // print('DEVICE DETAILS $_deviceDetails');

                                                await DatabaseHelper.db.delete(
                                                    'DELETE FROM ${DatabaseHelper.deviceTable} WHERE id = ?',
                                                    [_deviceDetails['id']]);

                                                await DatabaseHelper.db.delete(
                                                    'DELETE FROM ${DatabaseHelper.applianceTable} WHERE mcu = ?',
                                                    [_deviceDetails['id']]);

                                                bool status = await deleteIP(
                                                    device['id'].toString());
                                                if (status) {
                                                  Navigator.pop(context);
                                                  deviceData = await getDevices(
                                                      widget.userId);
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
