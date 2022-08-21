class InternalRoom {
  int id;
  String name;
  String image;

  InternalRoom(this.id, this.name, this.image);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }

  @override
  String toString() {
    return 'Room{id: $id, name: $name, image: $image}';
  }
}

class InternalDevice {
  int id;
  String deviceName;
  String mcuType;
  String deviceIP;

  InternalDevice(this.id, this.deviceName, this.mcuType, this.deviceIP);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'device_name': deviceName,
      'mcu_type': mcuType,
      'device_ip': deviceIP,
    };
  }

  @override
  String toString() {
    return 'Room{id: $id, device_name: $deviceName, mcu_type: $mcuType, device_ip: $deviceIP}';
  }
}

class InternalAppliance {
  int id;
  int roomId;
  int deviceId;
  int btnNo;
  String btnState;
  String applianceName;

  InternalAppliance(this.id, this.roomId, this.deviceId, this.btnNo,
      this.btnState, this.applianceName);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'room_id': roomId,
      'device_id': deviceId,
      'btn_no': btnNo,
      'btn_state': btnState,
      'appliance_name': applianceName,
    };
  }

  @override
  String toString() {
    return 'Room{id: $id, room_id: $roomId, device_id: $deviceId, btn_no: $btnNo, btn_state: $btnState, appliance_name: $applianceName}';
  }
}
