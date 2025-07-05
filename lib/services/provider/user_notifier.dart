import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ta_mobile/models/device.dart';
import 'package:ta_mobile/models/user.dart';

class UserNotifier extends StateNotifier<User> {
  UserNotifier() : super(User());

  void addDevice(Device device) {
    state = state.copyWith(
      devices: [...state.devices, device],
    );
  }

  void setDevices(List<Device> devices) {
    state = state.copyWith(
      devices: devices,
    );
  }

  void updateDevice(Device updatedDevice) {
    state = state.copyWith(
      devices: state.devices.map((device) {
        return device.id == updatedDevice.id ? updatedDevice : device;
      }).toList(),
    );
  }

  void removeDevice(int deviceId) {
    state = state.copyWith(
      devices: state.devices.where((device) => device.id != deviceId).toList(),
    );
  }

  void clearUser() {
    state = User();
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User>((ref) {
  return UserNotifier();
});
