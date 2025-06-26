import 'package:flutter/material.dart';
import 'package:ta_mobile/services/mqtt_service.dart';
import 'package:ta_mobile/widgets/custom_floating_navbar.dart';

class ControllingPage extends StatefulWidget {
  const ControllingPage({Key? key}) : super(key: key);

  @override
  State<ControllingPage> createState() => _ControllingPageState();
}

class _ControllingPageState extends State<ControllingPage> {
  late MqttService mqttService;
  final List<Map<String, dynamic>> devices = [
    {
      'id': 'device1',
      'name': 'Lampu Ruang Tamu',
      'status': false,
      'icon': Icons.lightbulb_outline,
      'color': Colors.amber,
    },
    {
      'id': 'device2',
      'name': 'AC Kamar',
      'status': false,
      'icon': Icons.ac_unit,
      'color': Colors.blue,
    },
    {
      'id': 'device3',
      'name': 'Kulkas',
      'status': true,
      'icon': Icons.kitchen,
      'color': Colors.teal,
    },
    {
      'id': 'device4',
      'name': 'TV',
      'status': false,
      'icon': Icons.tv,
      'color': Colors.purple,
    },
    {
      'id': 'device5',
      'name': 'Pompa Air',
      'status': false,
      'icon': Icons.water,
      'color': Colors.lightBlue,
    },
    {
      'id': 'device6',
      'name': 'Kipas Angin',
      'status': false,
      'icon': Icons.air,
      'color': Colors.green,
    },
  ];

  @override
  void initState() {
    super.initState();
    mqttService = MqttService(broker: 'broker.hivemq.com');
    mqttService.connect();
  }

  @override
  void dispose() {
    mqttService.disconnect();
    super.dispose();
  }

  void _toggleDevice(String deviceId, bool status) {
    mqttService.publish(
      'control/$deviceId',
      {'command': status ? 'on' : 'off'},
    );
    setState(() {
      devices.firstWhere((d) => d['id'] == deviceId)['status'] = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeDevices = devices.where((d) => d['status'] == true).length;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Stack(children: [
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
                            _buildDeviceGrid(),
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
        ]),
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
        childAspectRatio: 1,
      ),
      itemCount: devices.length,
      itemBuilder: (context, index) => _buildDeviceCard(devices[index]),
    );
  }

  Widget _buildDeviceCard(Map<String, dynamic> device) {
    final isActive = device['status'] as bool;
    final color = device['color'] as Color;

    return Card(
      elevation: isActive ? 4 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color:
              isActive ? color.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _toggleDevice(device['id'], !isActive),
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
                      color: color.withOpacity(isActive ? 0.2 : 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      device['icon'] as IconData,
                      size: 24,
                      color: isActive ? color : Colors.grey[400],
                    ),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: isActive,
                      onChanged: (value) => _toggleDevice(device['id'], value),
                      activeColor: color,
                      activeTrackColor: color.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device['name'],
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
                      color: isActive ? color : Colors.grey[400],
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
      _toggleDevice(device['id'], status);
    }
  }

  void _activateNightMode() {
    for (var device in devices) {
      if (device['name'].toString().contains('Lampu')) {
        _toggleDevice(device['id'], false);
      } else if (device['name'].toString().contains('AC')) {
        _toggleDevice(device['id'], true);
      }
    }
  }
}
