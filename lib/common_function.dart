// ignore_for_file: avoid_print, non_constant_identifier_names

import 'database_helper.dart';
import 'server_comms.dart';

Future<void> checkData(String uId) async {
  // print("OFFLINE DATA");
  List offlineDeviceData =
      await DatabaseHelper.db.getAll(DatabaseHelper.deviceTable);
  List offlineRoomData =
      await DatabaseHelper.db.getAll(DatabaseHelper.roomTable);
  List offlineRoomDeviceData =
      await DatabaseHelper.db.getAll(DatabaseHelper.applianceTable);
  // print(offlineDeviceData);
  // print(offlineRoomData);
  // print(offlineRoomDeviceData);

  // print("\nONLINE DATA");
  var onlineDeviceData = await getDataTable('mcu');
  var onlineRoomData = await getDataTable('room');
  var onlineRoomDeviceData = await getDataTable('room_device');

  List userOnlineDeviceData = getDataByUser(onlineDeviceData, uId);
  List userOnlineRoomData = getDataByUser(onlineRoomData, uId);
  List userOnlineRoomDeviceData = getDataByUser(onlineRoomDeviceData, uId);

  // print(userOnlineDeviceData);
  // print(userOnlineRoomData);
  // print(userOnlineRoomDeviceData);

  List _deviceDataToInsertToOffline = [];
  List _deviceDataToInsertToOnline = [];

  List _roomDataToInsertToOffline = [];
  List _roomDataToInsertToOnline = [];

  List _roomDeviceToInsertToOffline = [];
  List _roomDeviceToInsertToOnline = [];

  List DEVICE_DATA_OFFLINE_VALUES = ['mcu_name', 'mcu_type', 'mcu_ip'];
  List DEVICE_DATA_ONLINE_VALUES = ['mcu_name', 'mcu_type', 'mcu_ip'];

  List ROOM_DATA_OFFLINE_VALUES = ['room_name'];
  List ROOM_DATA_ONLINE_VALUES = ['room_name'];

  List ROOM_DEVICE_DATA_OFFLiNE_VALUES = [
    'appliance_name',
    'btn_state',
    'btn_no'
  ];
  List ROOM_DEVICE_DATA_ONLINE_VALUES = ['device_name', 'btn_state', 'btn_no'];

  // SYNC DEVICE DATA
  for (var _offlineData in offlineDeviceData) {
    if (_offlineData['is_new'] == '1') {
      print('_offlineData $_offlineData');
      bool result = await createIp(uId, _offlineData['mcu_name'],
          _offlineData['mcu_ip'], _offlineData['mcu_type'].toString() == device8 ? '8' : '4');
      // print('result $result');
      if (result) {
        DatabaseHelper.db.update(
            'UPDATE ${DatabaseHelper.deviceTable} SET is_new = ?', ['0']);
      }
    }
  }

  // print("OLD DEVICE DATA $offlineDeviceData");
  offlineDeviceData =
      await DatabaseHelper.db.getAll(DatabaseHelper.deviceTable);
  // print("NEW DEVICE DATA $offlineDeviceData");

  // SYNC ROOM DATA
  for (var _offlineData in offlineRoomData) {
    if (_offlineData['is_new'] == '1') {
      // print('_offlineData $_offlineData');
      bool result = await createRoom(uId, _offlineData['room_name']);
      // print('result $result');
      if (result) {
        DatabaseHelper.db
            .update('UPDATE ${DatabaseHelper.roomTable} SET is_new = ?', ['0']);
      }
    }
  }

  // print("OLD DEVICE DATA $offlineRoomData");
  offlineRoomData = await DatabaseHelper.db.getAll(DatabaseHelper.roomTable);
  // print("NEW DEVICE DATA $offlineRoomData");

  // SYNC ROOM DEVICE DATA

  for (var _offlineData in offlineRoomDeviceData) {
    if (_offlineData['is_new'] == '1') {
      String onlineRoomId =
          await getOnlineRoomId(uId, _offlineData, offlineRoomData);
      String onlineDeviceId =
          await getOnlineDeviceId(uId, _offlineData, offlineDeviceData);

      // print('onlineRoomId $onlineRoomId');
      // print('onlineDeviceId $onlineDeviceId');
      // print(_offlineData);

      if (onlineRoomId != "" && onlineDeviceId != "") {
        bool result = await createRoomDevice(
            uId,
            onlineRoomId,
            _offlineData['appliance_name'],
            _offlineData['btn_no'],
            onlineDeviceId);
        // print('result $result');

        if (result) {
          var onlineRoomDeviceData = await getDataTable('room_device');
          List userOnlineRoomDeviceData =
              getDataByUser(onlineRoomDeviceData, uId);

          // print(userOnlineRoomDeviceData);
          // print(onlineRoomId);
          // print(onlineDeviceId);
          // print(_offlineData);

          for (var _roomDevice in userOnlineRoomDeviceData) {
            // print(_roomDevice['room'].toString() == onlineRoomId);
            // print(_roomDevice['mcu'].toString() == onlineDeviceId);
            // print(_roomDevice['device_name'] ==
            //     _offlineData['appliance_name']);
            // print(_roomDevice['btn_no'].toString() ==
            //     _offlineData['btn_no'].toString());

            if (_roomDevice['room'].toString() == onlineRoomId &&
                _roomDevice['mcu'].toString() == onlineDeviceId &&
                _roomDevice['device_name'] == _offlineData['appliance_name'] &&
                _roomDevice['btn_no'].toString() ==
                    _offlineData['btn_no'].toString()) {
              bool result = await setBtnStateOfApplianceById(
                  _roomDevice['id'].toString(),
                  _offlineData['btn_state'].toString());

              // print("2nd result $result");

              if (result) {
                DatabaseHelper.db.update(
                    'UPDATE ${DatabaseHelper.applianceTable} SET is_new = ?, state_changed = ?',
                    ['0', '0']);
              }
            }
          }
        }
      }
    } else if (_offlineData['state_changed'] == '1') {
      String onlineRoomId =
          await getOnlineRoomId(uId, _offlineData, offlineRoomData);
      String onlineDeviceId =
          await getOnlineDeviceId(uId, _offlineData, offlineDeviceData);

      // print('onlineRoomId $onlineRoomId');
      // print('onlineDeviceId $onlineDeviceId');
      // print(_offlineData);

      var onlineRoomDeviceData = await getDataTable('room_device');
      List userOnlineRoomDeviceData = getDataByUser(onlineRoomDeviceData, uId);

      for (var _roomDevice in userOnlineRoomDeviceData) {
        // print(_roomDevice['room'].toString() == onlineRoomId);
        // print(_roomDevice['mcu'].toString() == onlineDeviceId);
        // print(_roomDevice['device_name'] ==
        //     _offlineData['appliance_name']);
        // print(_roomDevice['btn_no'].toString() ==
        //     _offlineData['btn_no'].toString());

        if (_roomDevice['room'].toString() == onlineRoomId &&
            _roomDevice['mcu'].toString() == onlineDeviceId &&
            _roomDevice['device_name'] == _offlineData['appliance_name'] &&
            _roomDevice['btn_no'].toString() ==
                _offlineData['btn_no'].toString()) {
          bool result = await setBtnStateOfApplianceById(
              _roomDevice['id'].toString(),
              _offlineData['btn_state'].toString());

          // print("result $result");

          if (result) {
            DatabaseHelper.db.update(
                'UPDATE ${DatabaseHelper.applianceTable} SET state_changed = ?',
                ['0']);
          }
        }
      }
    }
  }
}

Future<void> insertOfflineFromOnline(String uId) async {
  var onlineDeviceData = await getDataTable('mcu');
  var onlineRoomData = await getDataTable('room');
  var onlineRoomDeviceData = await getDataTable('room_device');

  List userOnlineDeviceData = getDataByUser(onlineDeviceData, uId);
  List userOnlineRoomData = getDataByUser(onlineRoomData, uId);
  List userOnlineRoomDeviceData = getDataByUser(onlineRoomDeviceData, uId);

  for (var _onlineData in userOnlineDeviceData) {
    print('DATA $_onlineData');
    await DatabaseHelper.db.insert(
        'INSERT INTO ${DatabaseHelper.deviceTable}(mcu_name, mcu_type, mcu_ip, is_new) VALUES(?, ?, ?, ?)',
        [
          _onlineData['mcu_name'],
          _onlineData['mcu_type'].toString(),
          _onlineData['mcu_ip'],
          '0'
        ]);
  }

  for (var _onlineData in userOnlineRoomData) {
    await DatabaseHelper.db.insert(
        'INSERT INTO ${DatabaseHelper.roomTable}(room_name, is_new) VALUES (?, ?)',
        [_onlineData['room_name'], '0']);
  }

  for (var _onlineData in userOnlineRoomDeviceData) {
    var _roomId = '';
    for (var _room in userOnlineRoomData) {
      if (_room['id'].toString() == _onlineData['room'].toString()) {
        _roomId = await DatabaseHelper.db.getIdByRoomName(_room['room_name']);
      }
    }

    var _mcuId = '';
    for (var _device in userOnlineDeviceData) {
      if (_device['id'].toString() == _onlineData['mcu'].toString()) {
        _mcuId = await DatabaseHelper.db.getIdByDeviceName(_device['mcu_name']);
      }
    }

    await DatabaseHelper.db.insert(
        'INSERT INTO ${DatabaseHelper.applianceTable}(room, mcu, btn_no, btn_state, appliance_name, is_new, state_changed) VALUES(?, ?, ?, ?, ?, ?, ?)',
        [
          _roomId,
          _mcuId,
          _onlineData['btn_no'],
          _onlineData['btn_state'] ? "ON" : "OFF",
          _onlineData['device_name'],
          '0',
          '0'
        ]);
  }
}

List getDataByUser(List _data, String uId) {
  List _tmp = [];

  for (var d in _data) {
    if (d['user'] == uId) {
      _tmp.add(d);
    }
  }
  return _tmp;
}

void insertBulkData(String _query, List _valuesList) async {
  for (var _values in _valuesList) {
    DatabaseHelper.db.insert(_query, _values);
  }
}

List validateData(List _offlineData, List _onlineData, List _offlineValues,
    List _onlineValues) {
  List _valuesToInsert = [];

  for (int i = 0; i < _offlineData.length; i++) {
    try {
      var _offline = _offlineData[i];
      var _online = _onlineData[i];

      for (int i = 0; i < _offlineValues.length; i++) {
        if (_offline[_offlineValues[i]] != _online[_onlineValues[i]]) {
          _valuesToInsert.add(sortData(_offline, _offlineValues));
        }
      }
    } catch (e) {
      var _offline = _offlineData[i];
      _valuesToInsert.add(sortData(_offline, _offlineValues));
    }
  }
  return _valuesToInsert;
}

List sortData(Map _dataList, List _values) {
  List _tmp = [];
  for (int i = 0; i < _values.length; i++) {
    _tmp.add(_dataList[_values[i]]);
  }
  return _tmp;
}

Future<String> getOnlineRoomId(
    String uId, Map _offlineData, List _roomData) async {
  // print("getting online room id");
  // print(_offlineData);
  String offRoomName = '';

  for (var _room in _roomData) {
    if (_offlineData['room'].toString() == _room['id'].toString()) {
      offRoomName = _room['room_name'].toString();
      break;
    }
  }
  var onlineRoomData = await getDataTable('room');
  List userOnlineRoomData = getDataByUser(onlineRoomData, uId);

  // print(userOnlineRoomData);
  // print("OFFLINE ROOM ID $offRoomName");

  for (var _onlineData in userOnlineRoomData) {
    if (offRoomName == _onlineData['room_name'] && uId == _onlineData['user']) {
      return _onlineData['id'].toString();
    }
  }
  return '';
}

Future<String> getOnlineDeviceId(
    String uId, Map _offlineData, List _deviceData) async {
  // print("getting online device id");
  // print(_offlineData);
  String offDeviceName = '';
  String offDeviceIp = '';

  for (var _device in _deviceData) {
    if (_offlineData['mcu'].toString() == _device['id'].toString()) {
      offDeviceName = _device['mcu_name'].toString();
      offDeviceIp = _device['mcu_ip'].toString();
      break;
    }
  }
  var onlineRoomData = await getDataTable('mcu');
  List userOnlineDeviceData = getDataByUser(onlineRoomData, uId);

  // print(userOnlineDeviceData);
  // print("OFFLINE DEVICE NAME $offDeviceName");
  // print("OFFLINE DEVICE IP $offDeviceIp");

  for (var _onlineData in userOnlineDeviceData) {
    if (offDeviceName == _onlineData['mcu_name'] &&
        uId == _onlineData['user'] &&
        offDeviceIp == _onlineData['mcu_ip']) {
      return _onlineData['id'].toString();
    }
  }
  return '';
}
