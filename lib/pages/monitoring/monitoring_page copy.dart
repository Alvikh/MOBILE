import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:ta_mobile/l10n/app_localizations.dart';
import 'package:ta_mobile/models/device.dart';
import 'package:ta_mobile/models/user.dart';
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

  int currentDeviceIndex = 0;
  late List<Device> monitoringDevices;

  final Map<String, Map<String, List<double>>> chartData = {};
  final Map<String, Map<String, List<DateTime>>> timestamps = {};

  String selectedPeriod = 'Harian';
  final TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);

  @override
  void initState() {
    super.initState();

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
    }

    mqttService = MqttService(
      onMessageReceived: (data) {
        print('data: $data');
        print('MQTT Message received: ${data['id']} - ${data['measured_at']}');
        print(
            'compare data: ${data['id']} == ${monitoringDevices[currentDeviceIndex].deviceId}');
        if (monitoringDevices.isNotEmpty &&
            data['id'] == monitoringDevices[currentDeviceIndex].deviceId) {
          setState(() {
            final String measuredAt = data['measured_at'] ?? '';

            if (measuredAt.isNotEmpty) {
              try {
                final parts = measuredAt.split(' ');
                if (parts.length == 2) {
                  tanggal = parts[0];
                  waktu = parts[1].length >= 5
                      ? parts[1].substring(0, 5)
                      : parts[1];
                } else {
                  tanggal = '-';
                  waktu = '-';
                }
              } catch (e) {
                tanggal = '-';
                waktu = '-';
                debugPrint('Error parsing measured_at: $e');
              }
            } else {
              tanggal = '-';
              waktu = '-';
            }

            voltage = _formatDouble(data['voltage']) ?? '-';
            current = _formatDouble(data['current']) ?? '-';
            power = _formatDouble(data['power']) ?? '-';
            energy = _formatDouble(data['energy']) ?? '-';
            frequency = _formatDouble(data['frequency']) ?? '-';
            powerFactor = _formatDouble(data['power_factor']) ?? '-';
            temperature = _formatDouble(data['temperature']) ?? '-';
            humidity = _formatDouble(data['humidity']) ?? '-';

            _updateChartData(monitoringDevices[currentDeviceIndex].deviceId,
                'Voltage', double.tryParse(voltage));
            _updateChartData(monitoringDevices[currentDeviceIndex].deviceId,
                'Current', double.tryParse(current));
            _updateChartData(monitoringDevices[currentDeviceIndex].deviceId,
                'Power', double.tryParse(power));
            _updateChartData(monitoringDevices[currentDeviceIndex].deviceId,
                'Energy', double.tryParse(energy));
            _updateChartData(monitoringDevices[currentDeviceIndex].deviceId,
                'Frequency', double.tryParse(frequency));
            _updateChartData(monitoringDevices[currentDeviceIndex].deviceId,
                'Power Factor', double.tryParse(powerFactor));
            _updateChartData(monitoringDevices[currentDeviceIndex].deviceId,
                'Temperature', double.tryParse(temperature));
            _updateChartData(monitoringDevices[currentDeviceIndex].deviceId,
                'Humidity', double.tryParse(humidity));
          });
        }
      },
    );
  }

  void _updateChartData(String deviceId, String key, double? value) {
    if (value == null) return;
    final now = DateTime.now();

    final data = chartData[deviceId]![key]!;
    final timeData = timestamps[deviceId]![key]!;

    if (data.length >= 20) {
      data.removeAt(0);
      timeData.removeAt(0);
    }

    data.add(value);
    timeData.add(now);
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final bool hasMonitoringDevice = monitoringDevices.isNotEmpty;
    final totalMonitoringDevices = monitoringDevices.length;

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
                          _buildHeader(context),
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
                                      const SizedBox(height: 150),
                                      _buildPeriodDropdown(),
                                      const SizedBox(height: 20),
                                      _buildVoltageCurrentChart(context),
                                      const SizedBox(height: 20),
                                      _buildPowerEnergyChart(),
                                      const SizedBox(height: 20),
                                      _buildFrequencyPfRow(),
                                      const SizedBox(height: 20),
                                      _buildTempHumidityChart(),
                                    ],
                                  )
                                : Container(
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
                                  ),
                          ),
                        ],
                      ),
                      if (hasMonitoringDevice && totalMonitoringDevices < 2)
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.55 - 60,
                          child: _buildLiveDataScroll(),
                          right: 0,
                          left: 0,
                        )
                      else if (hasMonitoringDevice)
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.65 - 60,
                          child: _buildLiveDataScroll(),
                          right: 0,
                          left: 0,
                        )
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

  Widget _buildHeader(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    
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
    if (monitoringDevices.length <= 1) {
      return Container();
    }

    return Column(
      children: [
        Text(
          monitoringDevices[currentDeviceIndex].name,
          style: const TextStyle(
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A5099)),
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

  Widget _buildVoltageCurrentChart(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final deviceId = monitoringDevices[currentDeviceIndex].deviceId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.monitorChartVoltageCurrent,
          style: const TextStyle(
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
              title: AxisTitle(text: s.monitorMetricVoltage),
              intervalType: DateTimeIntervalType.minutes,
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(text: '${s.monitorMetricVoltage} (V)'),
              minimum: 200,
              maximum: 250,
            ),
            axes: [
              NumericAxis(
                name: 'currentAxis',
                title: AxisTitle(text: '${s.monitorMetricCurrent} (A)'),
                opposedPosition: true,
                minimum: 0,
                maximum: 10,
              )
            ],
            series: [
              LineSeries<ChartData, DateTime>(
                name: s.monitorMetricVoltage,
                dataSource: _getChartData(deviceId, 'Voltage'),
                xValueMapper: (data, _) => data.time,
                yValueMapper: (data, _) => data.value,
                color: const Color(0xFF0A5099),
                markerSettings: const MarkerSettings(isVisible: true),
              ),
              LineSeries<ChartData, DateTime>(
                name: s.monitorMetricCurrent,
                dataSource: _getChartData(deviceId, 'Current'),
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
    final deviceId = monitoringDevices[currentDeviceIndex].deviceId;

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
                dataSource: _getChartData(deviceId, 'Power'),
                xValueMapper: (data, _) => data.time,
                yValueMapper: (data, _) => data.value,
                color: Colors.green,
                markerSettings: const MarkerSettings(isVisible: true),
              ),
              ColumnSeries<ChartData, DateTime>(
                name: 'Energy',
                dataSource: _getChartData(deviceId, 'Energy'),
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
    final deviceId = monitoringDevices[currentDeviceIndex].deviceId;
    final currentFrequency =
        chartData[deviceId]?['Frequency']?.isNotEmpty ?? false
            ? chartData[deviceId]!['Frequency']!.last
            : 0;

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
                          value: currentFrequency.toDouble(),
                          enableAnimation: true,
                        ),
                      ],
                      annotations: [
                        GaugeAnnotation(
                          widget: Text(
                            'Frequency\n${currentFrequency.toStringAsFixed(1)} Hz',
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
                      dataSource: _getChartData(deviceId, 'Power Factor'),
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
    final deviceId = monitoringDevices[currentDeviceIndex].deviceId;

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
                dataSource: _getChartData(deviceId, 'Temperature'),
                xValueMapper: (data, _) => data.time,
                yValueMapper: (data, _) => data.value,
                color: Colors.red,
                markerSettings: const MarkerSettings(isVisible: true),
              ),
              LineSeries<ChartData, DateTime>(
                name: 'Humidity (%)',
                dataSource: _getChartData(deviceId, 'Humidity'),
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

  List<ChartData> _getChartData(String deviceId, String key) {
    final values = chartData[deviceId]?[key] ?? [];
    final times = timestamps[deviceId]?[key] ?? [];
    return List.generate(values.length, (index) {
      return ChartData(times[index], values[index]);
    });
  }

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
}

class ChartData {
  final DateTime time;
  final double value;

  ChartData(this.time, this.value);
}
