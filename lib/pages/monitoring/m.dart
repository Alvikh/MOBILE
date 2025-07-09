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

  final EnergyAnalyticsService _energyAnalyticsService = EnergyAnalyticsService();
  Map<String, dynamic> _deviceData = {};
  Map<String, dynamic> _consumptionHistory = {};
  Map<String, dynamic> _predictionData = {};
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isConnected = false;

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
      if (!mounted) return;

      final currentDevice = monitoringDevices.isNotEmpty
          ? monitoringDevices[currentDeviceIndex]
          : null;

      if (currentDevice != null && data['id'] == currentDevice.deviceId) {
        setState(() {
          _updateDateTime(data['measured_at']);
          _updateMetrics(data);
          _updateChartData();
        });
      }
    },
  );
}


  Future<void> _fetchInitialData() async {
    if (monitoringDevices.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final deviceId = monitoringDevices[currentDeviceIndex].deviceId;
      final id = monitoringDevices[currentDeviceIndex].id;
      
      final results = await Future.wait([
        _energyAnalyticsService.getDeviceData(id!),
        _energyAnalyticsService.getConsumptionHistory(id),
        _energyAnalyticsService.getPredictionData(id),
      ]);
      
      setState(() {
        _deviceData = results[0]['data'];
        _consumptionHistory = results[1]['data'];
        _predictionData = results[2]['data'];
        print("\n\n prediction data = $_predictionData");
        if (_consumptionHistory['records'] != null) {
          energyHistory[deviceId] = List<Map<String, dynamic>>.from(
            _consumptionHistory['records'].map((record) => {
              'date': DateTime.parse(record['date']),
              'energy': record['total_energy']?.toDouble() ?? 0.0,
              'cost': (record['total_energy']?.toDouble() ?? 0.0) * 1444.70,
            })
          );
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
  // ... (keep existing helper methods like _updateDateTime, _updateMetrics, etc.)

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final bool hasMonitoringDevice = monitoringDevices.isNotEmpty;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A5099),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Column(
                    children: [
                      _buildHeader(s),
                      if (hasMonitoringDevice) _buildConnectionStatus(),
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: hasMonitoringDevice
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildDeviceInfoSection(),
                                  const SizedBox(height: 20),
                                  _buildRealTimeMetricsSection(),
                                  const SizedBox(height: 20),
                                  _buildConsumptionChartSection(),
                                  const SizedBox(height: 20),
                                  _buildEnergyHistorySection(),
                                  const SizedBox(height: 20),
                                  _buildPredictionSection(),
                                ],
                              )
                            : _buildNoDeviceCard(s),
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

 Widget _buildHeader(AppLocalizations s) {
  return SafeArea(
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF0A5099),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.monitorHeaderTitle,
            style: const TextStyle(
              fontSize: 24,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Detailed analytics for ${monitoringDevices.isNotEmpty ? monitoringDevices[currentDeviceIndex].name : "device"}',
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              color: Colors.white70,
            ),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildConnectionStatus() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: _isConnected ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _isConnected ? 'Connected' : 'Disconnected',
            style: TextStyle(
              color: _isConnected ? Colors.green : Colors.red,
              fontSize: 12,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceInfoSection() {
  if (monitoringDevices.isEmpty) return Container();
  
  final device = monitoringDevices[currentDeviceIndex];
  
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0A5099), Color(0xFF2196F3)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: Row(
            children: const [
              Icon(Icons.info, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Device Information',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              _buildInfoCard('Device ID', device.deviceId, Colors.blue),
              _buildInfoCard('Type', device.type, Colors.green),
              _buildInfoCard('Building', device.building, Colors.orange),
              _buildInfoCard('Status', device.status,
                device.status == 'active' ? Colors.green : Colors.red),
            ],
          ),
        ),
      ],
    ),
  );
}


  Widget _buildInfoCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRealTimeMetricsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A5099), Color(0xFF2196F3)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Row(
              children: const [
                Icon(Icons.speed, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Real-time Metrics',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDateTimeCard(),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    _buildMetricCard('Voltage', '$voltage V', Icons.bolt, Colors.blue),
                    _buildMetricCard('Current', '$current A', Icons.electric_bolt, Colors.green),
                    _buildMetricCard('Power', '$power W', Icons.power, Colors.orange),
                    _buildMetricCard('Energy', '$energy kWh', Icons.battery_charging_full, Colors.purple),
                    _buildMetricCard('Frequency', '$frequency Hz', Icons.waves, Colors.indigo),
                    _buildMetricCard('Power Factor', powerFactor, Icons.bar_chart, Colors.red),
                    _buildMetricCard('Temperature', '$temperature °C', Icons.thermostat, Colors.yellow[700]!),
                    _buildMetricCard('Humidity', '$humidity%', Icons.water_drop, Colors.teal),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConsumptionChartSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A5099), Color(0xFF2196F3)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Row(
              children: const [
                Icon(Icons.bar_chart, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Electricity Consumption',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  height: 250,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(title: AxisTitle(text: 'Power (W)')),
                    series: <CartesianSeries>[
                      LineSeries<double, String>(
                        dataSource: chartData[monitoringDevices[currentDeviceIndex].deviceId]!['Power']!,
                        xValueMapper: (_, index) => index.toString(),
                        yValueMapper: (value, _) => value,
                        name: 'Power',
                        color: const Color(0xFF0A5099),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildConsumptionMetric('Current Usage', '$power W', Icons.bolt, Colors.blue),
                    _buildConsumptionMetric('Avg. Daily', '${_deviceData['avg_daily'] ?? '0'} W', Icons.trending_down, Colors.green),
                    _buildConsumptionMetric('Peak Today', '${_deviceData['peak_today'] ?? '0'} W', Icons.trending_up, Colors.orange),
                    _buildConsumptionMetric('Energy Today', '${_deviceData['energy_today'] ?? '0'} kWh', Icons.energy_savings_leaf, Colors.purple),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsumptionMetric(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: color,
            fontFamily: 'Poppins',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildEnergyHistorySection() {
    final deviceId = monitoringDevices[currentDeviceIndex].deviceId;
    final filteredData = _getFilteredHistoryData(deviceId);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A5099), Color(0xFF2196F3)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Row(
              children: const [
                Icon(Icons.history, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Energy Usage History',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  height: 250,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(title: AxisTitle(text: 'Energy (kWh)')),
                    series: <CartesianSeries>[
                      ColumnSeries<Map<String, dynamic>, String>(
                        dataSource: filteredData,
                        xValueMapper: (data, _) => _formatDate(data['date']),
                        yValueMapper: (data, _) => data['energy'],
                        name: 'Energy',
                        color: const Color(0xFF4F46E5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Energy (kWh)', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Cost (IDR)', style: TextStyle(fontWeight: FontWeight.bold))),],
rows: filteredData.map((entry) {
                      return DataRow(cells: [
                        DataCell(Text(_formatDate(entry['date']))),
                        DataCell(Text(entry['energy'].toStringAsFixed(2))),
                        DataCell(Text(NumberFormat("#,###").format(entry['cost'].toInt()))),
                      ]);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionSection() {
    if (_predictionData.isEmpty) return Container();

    final dailyPredictions = _predictionData['daily_predictions'] ?? [];
    final totalKwh = dailyPredictions.fold(0.0, (sum, item) => sum + (item['total_energy_kwh'] ?? 0.0));
    final avgDaily = totalKwh / (dailyPredictions.isNotEmpty ? dailyPredictions.length : 1);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A5099), Color(0xFF2196F3)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Row(
              children: const [
                Icon(Icons.timeline, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Energy Consumption Prediction',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Prediction Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0A5099),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    _buildPredictionCard(
                      'Prediction Period',
                      '${_formatDate(DateTime.parse(_predictionData['start_date']))} to ${_formatDate(DateTime.parse(dailyPredictions.last['period']))}',
                      Icons.calendar_today,
                    ),
                    _buildPredictionCard(
                      'Total Predicted',
                      '${totalKwh.toStringAsFixed(2)} kWh',
                      Icons.bolt,
                    ),
                    _buildPredictionCard(
                      'Estimated Cost',
                      'Rp${NumberFormat("#,###").format((totalKwh * 1444.70).toInt())}',
                      Icons.attach_money,
                    ),
                    _buildPredictionCard(
                      'Avg Daily Usage',
                      '${avgDaily.toStringAsFixed(2)} kWh/day',
                      Icons.trending_up,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Daily Predictions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0A5099),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Avg Power (W)', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Energy (kWh)', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Estimated Cost', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: dailyPredictions.take(7).map((prediction) {
                      return DataRow(cells: [
                        DataCell(Text(prediction['period'])),
                        DataCell(Text(prediction['average_power_w'].toStringAsFixed(2))),
                        DataCell(Text(prediction['total_energy_kwh'].toStringAsFixed(2))),
                        DataCell(Text('Rp${NumberFormat("#,###").format(prediction['estimated_cost'].toInt())}')),
                      ]);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
  // ... (keep existing helper methods like _formatDate, _getFilteredHistoryData, etc.)

  Widget _buildNoDeviceCard(AppLocalizations s) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
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
            Icons.warning_amber,
            color: Colors.blueGrey,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            s.monitorDeviceUnavailableTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
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
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddDevicePage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A5099),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Add Device',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}