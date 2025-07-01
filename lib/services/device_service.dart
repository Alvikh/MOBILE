import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ta_mobile/models/device.dart';
import 'package:ta_mobile/services/api_service.dart';
import 'package:ta_mobile/services/provider/user_notifier.dart';

class DeviceService {
  final ApiService _api = ApiService();
  final WidgetRef ref;

  DeviceService(this.ref);

  Future<Device> addDevice(Device device) async {
    try {
      final response = await _api.post(
        '/devices',
        device.toJson(),
      );

      if (response['success'] == true && response['data'] != null) {
        final newDevice = Device.fromJson(response['data']);
        ref.read(userProvider.notifier).addDevice(newDevice);
        return newDevice;
      }
      throw Exception(response['message'] ?? 'Failed to add device');
    } catch (e) {
      throw Exception('Failed to add device: ${e.toString()}');
    }
  }

  Future<List<Device>> getDevices() async {
    final response = await _api.get('/devices');

    if (response['success']) {
      return (response['data']['devices'] as List)
          .map((device) => Device.fromJson(device))
          .toList();
    } else {
      throw Exception(response['message'] ?? 'Failed to get devices');
    }
  }
}
