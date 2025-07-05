import 'package:flutter/material.dart';
import 'package:ta_mobile/l10n/app_localizations.dart';
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
    if (!mqttService.isConnected) {
      mqttService.connect();
    }
    devices = User()
        .devices
        .where((device) => device.type.toLowerCase() == 'control')
        .toList();
  }

  @override
  void dispose() {
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
    final s = AppLocalizations.of(context)!;
    final activeDevices = devices.where((d) => d.status == 'active').length;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Container(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Column(
                      children: [
                        _buildHeader(context, activeDevices),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.deviceControl,
                                style: const TextStyle(
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
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.grey[300]!,
                                          width: 1.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            blurRadius: 12,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.devices_other_rounded,
                                            color: Colors.blueGrey.shade400,
                                            size: 48,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            s.noControlDeviceTitle,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            s.noControlDeviceSubtitle,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : _buildDeviceGrid(context),
                              const SizedBox(height: 30),
                              _buildSceneControls(context),
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

  Widget _buildHeader(BuildContext context, int activeDevices) {
    final s = AppLocalizations.of(context)!;
    
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
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                s.smartHomeTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                      s.statusActive.replaceFirst('{count}', activeDevices.toString()),
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
            s.smartHomeSubtitle,
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

  Widget _buildDeviceGrid(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    
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
      itemBuilder: (context, index) => _buildDeviceCard(context, devices[index]),
    );
  }

  Widget _buildDeviceCard(BuildContext context, Device device) {
    final s = AppLocalizations.of(context)!;
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
                    isActive ? s.statusOn : s.statusOff,
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

  Widget _buildSceneControls(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.quickScenes,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Flexible(
              child: _buildSceneButton(
                context,
                s.allOn,
                Icons.power_settings_new,
                Colors.green[600]!,
                () => _toggleAllDevices(true),
              ),
            ),
            const SizedBox(width: 15),
            Flexible(
              child: Expanded(
                child: _buildSceneButton(
                  context,
                  s.allOff,
                  Icons.power_off,
                  Colors.red[400]!,
                  () => _toggleAllDevices(false),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSceneButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
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

  void _toggleAllDevices(bool status) {
    for (var device in devices) {
      _toggleDevice(device.deviceId, status);
    }
  }
}