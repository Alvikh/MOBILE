import 'package:dio/dio.dart';
import 'package:ta_mobile/services/api_service.dart';

class EnergyAnalyticsService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getDeviceData(int id) async {
    try {
      final response = await _apiService.get(
        '/energy/device/$id',
      );

      if (response['success'] == true) {
        return {
          'success': true,
          'data': response['data'],
        };
      } else {
        throw ApiException(
          message: response['message'] ?? 'Failed to fetch device data',
          statusCode: response['statusCode'],
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getPredictionData(int id) async {
    try {
      final response = await _apiService.get(
        '/energy/device/$id/prediction',
      );

      if (response['success'] == true) {
        return {
          'success': true,
          'data': response['data'],
        };
      } else {
        throw ApiException(
          message: response['message'] ?? 'Failed to fetch prediction data',
          statusCode: response['statusCode'],
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getConsumptionHistory(
    int id, {
    String period = 'day',
    int days = 7,
  }) async {
    try {
      final response = await _apiService.get(
        '/energy/device/$id/consumption',
        body: {
          'period': period,
          'days': days,
        },
      );

      if (response['success'] == true) {
        return {
          'success': true,
          'data': response['data'],
        };
      } else {
        throw ApiException(
          message: response['message'] ?? 'Failed to fetch consumption history',
          statusCode: response['statusCode'],
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> storeMeasurement(
    String deviceId,
    Map<String, dynamic> measurementData,
  ) async {
    try {
      final response = await _apiService.post(
        '/energy/device/$deviceId/measurement',
        measurementData,
      );

      if (response['success'] == true) {
        return {
          'success': true,
          'message': 'Measurement stored successfully',
        };
      } else {
        throw ApiException(
          message: response['message'] ?? 'Failed to store measurement',
          statusCode: response['statusCode'],
        );
      }
    } catch (e) {
      rethrow;
    }
  }
  Future<Map<String, dynamic>> getDataHistory(
    String deviceId, {
    DateTime? startDate,
    DateTime? endDate,
    String? interval,
  }) async {
    try {
      // Build query parameters
      final Map<String, dynamic> queryParams = {};
      
      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String();
      }
      
      if (endDate != null) {
        queryParams['end_date'] = endDate.toIso8601String();
      }
      
      if (interval != null) {
        queryParams['interval'] = interval;
      }

      // Make the API request
      final response = await _apiService.get(
        '/device/$deviceId/consumption',
        body: queryParams,
      );

      if (response['success'] == true) {
        return {
          'success': true,
          'data': response['data'],
        };
      } else {
        throw ApiException(
          message: response['message'] ?? 'Failed to fetch consumption data',
          statusCode: response['statusCode'],
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        message: e.response?.data['message'] ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException(
        message: 'Unexpected error: $e',
      );
    }
  }
}