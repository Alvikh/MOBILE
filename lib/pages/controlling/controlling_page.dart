import 'package:flutter/material.dart';
import 'package:ta_mobile/models/device.dart';
import 'package:ta_mobile/models/user.dart';
import 'package:ta_mobile/services/mqtt_service.dart';
import 'package:ta_mobile/widgets/custom_floating_navbar.dart';

class ControllingPage extends StatefulWidget {
  const ControllingPage({Key? key}) : super(key: key);

  @override
  State<ControllingPage> createState() => _ControllingPageState();
}

class _ControllingPageState extends State<ControllingPage> {
  late MqttService mqttService;
  late List<Device> devices;

  @override
  void initState() {
    super.initState();
    mqttService = MqttService();
    devices = User()
        .devices
        .where((device) => device.type.toLowerCase() == 'control')
        .toList();
    // mqttService.connect();
  }

  @override
  void dispose() {
    // mqttService.disconnect();
    super.dispose();
  }

  void _toggleDevice(String deviceId, bool status) {
    mqttService.publishControlCommand(
        deviceId, 'relay_control', status ? 'ON' : 'OFF');

    setState(() {
      final device = devices.firstWhere((d) => d.deviceId == deviceId);
      device.state = status ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeDevices = devices.where((d) => d.status == 'active').length;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Column(
                      children: [
                        _buildHeader(activeDevices),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Device Control',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins',
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 20),
                              devices.isEmpty
                                  ? Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 40, horizontal: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Colors.grey[300]!),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Anda tidak memiliki perangkat kontrol.\nTambahkan perangkat control terlebih dahulu.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    )
                                  : _buildDeviceGrid(),
                              const SizedBox(height: 30),
                              _buildSceneControls(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const CustomFloatingNavbar(selectedIndex: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int activeDevices) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 40, 25, 30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A5099), Color(0xFF1A73E8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Smart Home',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.power_settings_new,
                        size: 16, color: Colors.white.withOpacity(0.9)),
                    const SizedBox(width: 6),
                    Text(
                      '$activeDevices Active',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Control your smart devices',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.8,
      ),
      itemCount: devices.length,
      itemBuilder: (context, index) => _buildDeviceCard(devices[index]),
    );
  }

  Widget _buildDeviceCard(Device device) {
    final isActive = device.state == true;
    final deviceColor = _getDeviceColor(device.type);

    return Card(
      elevation: isActive ? 4 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: isActive
              ? deviceColor.withOpacity(0.3)
              : Colors.grey.withOpacity(0.1),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _toggleDevice(device.deviceId, !isActive),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: deviceColor.withOpacity(isActive ? 0.2 : 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getDeviceIcon(device.type),
                      size: 24,
                      color: isActive ? deviceColor : Colors.grey[400],
                    ),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: isActive,
                      onChanged: (value) =>
                          _toggleDevice(device.deviceId, value),
                      activeColor: deviceColor,
                      activeTrackColor: deviceColor.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.black87 : Colors.grey[600],
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isActive ? 'ON' : 'OFF',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isActive ? deviceColor : Colors.grey[400],
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDeviceColor(String type) {
    switch (type.toLowerCase()) {
      case 'light':
        return Colors.amber;
      case 'ac':
        return Colors.blue;
      case 'fan':
        return Colors.green;
      default:
        return Colors.purple;
    }
  }

  IconData _getDeviceIcon(String type) {
    switch (type.toLowerCase()) {
      case 'light':
        return Icons.lightbulb;
      case 'ac':
        return Icons.ac_unit;
      case 'fan':
        return Icons.mode_fan_off;
      default:
        return Icons.device_unknown;
    }
  }

  Widget _buildSceneControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Scenes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _buildSceneButton(
                'All On',
                Icons.power_settings_new,
                Colors.green[600]!,
                () => _toggleAllDevices(true),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildSceneButton(
                'All Off',
                Icons.power_off,
                Colors.red[400]!,
                () => _toggleAllDevices(false),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        _buildSceneButton(
          'Night Mode',
          Icons.nightlight_round,
          const Color(0xFF0A5099),
          _activateNightMode,
        ),
      ],
    );
  }

  Widget _buildSceneButton(
      String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color.withOpacity(0.3), width: 1),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  void _toggleAllDevices(bool status) {
    for (var device in devices) {
      _toggleDevice(device.deviceId!, status);
    }
  }

  void _activateNightMode() {
    for (var device in devices) {
      if (device.name.toLowerCase().contains('light')) {
        _toggleDevice(device.deviceId!, false);
      } else if (device.type.toLowerCase().contains('ac')) {
        _toggleDevice(device.deviceId!, true);
      }
    }
  }
}
