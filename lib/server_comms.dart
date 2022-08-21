// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

String device8 = "2";
String device4 = "1";

String serverIp = "http://140.238.244.199:8000/v1/";

Future<dynamic> getDataTable(String modelName) async {
  var url = Uri.parse('$serverIp$modelName');
  var response = await http.get(url);
  var rJson = jsonDecode(response.body);
  return rJson;
}

Future<bool> register(
    String uName, String pwd, String email, String phone) async {
  var request =
      http.MultipartRequest('POST', Uri.parse('${serverIp}register/'));
  request.fields.addAll(
      {'username': uName, 'password': pwd, 'email': email, 'phone': phone});

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
    return true;
  } else {
    print(response.reasonPhrase);
    return false;
  }
}

Future<String> login(String uName, String pwd) async {
  var data = {'username': uName, 'password': pwd};
  var res = await postData('login/', data);
  if (res[1] == 200) {
    try {
      return res[0]['200'] + "`|`" + res[0]['username'];
    } on NoSuchMethodError catch (_) {
      return "`|`";
    }
  } else {
    return 'null';
  }
}

Future<bool> forgetPassword(String username) async {
  var request =
      http.MultipartRequest('POST', Uri.parse('${serverIp}forget-password/'));
  request.fields.addAll({'username': username});

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    Map statusCode = jsonDecode(await response.stream.bytesToString());
    if (statusCode['status'] == 200.toString()) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

Future<List> setNewPassword(
    String username, String uId, String password) async {
  print('${serverIp}set-password/');
  var request =
      http.MultipartRequest('POST', Uri.parse('${serverIp}set-password/'));
  request.fields
      .addAll({'username': username, 'uuid': uId, 'password': password});

  http.StreamedResponse response = await request.send();
  // print(jsonDecode(await response.stream.bytesToString()));

  if (response.statusCode == 200) {
    Map statusCode = jsonDecode(await response.stream.bytesToString());
    if (statusCode['status'].toString() == 201.toString()) {
      return [true, statusCode['message']];
    } else {
      return [false, statusCode['message']];
    }
  } else {
    return [false, false];
  }
}

Future<List> postData(String modelName, var data) async {
  var url = Uri.parse('$serverIp$modelName');
  var response = await http.post(url, body: data);
  var rJson = jsonDecode(response.body);
  return [rJson, response.statusCode];
}

Future<bool> createRoom(String userId, String roomName) async {
  var data = {'user': userId, 'room_name': roomName};
  var res = await postData('room/', data);
  if (res[1] == 201) {
    return true;
  } else {
    return false;
  }
}

void getDeviceWebServer(String ip) async {
  var url = Uri.parse('http://$ip/');
  print(url);
  var client = http.Client();
  var request = await client.get(url, headers: {
    "Access-Control-Allow-Origin": "*",
  });
  print(request.body);
  // var responseBody = await request.transform(utf8.decoder).join();

  // var response = await http.get(url, headers: {
  //   "Access-Control-Allow-Origin": "*",
  //   "Accept": "*/*",
  //   // "Accept-Encoding": "gzip",
  // });
  // http.Response response = await http.get(url);
  print('WEBSERVER');
  // print(response.statusCode);
  // print(response.body);
}

Future<bool> createIp(
    String userId, String serialNo, String ipAddr, String mcuType) async {
  String stringMcuType = mcuType == '8' ? device8 : device4;
  var data = {
    'user': userId,
    'mcu_type': stringMcuType,
    'mcu_name': serialNo,
    'mcu_ip': ipAddr
  };
  var res = await postData('mcu/', data);
  if (res[1] == 201) {
    return true;
  } else {
    return false;
  }
}

Future<List> getRooms(String userId) async {
  var rJson = await getDataTable('room/');

  List rooms = [];

  for (var room in rJson) {
    if (room['user'] == userId) {
      rooms.add(room);
    }
  }

  return rooms;
}

Future<List> getRoomDetails(String userId, String roomID) async {
  var rJson = await getDataTable('room_device/');

  List roomDevices = [];

  for (var room in rJson) {
    if (room['user'] == userId && room['room'].toString() == roomID) {
      roomDevices.add(room);
    }
  }

  return roomDevices;
}

Future<List> getRoomDetailsWhole(String userId) async {
  var rJson = await getDataTable('room_device/');

  List roomDevices = [];

  for (var room in rJson) {
    roomDevices.add(room);
  }

  return roomDevices;
}

Future<List> getDevices(String userId) async {
  var rJson = await getDataTable('mcu/');

  List devices = [];

  for (var room in rJson) {
    if (room['user'] == userId) {
      devices.add(room);
    }
  }

  return devices;
}

Future<List> getDetailsOfObject(
    String userId, String mcuId, String tableName) async {
  String mcuName = '';
  String mcuIP = '';

  var rJson = await getDataTable('mcu/');

  for (var mcus in rJson) {
    if (mcus['user'] == userId && mcus['id'].toString() == mcuId) {
      mcuName = mcus['mcu_name'];
      mcuIP = mcus['mcu_ip'];
    }
  }

  return [mcuName, mcuIP];
}

Future<bool> setBtnStateOfApplianceById(String aID, String btnState) async {
  var request =
      http.MultipartRequest('PATCH', Uri.parse('${serverIp}room_device/$aID/'));
  request.fields.addAll({'btn_state': btnState});

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    // print(await response.stream.bytesToString());
    return true;
  } else {
    // print(response.reasonPhrase);
    return false;
  }
}

Future<bool> createRoomDevice(String userId, String roomId, String deviceName,
    String btnNo, String deviceId) async {
  var request =
      http.MultipartRequest('POST', Uri.parse('${serverIp}room_device/'));
  request.fields.addAll({
    'user': userId,
    'room': roomId,
    'mcu': deviceId,
    'btn_no': btnNo,
    'device_name': deviceName
  });

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}

Future<bool> deleteIP(String mcuID) async {
  var request = http.Request('DELETE', Uri.parse('${serverIp}mcu/$mcuID/'));

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 204) {
    return true;
  } else {
    return false;
  }
}

Future<bool> deleteRoomDevice(String roomDeviceID) async {
  var request = http.Request(
      'DELETE', Uri.parse('${serverIp}room_device/$roomDeviceID/'));

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 204) {
    return true;
  } else {
    return false;
  }
}

Future<bool> deleteRoom(String roomID) async {
  var request = http.Request('DELETE', Uri.parse('${serverIp}room/$roomID/'));

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 204) {
    return true;
  } else {
    return false;
  }
}

void toggleLocalOnOff(String localIP) async {
  print('http://$localIP');
  var request = http.Request('GET', Uri.parse('http://$localIP'));
  http.StreamedResponse response = await request.send();
}

// Future getRoomIdByRoomNameAndUid(String _roomName, String uId)