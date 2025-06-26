import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:ta_mobile/pages/device/add_device_page.dart';
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

  final Map<String, List<double>> chartData = {
    'Voltage': [],
    'Current': [],
    'Power': [],
    'Energy': [],
    'Frequency': [],
    'Power Factor': [],
    'Temperature': [],
    'Humidity': [],
  };

  final Map<String, List<DateTime>> timestamps = {
    'Voltage': [],
    'Current': [],
    'Power': [],
    'Energy': [],
    'Frequency': [],
    'Power Factor': [],
    'Temperature': [],
    'Humidity': [],
  };

  String selectedPeriod = 'Harian';
  final TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);

  void _updateChartData(String key, double? value) {
    if (value == null) return;
    final now = DateTime.now();

    final data = chartData[key]!;
    final timeData = timestamps[key]!;

    if (data.length >= 20) {
      data.removeAt(0);
      timeData.removeAt(0);
    }

    data.add(value);
    timeData.add(now);
  }

  @override
  void initState() {
    super.initState();
    mqttService = MqttService(
      broker: 'broker.hivemq.com', // Replace with your MQTT broker
      onMessageReceived: (data) {
        setState(() {
          tanggal = data['tanggal'] ?? '-';
          String fullWaktu = data['waktu'] ?? '-';
          waktu = fullWaktu.length >= 5 ? fullWaktu.substring(0, 5) : fullWaktu;

          voltage = data['tegangan']?.toString() ?? '-';
          current = data['arus']?.toString() ?? '-';
          power = data['daya']?.toString() ?? '-';
          energy = data['energi']?.toString() ?? '-';
          frequency = data['frequency']?.toString() ?? '-';
          powerFactor = data['power_factor']?.toString() ?? '-';
          temperature = data['suhu']?.toString() ?? '-';
          humidity = data['kelembapan']?.toString() ?? '-';

          _updateChartData('Voltage', double.tryParse(voltage));
          _updateChartData('Current', double.tryParse(current));
          _updateChartData('Power', double.tryParse(power));
          _updateChartData('Energy', double.tryParse(energy));
          _updateChartData('Frequency', double.tryParse(frequency));
          _updateChartData('Power Factor', double.tryParse(powerFactor));
          _updateChartData('Temperature', double.tryParse(temperature));
          _updateChartData('Humidity', double.tryParse(humidity));
        });
      },
    );
    mqttService.connect();
  }

  @override
  void dispose() {
    mqttService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A5099),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.only(bottom: 80), // Space for navbar
                  child: Stack(
                    children: [
                      // Stack(children: [_buildLiveDataScroll()]),
                      Column(
                        children: [
                          _buildHeader(),
                          Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Live Monitoring Data',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                _buildDateTimeCard(),
                                const SizedBox(height: 150),
                                _buildPeriodDropdown(),
                                const SizedBox(height: 20),
                                _buildVoltageCurrentChart(),
                                const SizedBox(height: 20),
                                _buildPowerEnergyChart(),
                                const SizedBox(height: 20),
                                _buildFrequencyPfRow(),
                                const SizedBox(height: 20),
                                _buildTempHumidityChart(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.55 - 60,
                        child: _buildLiveDataScroll(),
                        right: 0, // Adjust for navbar
                        left: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Floating Navbar positioned at bottom
          const CustomFloatingNavbar(selectedIndex: 1),
        ],
      ),
    );
  }

  // --------------------- Chart Widgets ---------------------
  Widget _buildVoltageCurrentChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Voltage & Current',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 250,
          child: SfCartesianChart(
            legend: Legend(isVisible: true, position: LegendPosition.top),
            tooltipBehavior: _tooltipBehavior,
            primaryXAxis: DateTimeAxis(
              title: AxisTitle(text: 'Time'),
              intervalType: DateTimeIntervalType.minutes,
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(text: 'Voltage (V)'),
              minimum: 200,
              maximum: 250,
            ),
            axes: [
              NumericAxis(
                name: 'currentAxis',
                title: AxisTitle(text: 'Current (A)'),
                opposedPosition: true,
                minimum: 0,
                maximum: 10,
              )
            ],
            series: [
              LineSeries<ChartData, DateTime>(
                name: 'Voltage',
                dataSource: _getChartData('Voltage'),
                xValueMapper: (data, _) => data.time,
                yValueMapper: (data, _) => data.value,
                color: const Color(0xFF0A5099),
                markerSettings: const MarkerSettings(isVisible: true),
              ),
              LineSeries<ChartData, DateTime>(
                name: 'Current',
                dataSource: _getChartData('Current'),
                xValueMapper: (data, _) => data.time,
                yValueMapper: (data, _) => data.value,
                color: Colors.red,
                yAxisName: 'currentAxis',
                markerSettings: const MarkerSettings(isVisible: true),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPowerEnergyChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Power & Energy',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 250,
          child: SfCartesianChart(
            legend: Legend(isVisible: true, position: LegendPosition.top),
            primaryXAxis: DateTimeAxis(title: AxisTitle(text: 'Time')),
            primaryYAxis: NumericAxis(title: AxisTitle(text: 'Power (W)')),
            series: [
              LineSeries<ChartData, DateTime>(
                name: 'Power',
                dataSource: _getChartData('Power'),
                xValueMapper: (data, _) => data.time,
                yValueMapper: (data, _) => data.value,
                color: Colors.green,
                markerSettings: const MarkerSettings(isVisible: true),
              ),
              ColumnSeries<ChartData, DateTime>(
                name: 'Energy',
                dataSource: _getChartData('Energy'),
                xValueMapper: (data, _) => data.time,
                yValueMapper: (data, _) => data.value,
                color: Colors.purple,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFrequencyPfRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Frequency & Power Factor',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: Row(
            children: [
              Expanded(
                child: SfRadialGauge(
                  axes: [
                    RadialAxis(
                      minimum: 49,
                      maximum: 51,
                      ranges: [
                        GaugeRange(
                          startValue: 49,
                          endValue: 50,
                          color: Colors.orange,
                        ),
                        GaugeRange(
                          startValue: 50,
                          endValue: 51,
                          color: Colors.green,
                        ),
                      ],
                      pointers: [
                        NeedlePointer(
                          value: chartData['Frequency']?.isNotEmpty ?? false
                              ? chartData['Frequency']!.last
                              : 0,
                          enableAnimation: true,
                        ),
                      ],
                      annotations: [
                        GaugeAnnotation(
                          widget: Text(
                            'Frequency\n${chartData['Frequency']?.isNotEmpty ?? false ? chartData['Frequency']!.last.toStringAsFixed(1) : '0'} Hz',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          positionFactor: 0.5,
                          angle: 90,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: DateTimeAxis(title: AxisTitle(text: 'Time')),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(text: 'Power Factor'),
                    minimum: 0,
                    maximum: 1,
                  ),
                  series: [
                    LineSeries<ChartData, DateTime>(
                      name: 'Power Factor',
                      dataSource: _getChartData('Power Factor'),
                      xValueMapper: (data, _) => data.time,
                      yValueMapper: (data, _) => data.value,
                      color: Colors.amber,
                      markerSettings: const MarkerSettings(isVisible: true),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTempHumidityChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Temperature & Humidity',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 250,
          child: SfCartesianChart(
            legend: Legend(isVisible: true, position: LegendPosition.top),
            primaryXAxis: DateTimeAxis(title: AxisTitle(text: 'Time')),
            primaryYAxis: NumericAxis(title: AxisTitle(text: 'Value')),
            series: [
              LineSeries<ChartData, DateTime>(
                name: 'Temperature (°C)',
                dataSource: _getChartData('Temperature'),
                xValueMapper: (data, _) => data.time,
                yValueMapper: (data, _) => data.value,
                color: Colors.red,
                markerSettings: const MarkerSettings(isVisible: true),
              ),
              LineSeries<ChartData, DateTime>(
                name: 'Humidity (%)',
                dataSource: _getChartData('Humidity'),
                xValueMapper: (data, _) => data.time,
                yValueMapper: (data, _) => data.value,
                color: Colors.blue,
                markerSettings: const MarkerSettings(isVisible: true),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<ChartData> _getChartData(String key) {
    final values = chartData[key] ?? [];
    final times = timestamps[key] ?? [];

    return List.generate(values.length, (index) {
      return ChartData(times[index], values[index]);
    });
  }

  // --------------------- UI Widgets ---------------------
  Widget _buildPeriodDropdown() {
    return Row(
      children: [
        const Text(
          'Prediction Option: ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(width: 10),
        DropdownButton<String>(
          value: selectedPeriod,
          items: ['Harian', 'Mingguan', 'Bulanan', 'Tahunan']
              .map((value) => DropdownMenuItem(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedPeriod = value;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildHeader() {
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
                  const Text(
                    'Monitor your electricity\nconsumption!',
                    style: TextStyle(
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
                    child: const Text(
                      'View Data History',
                      style: TextStyle(
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
                backgroundColor: Color(0xFF2196F3),
                shadowColor: Colors.transparent,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddDevicePage()),
                ).then((success) {
                  if (success == true) {
                    print("DEBUG: Device added successfully");
                  } else {
                    print("DEBUG: Add device cancelled or failed");
                  }
                });
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
      ),
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
          const SizedBox(width: 8), // Padding awal
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
          const SizedBox(width: 8), // Padding akhir
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
