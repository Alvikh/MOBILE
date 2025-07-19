import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ta_mobile/l10n/app_localizations.dart';
import 'package:ta_mobile/models/device.dart';
import 'package:ta_mobile/models/user.dart';
import 'package:ta_mobile/pages/device/add_device_page.dart';
import 'package:ta_mobile/services/mqtt_service.dart';

class ControllingPage extends StatefulWidget {
  const ControllingPage({Key? key}) : super(key: key);

  @override
  State<ControllingPage> createState() => _ControllingPageState();
}

class _ControllingPageState extends State<ControllingPage>
    with SingleTickerProviderStateMixin {
  late MqttService mqttService;
  late List<Device> devices;
  late AnimationController _animationController;
  late Animation<double> _headerAnimation;
  late StreamSubscription<Map<String, dynamic>> _mqttSubscription;

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

    _setupMqttSubscription();

    // Animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _headerAnimation = Tween<double>(begin: -100, end: -10).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

void _setupMqttSubscription() {
  _mqttSubscription = mqttService.messageStream.listen((message) {
    if (message.containsKey('id') && 
        (message.containsKey('relay_state') || 
         message.containsKey('temperature') || 
         message.containsKey('humidity'))) {
      final deviceId = message['id'];
      final relayState = message['relay_state'];
      final temperature = message['temperature']?.toDouble();
      final humidity = message['humidity']?.toDouble();

      if (mounted) {
        setState(() {
          final deviceIndex = devices.indexWhere((d) => d.deviceId == deviceId);
          if (deviceIndex != -1) {
            // Update relay state if available
            if (relayState != null) {
              devices[deviceIndex].state = relayState == 'ON';
            }
            
            // Update temperature if available
            if (temperature != null) {
              devices[deviceIndex].temperature = temperature;
            }
            
            // Update humidity if available
            if (humidity != null) {
              devices[deviceIndex].humidity = humidity;
            }
          }
        });
      }
    }
  });
}

  @override
  void dispose() {
    _animationController.dispose();
    _mqttSubscription.cancel();
    super.dispose();
  }

  void _toggleDevice(String deviceId, bool status) {
    mqttService.publishControlCommand(
        deviceId, 'relay_control', status ? 'ON' : 'OFF');

    setState(() {
      final device = devices.firstWhere((d) => d.deviceId == deviceId);
      device.state = status;
    });
  }

  void _navigateToMonitoringView(Device device) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => DeviceMonitoringView(device: device),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final activeDevices = devices.where((d) => d.state == true).length;

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
                                  ? _buildNoDevicesPlaceholder(context)
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
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int activeDevices) {
    final s = AppLocalizations.of(context)!;

    return AnimatedBuilder(
      animation: _headerAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _headerAnimation.value),
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(25, 40, 25, 30),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0A5099), Color(0xFF1A73E8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(30)),
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(50, 50),
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(0),
                    backgroundColor: const Color(0xFF2196F3),
                    shadowColor: Colors.transparent,
                    elevation: 2,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddDevicePage()),
                    );
                  },
                  child: const Icon(Icons.add, color: Colors.white, size: 24),
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
      ),
    );
  }

  Widget _buildNoDevicesPlaceholder(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    return Container(
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
    );
  }

  Widget _buildDeviceGrid(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: devices.length,
      itemBuilder: (context, index) =>
          _buildDeviceCard(context, devices[index]),
    );
  }

  Widget _buildDeviceCard(BuildContext context, Device device) {
    final s = AppLocalizations.of(context)!;
    final isActive = device.state == true;
    final deviceColor = _getDeviceColor(device.type);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: isActive ? deviceColor.withOpacity(0.3) : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _toggleDevice(device.deviceId, !isActive),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: deviceColor.withOpacity(isActive ? 0.15 : 0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _getDeviceIcon(device.type),
                    size: 28,
                    color: isActive ? deviceColor : Colors.grey[600],
                  ),
                ),

                const SizedBox(width: 16),

                // Info & Monitoring
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Device Name & Status
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              device.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color:
                                    isActive ? Colors.black : Colors.grey[800],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Transform.scale(
                            scale: 1.2,
                            child: Switch.adaptive(
                              value: isActive,
                              onChanged: (value) =>
                                  _toggleDevice(device.deviceId, value),
                              activeColor: deviceColor,
                              activeTrackColor: deviceColor.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),
                      Text(
                        isActive ? s.activeStatus : s.inactiveStatus,
                        style: TextStyle(
                          fontSize: 13,
                          color: isActive ? deviceColor : Colors.grey[500],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Monitoring Data
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _buildMonitoringItem(
                                icon: Icons.thermostat_outlined,
                                value: device.temperature,
                                unit: '°C',
                                active: isActive,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildMonitoringItem(
                                icon: Icons.water_drop_outlined,
                                value: device.humidity,
                                unit: '%',
                                active: isActive,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonitoringItem({
    required IconData icon,
    required double? value,
    required String unit,
    required bool active,
  }) {
    final displayValue = value?.toStringAsFixed(1) ?? '-';
    final color = active ? Colors.blue[700]! : Colors.grey[600]!;

    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
            children: [
              TextSpan(text: displayValue),
              TextSpan(
                text: unit,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
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
              child: _buildSceneButton(
                context,
                s.allOff,
                Icons.power_off,
                Colors.red[400]!,
                () => _toggleAllDevices(false),
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
