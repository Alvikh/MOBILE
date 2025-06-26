import 'package:ta_mobile/models/device.dart';
import 'package:ta_mobile/services/api_service.dart';

class DeviceService {
  final ApiService _api = ApiService();

  Future<Device> addDevice(Device device) async {
    final response = await _api.post(
      '/devices',
      device.toJson(),
    );

    if (response['success']) {
      return Device.fromJson(response['data']['device']);
    } else {
      throw Exception(response['message'] ?? 'Failed to add device');
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
