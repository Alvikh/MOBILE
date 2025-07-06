import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:ta_mobile/l10n/app_localizations.dart';
import 'package:ta_mobile/models/device.dart';
import 'package:ta_mobile/models/user.dart';
import 'package:ta_mobile/pages/device/add_device_page.dart';
import 'package:ta_mobile/services/energy_analytic_service.dart';
import 'package:ta_mobile/services/mqtt_service.dart';
import 'package:ta_mobile/widgets/custom_floating_navbar.dart';

class MonitoringPage extends StatefulWidget {
  const MonitoringPage({Key? key}) : super(key: key);

  @override
  State<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  late MqttService mqttService;
  String tanggal = '-';
  String waktu = '-';
  String voltage = '-';
  String current = '-';
  String power = '-';
  String energy = '-';
  String frequency = '-';
  String powerFactor = '-';
  String temperature = '-';
  String humidity = '-';

  int currentDeviceIndex = 0;
  late List<Device> monitoringDevices;

  final Map<String, Map<String, List<double>>> chartData = {};
  final Map<String, Map<String, List<DateTime>>> timestamps = {};
  final Map<String, List<Map<String, dynamic>>> energyHistory = {};

  String selectedPeriod = 'Daily';
  final List<String> periodOptions = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
  final TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);

  @override
  void initState() {
    super.initState();
    _initializeData();
    _initializeMqttService();
    _generateSampleHistoryData();
  }

  void _initializeData() {
    monitoringDevices =
        User().devices.where((device) => device.type == 'monitoring').toList();

    for (var device in monitoringDevices) {
      chartData[device.deviceId] = {
        'Voltage': [],
        'Current': [],
        'Power': [],
        'Energy': [],
        'Frequency': [],
        'Power Factor': [],
        'Temperature': [],
        'Humidity': [],
      };

      timestamps[device.deviceId] = {
        'Voltage': [],
        'Current': [],
        'Power': [],
        'Energy': [],
        'Frequency': [],
        'Power Factor': [],
        'Temperature': [],
        'Humidity': [],
      };

      energyHistory[device.deviceId] = [];
    }
  }

  void _initializeMqttService() {
    mqttService = MqttService(
      onMessageReceived: (data) {
        if (monitoringDevices.isNotEmpty &&
            data['id'] == monitoringDevices[currentDeviceIndex].deviceId) {
          setState(() {
            _updateDateTime(data['measured_at']);
            _updateMetrics(data);
            _updateChartData();
          });
        }
      },
    );
  }

  void _updateDateTime(String? measuredAt) {
    if (measuredAt == null || measuredAt.isEmpty) {
      tanggal = '-';
      waktu = '-';
      return;
    }

    try {
      final parts = measuredAt.split(' ');
      if (parts.length == 2) {
        tanggal = parts[0];
        waktu = parts[1].length >= 5 ? parts[1].substring(0, 5) : parts[1];
      } else {
        tanggal = '-';
        waktu = '-';
      }
    } catch (e) {
      tanggal = '-';
      waktu = '-';
    }
  }

  void _updateMetrics(Map<String, dynamic> data) {
    voltage = _formatDouble(data['voltage']) ?? '-';
    current = _formatDouble(data['current']) ?? '-';
    power = _formatDouble(data['power']) ?? '-';
    energy = _formatDouble(data['energy']) ?? '-';
    frequency = _formatDouble(data['frequency']) ?? '-';
    powerFactor = _formatDouble(data['power_factor']) ?? '-';
    temperature = _formatDouble(data['temperature']) ?? '-';
    humidity = _formatDouble(data['humidity']) ?? '-';
  }

  void _updateChartData() {
    final deviceId = monitoringDevices[currentDeviceIndex].deviceId;
    final now = DateTime.now();

    void updateData(String key, String valueStr) {
      final value = double.tryParse(valueStr);
      if (value == null) return;

      final data = chartData[deviceId]![key]!;
      final timeData = timestamps[deviceId]![key]!;

      if (data.length >= 20) {
        data.removeAt(0);
        timeData.removeAt(0);
      }

      data.add(value);
      timeData.add(now);
    }

    updateData('Voltage', voltage);
    updateData('Current', current);
    updateData('Power', power);
    updateData('Energy', energy);
    updateData('Frequency', frequency);
    updateData('Power Factor', powerFactor);
    updateData('Temperature', temperature);
    updateData('Humidity', humidity);
  }

  void _generateSampleHistoryData() {
    final now = DateTime.now();
    final deviceId = monitoringDevices.isNotEmpty
        ? monitoringDevices[currentDeviceIndex].deviceId
        : '';

    if (deviceId.isEmpty) return;

    // Generate daily data for the past 7 days
    final List<Map<String, dynamic>> dailyData = [];
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      dailyData.add({
        'date': date,
        'energy': 30.0 + Random().nextDouble() * 20,
        'cost': (30.0 + Random().nextDouble() * 20) * 1444.70,
      });
    }

    // Generate weekly data for the past 4 weeks
    final List<Map<String, dynamic>> weeklyData = [];
    for (int i = 3; i >= 0; i--) {
      final startDate = now.subtract(Duration(days: 7 * (i + 1)));
      final endDate = now.subtract(Duration(days: 7 * i));
      weeklyData.add({
        'date': endDate,
        'energy': 210.0 + Random().nextDouble() * 140,
        'cost': (210.0 + Random().nextDouble() * 140) * 1444.70,
      });
    }

    // Generate monthly data for the past 6 months
    final List<Map<String, dynamic>> monthlyData = [];
    for (int i = 5; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i, 1);
      monthlyData.add({
        'date': date,
        'energy': 900.0 + Random().nextDouble() * 600,
        'cost': (900.0 + Random().nextDouble() * 600) * 1444.70,
      });
    }

    // Generate yearly data for the past 3 years
    final List<Map<String, dynamic>> yearlyData = [];
    for (int i = 2; i >= 0; i--) {
      final date = DateTime(now.year - i, 1, 1);
      yearlyData.add({
        'date': date,
        'energy': 10800.0 + Random().nextDouble() * 7200,
        'cost': (10800.0 + Random().nextDouble() * 7200) * 1444.70,
      });
    }

    energyHistory[deviceId] = [
      ...dailyData,
      ...weeklyData,
      ...monthlyData,
      ...yearlyData,
    ];
  }

  String? _formatDouble(dynamic value) {
    if (value == null) return null;
    final numValue = value is num ? value : double.tryParse(value.toString());
    if (numValue == null) return null;
    return numValue.toStringAsFixed(2);
  }

  @override
  void dispose() {
    mqttService.disconnect();
    super.dispose();
  }

  void _switchDevice(int index) {
    if (index >= 0 && index < monitoringDevices.length) {
      setState(() {
        currentDeviceIndex = index;
        _resetMetrics();
      });
    }
  }

  void _resetMetrics() {
    tanggal = '-';
    waktu = '-';
    voltage = '-';
    current = '-';
    power = '-';
    energy = '-';
    frequency = '-';
    powerFactor = '-';
    temperature = '-';
    humidity = '-';
  }

  Map<String, dynamic> _predictionData = {};
  bool _isLoadingPrediction = false;
  String _predictionError = '';
  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final bool hasMonitoringDevice = monitoringDevices.isNotEmpty;
    final totalMonitoringDevices = monitoringDevices.length;
      final EnergyAnalyticsService _energyAnalyticsService = EnergyAnalyticsService();
void _switchDevice(int index) {
  if (index >= 0 && index < monitoringDevices.length) {
    setState(() {
      currentDeviceIndex = index;
      _resetMetrics();
    });
    _fetchPredictionData(); // Add this line
  }
}
    return Scaffold(
      backgroundColor: const Color(0xFF0A5099),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          _buildHeader(s),
                          Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: hasMonitoringDevice
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildDeviceSwitcher(context),
                                      const SizedBox(height: 15),
                                      Text(
                                        s.monitorLiveTitle,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      _buildDateTimeCard(),
                                      const SizedBox(height: 15),
                                      _buildLiveDataScroll(),
                                      const SizedBox(height: 20),
                                      _buildPeriodDropdown(s),
                                      const SizedBox(height: 20),
                                      _buildEnergyUsageChart(),
                                      const SizedBox(height: 20),
                                      _buildEnergyHistorySection(s),
                                    ],
                                  )
                                : _buildNoDeviceCard(s),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const CustomFloatingNavbar(selectedIndex: 1),
        ],
      ),
    );
  }
Future<void> _fetchPredictionData() async {
  if (monitoringDevices.isEmpty) return;

  setState(() {
    _isLoadingPrediction = true;
    _predictionError = '';
  });

  try {
    final deviceId = monitoringDevices[currentDeviceIndex].deviceId;
    final response = await EnergyAnalyticsService().getPredictionData(monitoringDevices[currentDeviceIndex].id.toString());
    
    if (response['success'] == true) {
      setState(() {
        _predictionData = response['data'];
      });
    } else {
      setState(() {
        _predictionError = 'Failed to load prediction data';
      });
    }
  } catch (e) {
    setState(() {
      _predictionError = e.toString();
    });
  } finally {
    setState(() {
      _isLoadingPrediction = false;
    });
  }
}
Widget _buildPredictionSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 20),
      const Text(
        'Energy Prediction',
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          color: Color(0xFF0A5099),
        ),
      ),
      const SizedBox(height: 10),
      Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              if (_predictionData['plot_url'] != null)
                Image.network(
                  _predictionData['plot_url'],
                  height: 200,
                  fit: BoxFit.contain,
                ),
              const SizedBox(height: 15),
              _buildPredictionSummary(),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _buildPredictionSummary() {
  final aggregates = _predictionData['aggregates'] ?? {};
  
  return Column(
    children: [
      _buildPredictionRow(
        'Predicted Period',
        '${_predictionData['labels']?.first ?? ''} to ${_predictionData['labels']?.last ?? ''}'
      ),
      _buildPredictionRow(
        'Total Predicted Consumption',
        '${aggregates['total_energy']?.toStringAsFixed(2) ?? '0'} kWh'
      ),
      _buildPredictionRow(
        'Estimated Cost',
        'Rp${NumberFormat("#,###").format(aggregates['estimated_cost']?.toInt() ?? 0)}'
      ),
      _buildPredictionRow(
        'Average Daily Usage',
        '${aggregates['average_power']?.toStringAsFixed(2) ?? '0'} kWh'
      ),
      _buildPredictionRow(
        'Peak Power',
        '${aggregates['peak_power']?.toStringAsFixed(2) ?? '0'} kWh'
      ),
    ],
  );
}

Widget _buildPredictionRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
  Widget _buildHeader(AppLocalizations s) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(30),
        color: const Color(0xFF0A5099),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.monitorHeaderTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child: Text(
                      s.monitorHistoryButton,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(50, 50),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(0),
                backgroundColor: const Color(0xFF2196F3),
                shadowColor: Colors.transparent,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddDevicePage()),
                );
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceSwitcher(BuildContext context) {
    if (monitoringDevices.length <= 1) return Container();

    return Column(
      children: [
        Text(
          monitoringDevices[currentDeviceIndex].name,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Color(0xFF0A5099),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 20),
              onPressed: currentDeviceIndex > 0
                  ? () => _switchDevice(currentDeviceIndex - 1)
                  : null,
            ),
            Text(
              '${currentDeviceIndex + 1}/${monitoringDevices.length}',
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 20),
              onPressed: currentDeviceIndex < monitoringDevices.length - 1
                  ? () => _switchDevice(currentDeviceIndex + 1)
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPeriodDropdown(AppLocalizations s) {
    // Define both English and Indonesian options
    final periodOptions = {
      'Daily': 'Harian',
      'Weekly': 'Mingguan', 
      'Monthly': 'Bulanan',
      'Yearly': 'Tahunan'
    };

    // Convert selectedPeriod to English if it's in Indonesian
    final currentValue = periodOptions.entries
        .firstWhere(
          (entry) => entry.value == selectedPeriod,
          orElse: () => periodOptions.entries.firstWhere(
            (entry) => entry.key == selectedPeriod,
          ),
        )
        .key;

    return Row(
      children: [
        Text(
          '${s.monitorPredictionDropdownLabel} ',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(width: 10),
        DropdownButton<String>(
          value: currentValue,
          items: periodOptions.entries.map((entry) {
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Text(
                entry.value, // Display Indonesian text
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                // Store the Indonesian version
                selectedPeriod = periodOptions[newValue]!;
              });
            }
          },
        ),
      ],
    );
  }


  Widget _buildDateTimeCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, size: 20, color: Color(0xFF0A5099)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$tanggal : $waktu WIB',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveDataScroll() {
    final List<Map<String, dynamic>> dataList = [
      {'label': 'Voltage', 'value': '$voltage V', 'icon': Icons.bolt},
      {
        'label': 'Current',
        'value': '$current A',
        'icon': Icons.electrical_services
      },
      {'label': 'Power', 'value': '$power W', 'icon': Icons.power},
      {
        'label': 'Energy',
        'value': '$energy kWh',
        'icon': Icons.battery_charging_full
      },
      {
        'label': 'Frequency',
        'value': '$frequency Hz',
        'icon': Icons.multitrack_audio
      },
      {
        'label': 'Power Factor',
        'value': '$powerFactor VA',
        'icon': Icons.bar_chart
      },
      {'label': 'Temp', 'value': '$temperature °C', 'icon': Icons.thermostat},
      {'label': 'Humidity', 'value': '$humidity %', 'icon': Icons.water_drop},
    ];

    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(width: 8),
          ...dataList.map((item) {
            return Container(
              width: 120,
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F4F9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item['icon'] as IconData,
                      size: 28, color: const Color(0xFF0A5099)),
                  const SizedBox(height: 6),
                  Text(
                    item['label'].toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Color(0xFF0A5099),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['value'].toString(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildEnergyUsageChart() {
    final deviceId = monitoringDevices[currentDeviceIndex].deviceId;
    final filteredData = _getFilteredHistoryData(deviceId);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Energy Usage ($selectedPeriod)',
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A5099),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final date = filteredData[value.toInt()]['date'];
                          String label;
                          switch (selectedPeriod) {
                            case 'Daily':
                              label = DateFormat('EEE').format(date);
                              break;
                            case 'Weekly':
                              label = 'Week ${value.toInt() + 1}';
                              break;
                            case 'Monthly':
                              label = DateFormat('MMM').format(date);
                              break;
                            case 'Yearly':
                              label = DateFormat('yyyy').format(date);
                              break;
                            default:
                              label = '';
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              label,
                              style: const TextStyle(
                                fontSize: 10,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontFamily: 'Poppins',
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  minX: 0,
                  maxX: filteredData.length.toDouble() - 1,
                  minY: 0,
                  maxY: _getMaxEnergyValue(filteredData) * 1.2,
                  lineBarsData: [
                    LineChartBarData(
                      spots: filteredData.asMap().entries.map((e) {
                        return FlSpot(
                          e.key.toDouble(),
                          e.value['energy'].toDouble(),
                        );
                      }).toList(),
                      isCurved: true,
                      color: const Color(0xFF0A5099),
                      barWidth: 3,
                      belowBarData: BarAreaData(show: false),
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnergyHistorySection(AppLocalizations s) {
    final deviceId = monitoringDevices[currentDeviceIndex].deviceId;
    final filteredData = _getFilteredHistoryData(deviceId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Energy History ($selectedPeriod)',
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Color(0xFF0A5099),
          ),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Date',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Energy (kWh)',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Cost (IDR)',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...filteredData.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDate(entry['date']),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Text(
                          entry['energy'].toStringAsFixed(2),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Text(
                          NumberFormat("#,###").format(entry['cost'].toInt()),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getFilteredHistoryData(String deviceId) {
    final now = DateTime.now();
    final history = energyHistory[deviceId] ?? [];

    switch (selectedPeriod) {
      case 'Daily':
        return history
            .where((entry) =>
                entry['date'].isAfter(now.subtract(const Duration(days: 7))))
            .toList();
      case 'Weekly':
        return history
            .where((entry) =>
                entry['date'].isAfter(now.subtract(const Duration(days: 28))))
            .toList()
            .sublist(0, 4);
      case 'Monthly':
        return history
            .where((entry) =>
                entry['date'].isAfter(now.subtract(const Duration(days: 180))))
            .toList()
            .sublist(0, 6);
      case 'Yearly':
        return history
            .where((entry) =>
                entry['date'].isAfter(now.subtract(const Duration(days: 1095))))
            .toList()
            .sublist(0, 3);
      default:
        return [];
    }
  }

  double _getMaxEnergyValue(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return 100;
    return data
        .map((e) => e['energy'].toDouble())
        .reduce((a, b) => a > b ? a : b);
  }

  String _formatDate(DateTime date) {
    switch (selectedPeriod) {
      case 'Daily':
        return DateFormat('EEE, MMM d').format(date);
      case 'Weekly':
        return 'Week of ${DateFormat('MMM d').format(date)}';
      case 'Monthly':
        return DateFormat('MMMM yyyy').format(date);
      case 'Yearly':
        return DateFormat('yyyy').format(date);
      default:
        return DateFormat('MMM d, yyyy').format(date);
    }
  }

  Widget _buildNoDeviceCard(AppLocalizations s) {
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
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.blueGrey,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            s.monitorDeviceUnavailableTitle,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            s.monitorDeviceUnavailableDesc,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final DateTime time;
  final double value;

  ChartData(this.time, this.value);
}