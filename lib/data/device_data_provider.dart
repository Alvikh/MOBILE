// 1. Define a notifier class
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeviceDataNotifier extends StateNotifier<Map<String, dynamic>> {
  DeviceDataNotifier() : super({});

  // Custom method to update data
  void updateDeviceData(Map<String, dynamic> newData) {
    print("Updating state to: $newData");
    state = {...newData}; // Creates a new map with the updated data
  }
}

// 2. Create the provider
final deviceDataProvider = StateNotifierProvider<DeviceDataNotifier, Map<String, dynamic>>((ref) {
  return DeviceDataNotifier();
});

// 3. Usage in your code
