import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ta_mobile/models/device.dart';
import 'package:ta_mobile/models/user.dart';

class UserNotifier extends StateNotifier<User> {
  UserNotifier() : super(User());

  void updateUser(User user) {
    state = user.copyWith();
  }

  void addDevice(Device device) {
    state = state.copyWith(
      devices: [...state.devices, device],
    );
  }

  void clearUser() {
    state = User();
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User>((ref) {
  return UserNotifier();
});
