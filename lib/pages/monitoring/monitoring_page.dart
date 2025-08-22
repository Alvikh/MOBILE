import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:ta_mobile/data/device_data_provider.dart';
import 'package:ta_mobile/l10n/app_localizations.dart';
import 'package:ta_mobile/models/device.dart';
import 'package:ta_mobile/models/user.dart';
import 'package:ta_mobile/pages/device/add_device_page.dart';
import 'package:ta_mobile/pages/partial/energy_comsumption_page.dart';
import 'package:ta_mobile/services/energy_analytic_service.dart';
import 'package:ta_mobile/services/mqtt_service.dart';

class MonitoringPage extends ConsumerStatefulWidget {
  const MonitoringPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MonitoringPage> createState() => _MonitoringPageState();
}

// Helper class for chart data
class ChartData {
  final String label;
  final double value;

  ChartData({required this.label, required this.value});
}

class _MonitoringPageState extends ConsumerState<MonitoringPage> {
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
  bool _showLoadingPopup = false;
  bool _showErrorPopup = false;

  final Map<String, Map<String, List<double>>> chartData = {};
  final Map<String, Map<String, List<DateTime>>> timestamps = {};
  final Map<String, List<Map<String, dynamic>>> energyHistory = {};
  final Map<String, Map<String, dynamic>> deviceEnergyHistory = {};
  final Map<String, List<Map<String, dynamic>>> deviceEnergyRecords = {};

  String selectedPeriod = 'Daily';
  final TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);

  // Analytics service and data
  final EnergyAnalyticsService _energyAnalyticsService = EnergyAnalyticsService();
  Map<String, dynamic> _metrics = {};
  Map<String, dynamic> _deviceData = {};
  Map<String, dynamic> _consumptionHistory = {};
  Map<String, dynamic> _predictionData = {};
  Map<String, dynamic> _energyHistory = {};
  List<Map<String, dynamic>> _dailyConsumption = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
    _initializeMqttService();
    _fetchInitialData();
  }

  void _initializeData() {
    monitoringDevices =
        User().devices.where((device) => device.type == 'monitoring').toList();
    if (monitoringDevices.isEmpty) {
      return;
    }
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
    if (!mqttService.isConnected) {
      mqttService.connect();
    }
  }

  Future<void> _fetchInitialData() async {
    if (monitoringDevices.isEmpty) return;

    setState(() {
      _isLoading = true;
      _showLoadingPopup = true;
      _errorMessage = '';
      _showErrorPopup = false;
    });

    try {
      final deviceId = monitoringDevices[currentDeviceIndex].deviceId;
      final id = monitoringDevices[currentDeviceIndex].id;

      // Check if data already exists in provider
      final existingData = ref.read(deviceDataProvider);

      Map<String, dynamic> results;

      if (existingData.isNotEmpty) {
        results = existingData; // Use from provider
      } else {
        results = await _energyAnalyticsService.getDeviceData(id!);
        ref.read(deviceDataProvider.notifier).updateDeviceData(results);
      }

      // Process data to UI
      setState(() {
        _deviceData = results['data']['device'];
        _consumptionHistory = results['data']['consumption'];
        _predictionData = results['data']['prediction'] ?? {};
        _energyHistory = results['data']['energy_history'] ?? {};
        _metrics = results['data']['metrics'] ?? {};

        // Process energy history
        if (_energyHistory != null) {
          final historyData = _energyHistory;
          final labels = historyData['labels'] as List;
          final data = historyData['data'] as List;

          deviceEnergyHistory[deviceId] = {
            'labels': List<String>.from(labels),
            'data': List<double>.from(data.map((v) => double.tryParse(v.toString()) ?? 0.0)),
            'cost_data': List<String>.from(data.map((v) {
              final energy = double.tryParse(v.toString()) ?? 0.0;
              final costValue = energy * 1444.70 / 1000;
              return costValue.toString();
            })),
            'cost_values': List<double>.from(data.map((v) {
              final energy = double.tryParse(v.toString()) ?? 0.0;
              return energy * 1444.70 / 1000;
            })),
          };

          deviceEnergyRecords[deviceId] = List<Map<String, dynamic>>.generate(
            labels.length,
            (index) {
              final energyValue = double.tryParse(data[index].toString()) ?? 0.0;
              return {
                'date': labels[index],
                'energy': energyValue / 1000,
                'cost': energyValue * 1444.70 / 1000,
              };
            },
          );
        }

        // Process daily consumption
        if (_consumptionHistory['daily'] != null) {
          final daily = _consumptionHistory['daily'];
          final dailyLabels = daily['labels'] as List<dynamic>;
          final dailyData = daily['data'] as List<dynamic>;

          _dailyConsumption = List<Map<String, dynamic>>.generate(
            dailyLabels.length,
            (index) => {
              'date': _parseCustomDate(dailyLabels[index].toString()),
              'energy': dailyData[index] is num ? dailyData[index].toDouble() : 0.0,
            },
          );
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data: $e';
        _showErrorPopup = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
        _showLoadingPopup = false;
      });
    }
  }

  int _getMonthNumber(String monthAbbr) {
    const months = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12
    };
    return months[monthAbbr] ?? DateTime.now().month;
  }

  DateTime _parseCustomDate(String dateStr) {
    try {
      final parts = dateStr.trim().split(' ');
      if (parts.length != 2) {
        throw FormatException('Invalid format: $dateStr');
      }

      final month = _getMonthNumber(parts[0]);
      final day = int.tryParse(parts[1]) ?? 1;
      final year = DateTime.now().year;

      return DateTime(year, month, day);
    } catch (e) {
      return DateTime.now();
    }
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

  String? _formatDouble(dynamic value) {
    if (value == null) return null;
    final numValue = value is num ? value : double.tryParse(value.toString());
    if (numValue == null) return null;
    return numValue.toStringAsFixed(2);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _switchDevice(int index) {
    if (index >= 0 && index < monitoringDevices.length) {
      setState(() {
        currentDeviceIndex = index;
        _resetMetrics();
      });
      _fetchInitialData();
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

  Widget _buildPredictionSection() {
    final s = AppLocalizations.of(context)!;

    if (_predictionData == null ||
        _predictionData!['daily_predictions'] == null ||
        _predictionData!['monthly_predictions'] == null ||
        _predictionData!['yearly_predictions'] == null) {
      return Container(
        padding: EdgeInsets.all(16),
        child: Text(
          s.predictionDataNotAvailable,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final dailyPredictions =
        List<dynamic>.from(_predictionData!['daily_predictions'] ?? []);
    final monthlyPredictions =
        List<dynamic>.from(_predictionData!['monthly_predictions'] ?? []);
    final yearlyPredictions =
        List<dynamic>.from(_predictionData!['yearly_predictions'] ?? []);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            s.energyPrediction,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A5099),
            ),
          ),
          SizedBox(height: 10),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  if (dailyPredictions.isNotEmpty) ...[
                    _buildPredictionTable(
                      context: context,
                      title: s.dailyPrediction,
                      data: dailyPredictions.take(7).toList(),
                      columns: [
                        'period',
                        'average_power_w',
                        'total_energy_kwh',
                        'estimated_cost'
                      ],
                      headers: [
                        s.date,
                        s.averagePowerW,
                        s.totalEnergyKwh,
                        s.estimatedCost
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                  if (monthlyPredictions.isNotEmpty) ...[
                    _buildPredictionTable(
                      context: context,
                      title: s.monthlyPrediction,
                      data: monthlyPredictions,
                      columns: [
                        'period',
                        'average_power_w',
                        'total_energy_kwh',
                        'estimated_cost'
                      ],
                      headers: [
                        s.month,
                        s.averagePowerW,
                        s.totalEnergyKwh,
                        s.estimatedCost
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                  if (yearlyPredictions.isNotEmpty) ...[
                    _buildPredictionTable(
                      context: context,
                      title: s.yearlyPrediction,
                      data: yearlyPredictions,
                      columns: [
                        'period',
                        'average_power_w',
                        'total_energy_kwh',
                        'estimated_cost'
                      ],
                      headers: [
                        s.year,
                        s.averagePowerW,
                        s.totalEnergyKwh,
                        s.estimatedCost
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionTable({
    required BuildContext context,
    required String title,
    required List<dynamic> data,
    required List<String> columns,
    required List<String> headers,
  }) {
    final s = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    String formatCurrency(num value) {
      final formattedAmount = NumberFormat("#,##0", locale.toString()).format(value);
      
      if (s.currencyFormat.contains('amount')) {
        return s.currencyFormat
          .replaceAll('amount', formattedAmount)
          .replaceAll(r'\$', '\$');
      }
      
      return '\$$formattedAmount';
    }
    
    String formatDecimal(num value) {
      return s.decimalFormat.replaceAll('value', value.toStringAsFixed(2));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0A5099),
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 20,
            columns: headers
                .map((header) => DataColumn(
                      label: Text(
                        header,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ))
                .toList(),
            rows: data.map<DataRow>((item) {
              return DataRow(
                cells: columns.map<DataCell>((col) {
                  final value = item[col];
                  String displayText = s.defaultDisplayText;

                  if (value != null) {
                    if (col == 'estimated_cost') {
                      displayText = formatCurrency(value.toInt());
                    } else if (value is num) {
                      displayText = formatDecimal(value);
                    } else {
                      displayText = value.toString();
                    }
                  }

                  return DataCell(Text(displayText));
                }).toList(),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final bool hasMonitoringDevice = monitoringDevices.isNotEmpty;

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
                          hasMonitoringDevice
                              ? _buildHeader(
                                  s,
                                  (monitoringDevices[currentDeviceIndex].id)
                                      .toString())
                              : _buildHeader(s, ""),
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
                                      if (_isLoading)
                                        const Center(
                                            child: CircularProgressIndicator()),
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
                                      const SizedBox(height: 160),
                                      _buildEnergyUsageChart(context),
                                      const SizedBox(height: 20),
                                      _buildEnergyHistorySection(s, context),
                                      const SizedBox(height: 20),
                                      _buildPredictionSection(),
                                    ],
                                  )
                                : _buildNoDeviceCard(s),
                          ),
                        ],
                      ),
                      if (hasMonitoringDevice)
                        (monitoringDevices.length <= 2)
                            ? Positioned(
                                top: MediaQuery.of(context).size.height / 2 - 40,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 130,
                                  child: _buildLiveDataScroll(context),
                                ),
                              )
                            : Positioned(
                                top: MediaQuery.of(context).size.height / 2 - 10,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 130,
                                  child: _buildLiveDataScroll(context),
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
    );
  }

  Widget _buildHeader(AppLocalizations s, String id) {
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EnergyConsumptionPage(
                                  deviceId: id,
                                )),
                      );
                    },
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
                  MaterialPageRoute(builder: (context) => const AddDevicePage()),
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

  Widget _buildDateTimeCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_rounded,
              size: 20, color: Color(0xFF0A5099)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$tanggal : $waktu WIB',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: Color(0xFF1F2937),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveDataScroll(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    
    final List<Map<String, dynamic>> dataList = [
      {
        'label': s.voltage,
        'value': '$voltage ${s.voltageUnit}',
        'icon': Icons.bolt
      },
      {
        'label': s.current,
        'value': '$current ${s.currentUnit}',
        'icon': Icons.electrical_services
      },
      {
        'label': s.power,
        'value': '$power ${s.powerUnit}',
        'icon': Icons.power
      },
      {
        'label': s.energy,
        'value': '$energy ${s.energyUnit}',
        'icon': Icons.battery_charging_full
      },
      {
        'label': s.frequency,
        'value': '$frequency ${s.frequencyUnit}',
        'icon': Icons.multitrack_audio
      },
      {
        'label': s.powerFactor,
        'value': '$powerFactor ${s.powerFactorUnit}',
        'icon': Icons.bar_chart
      },
      {
        'label': s.temperature,
        'value': '$temperature ${s.temperatureUnit}',
        'icon': Icons.thermostat
      },
      {
        'label': s.humidity,
        'value': '$humidity ${s.humidityUnit}',
        'icon': Icons.water_drop
      },
    ];

    return Container(
      height: 135,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(width: 16),
          ...dataList.map((item) {
            return Container(
              width: 125,
              height: 125,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item['icon'] as IconData,
                      size: 30, color: const Color(0xFF0A5099)),
                  const SizedBox(height: 8),
                  Text(
                    item['label'].toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Color(0xFF0A5099),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['value'].toString(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      color: Color(0xFF1F2937),
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

  Widget _buildEnergyUsageChart(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final deviceId = monitoringDevices[currentDeviceIndex].deviceId;
    final energyData = deviceEnergyHistory[deviceId] ?? {'labels': [], 'data': []};
    final labels = (energyData['labels'] as List).cast<String>();
    final dataValues = (energyData['data'] as List).map((v) => double.tryParse(v.toString()) ?? 0.0).toList();

    final List<ChartData> chartData = List.generate(
      labels.length,
      (index) => ChartData(
        label: labels[index],
        value: index < dataValues.length ? dataValues[index] / 1000 : 0.0,
      ),
    );

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
              '${s.energyUsage} ($selectedPeriod)',
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
              child: SfCartesianChart(
                tooltipBehavior: _tooltipBehavior,
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(text: s.energyAxisLabel),
                  numberFormat: NumberFormat.compact(),
                ),
                series: <CartesianSeries<ChartData, String>>[
                  ColumnSeries<ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.label,
                    yValueMapper: (ChartData data, _) => data.value,
                    name: s.energySeriesName,
                    color: const Color(0xFF0A5099),
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.outer,
                    ),
                    markerSettings: const MarkerSettings(isVisible: true),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (_metrics.isNotEmpty) _buildUsageMetrics(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageMetrics(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildMetricTile(
          s.avgDaily,
          '${(_metrics['avg_daily_energy'] as num?)?.toStringAsFixed(2) ?? '0.00'} ${s.kilowatt}',
        ),
        _buildMetricTile(
          s.peakToday,
          '${(_metrics['peak_power'] as num?)?.toStringAsFixed(2) ?? '0.00'} ${s.kilowatt}',
        ),
        _buildMetricTile(
          s.energyToday,
          '${((_metrics['total_energy'] ?? 0) / 1000).toStringAsFixed(2)} ${s.kilowattHour}',
        ),
      ],
    );
  }

  Widget _buildMetricTile(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEnergyHistorySection(AppLocalizations s, BuildContext context) {
    final deviceId = monitoringDevices[currentDeviceIndex].deviceId;
    final energyData = deviceEnergyRecords[deviceId] ?? [];
    final locale = Localizations.localeOf(context);
    final currencyFormat = NumberFormat.currency(
      locale: locale.toString(),
      symbol: s.currencySymbol,
      decimalDigits: 2,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${s.energyHistory} ($selectedPeriod)',
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Date',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Energy (kWh)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Cost',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                
                if (energyData.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'No data available',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                else
                  ...energyData.map((entry) {
                    final cost = entry['cost'] as double;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              entry['date'].toString(),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              (entry['energy'] as double).toStringAsFixed(2),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              currencyFormat.format(cost),
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                              ),
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