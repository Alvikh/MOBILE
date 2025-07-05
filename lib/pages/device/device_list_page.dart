import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ta_mobile/models/device.dart';
import 'package:ta_mobile/pages/device/edit_device_page.dart';
import 'package:ta_mobile/services/device_service.dart';

class DeviceListPage extends ConsumerStatefulWidget {
  const DeviceListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DeviceListPage> createState() => _DeviceListPageState();
}

class _DeviceListPageState extends ConsumerState<DeviceListPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final deviceService = ref.watch(deviceServiceProvider);
    final devicesAsync = ref.watch(deviceListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F9),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Daftar Perangkat',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF0A5099),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => ref.refresh(deviceListProvider),
          ),
        ],
      ),
      body: devicesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF0A5099),
          ),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
        ),
        data: (devices) {
          if (devices.isEmpty) {
            return Center(
              child: Text(
                'Tidak ada perangkat',
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
            );
          }
          return _buildDeviceList(devices, deviceService);
        },
      ),
    );
  }

  Widget _buildDeviceList(List<Device> devices, DeviceService deviceService) {
    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: devices.length,
          itemBuilder: (context, index) {
            final device = devices[index];
            return _buildDeviceCard(device, context, deviceService);
          },
        ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF0A5099),
            ),
          ),
      ],
    );
  }

  Widget _buildDeviceCard(
      Device device, BuildContext context, DeviceService deviceService) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    device.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(device.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    device.status.toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(device.status),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildDeviceDetailRow('ID Perangkat', device.deviceId),
            _buildDeviceDetailRow('Tipe', device.type),
            _buildDeviceDetailRow('Gedung', device.building),
            _buildDeviceDetailRow(
              'Tanggal Instalasi',
              device.installationDate != null
                  ? '${device.installationDate!.day}/${device.installationDate!.month}/${device.installationDate!.year}'
                  : '-',
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text(
                      'Edit',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0A5099),
                      side: const BorderSide(color: Color(0xFF0A5099)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () => _navigateToEditPage(device, context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.delete, size: 18),
                    label: const Text(
                      'Hapus',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () =>
                        _showDeleteDialog(device, context, deviceService),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.orange;
      case 'maintenance':
        return const Color(0xFF0A5099);
      default:
        return Colors.grey;
    }
  }

  Widget _buildDeviceDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          const Text(': '),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToEditPage(Device device, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDevicePage(device: device),
      ),
    ).then((_) => ref.refresh(deviceListProvider));
  }

  void _showDeleteDialog(
      Device device, BuildContext context, DeviceService deviceService) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Hapus Perangkat',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus perangkat ${device.name}?',
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Batal',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text(
                'Hapus',
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'Poppins',
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteDevice(device, context, deviceService);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteDevice(
      Device device, BuildContext context, DeviceService deviceService) async {
    setState(() => _isLoading = true);
    try {
      await deviceService.deleteDevice(device.id!);
      // ignore: unused_result
      ref.refresh(deviceListProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Perangkat ${device.name} berhasil dihapus',
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal menghapus perangkat: ${e.toString()}',
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

final deviceListProvider = FutureProvider<List<Device>>((ref) async {
  final deviceService = ref.read(deviceServiceProvider);
  return await deviceService.getMyDevices();
});
