import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ta_mobile/models/device.dart';
import 'package:ta_mobile/models/user.dart';
import 'package:ta_mobile/services/api_service.dart';
import 'package:ta_mobile/services/provider/user_notifier.dart';

final deviceServiceProvider = Provider<DeviceService>((ref) {
  return DeviceService(ref);
});

class DeviceService {
  final Ref ref;
  final ApiService _api = ApiService();

  DeviceService(this.ref);

  // Get all devices for current user
  Future<List<Device>> getMyDevices() async {
    try {
      final response = await _api.get('/devices/', body: {
        'user_id': User().id,
      });

      if (response['success'] == true) {
        final devices = (response['data']['data'] as List)
            .map((device) => Device.fromJson(device))
            .toList();

        // Update user devices in state
        ref.read(userProvider.notifier).setDevices(devices);

        return devices;
      }
      throw ApiException(
        message: response['data']['message'] ?? 'Failed to get devices',
        statusCode: response['statusCode'],
      );
    } on DioException catch (e) {
      throw ApiException(
        message: e.response?.data['message'] ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException(message: 'Failed to fetch devices: ${e.toString()}');
    }
  }

  // Create new device
  Future<Device> createDevice({
    required String name,
    required String deviceId,
    required String type,
    required String building,
    required DateTime installationDate,
    required String status,
  }) async {
    try {
      final response = await _api.post('/devices', {
        'name': name,
        'device_id': deviceId,
        'type': type,
        'building': building,
        'installation_date': installationDate.toIso8601String(),
        'status': status,
        'user_id': User().id,
      });

      if (response['success'] == true && response['data'] != null) {
        final newDevice = Device.fromJson(response['data']);

        // Add device to user's devices in state
        ref.read(userProvider.notifier).addDevice(newDevice);

        return newDevice;
      }
      throw ApiException(
        message: response['message'] ?? 'Failed to create device',
        statusCode: response['statusCode'],
      );  
    } on DioException catch (e) {
      throw ApiException(
        message: e.response?.data['message'] ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException(message: 'Failed to create device: ${e.toString()}');
    }
  }

  // Get single device
  Future<Device> getDevice(String id) async {
    try {
      final response = await _api.get('/devices/$id');

      if (response['success'] == true && response['data'] != null) {
        return Device.fromJson(response['data']);
      }
      throw ApiException(
        message: response['message'] ?? 'Device not found',
        statusCode: response['statusCode'],
      );
    } on DioException catch (e) {
      throw ApiException(
        message: e.response?.data['message'] ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException(message: 'Failed to get device: ${e.toString()}');
    }
  }

  // Update device
  Future<Device> updateDevice({
    required String id,
    String? name,
    String? deviceId,
    String? type,
    String? building,
    DateTime? installationDate,
    String? status,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (name != null) data['name'] = name;
      if (deviceId != null) data['device_id'] = deviceId;
      if (type != null) data['type'] = type;
      if (building != null) data['building'] = building;
      if (installationDate != null)
        data['installation_date'] = installationDate.toIso8601String();
      if (status != null) data['status'] = status;

      final response = await _api.put('/devices/$id', data);

      if (response['success'] == true && response['data'] != null) {
        final updatedDevice = Device.fromJson(response['data']);

        // Update device in user's devices list
        ref.read(userProvider.notifier).updateDevice(updatedDevice);

        return updatedDevice;
      }
      throw ApiException(
        message: response['message'] ?? 'Failed to update device',
        statusCode: response['statusCode'],
      );
    } on DioException catch (e) {
      throw ApiException(
        message: e.response?.data['message'] ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException(message: 'Failed to update device: ${e.toString()}');
    }
  }

  // Delete device
  Future<void> deleteDevice(int id) async {
    try {
      final response = await _api.delete('/devices/$id');

      if (response['success'] == true) {
        // Remove device from user's devices list
        ref.read(userProvider.notifier).removeDevice(id);
      } else {
        throw ApiException(
          message: response['message'] ?? 'Failed to delete device',
          statusCode: response['statusCode'],
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        message: e.response?.data['message'] ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException(message: 'Failed to delete device: ${e.toString()}');
    }
  }

  // Get devices by building
  Future<List<Device>> getDevicesByBuilding(String building) async {
    try {
      final response = await _api.get('/devices/building/$building');

      if (response['success'] == true) {
        return (response['data'] as List)
            .map((device) => Device.fromJson(device))
            .toList();
      }
      throw ApiException(
        message: response['message'] ?? 'Failed to get devices by building',
        statusCode: response['statusCode'],
      );
    } on DioException catch (e) {
      throw ApiException(
        message: e.response?.data['message'] ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException(
          message: 'Failed to fetch devices by building: ${e.toString()}');
    }
  }

  // Get devices by status
  Future<List<Device>> getDevicesByStatus(String status) async {
    try {
      final response = await _api.get('/devices/status/$status');

      if (response['success'] == true) {
        return (response['data'] as List)
            .map((device) => Device.fromJson(device))
            .toList();
      }
      throw ApiException(
        message: response['message'] ?? 'Failed to get devices by status',
        statusCode: response['statusCode'],
      );
    } on DioException catch (e) {
      throw ApiException(
        message: e.response?.data['message'] ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException(
          message: 'Failed to fetch devices by status: ${e.toString()}');
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() => message;
}
