import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ta_mobile/l10n/app_localizations.dart';
import 'package:ta_mobile/services/energy_analytic_service.dart';

class EnergyConsumptionPage extends StatefulWidget {
  final String deviceId;
  const EnergyConsumptionPage({Key? key, required this.deviceId}) : super(key: key);

  @override
  _EnergyConsumptionPageState createState() => _EnergyConsumptionPageState();
}

class _EnergyConsumptionPageState extends State<EnergyConsumptionPage> {
  late DateFormat timeFormat;
  bool isLoading = true;
  DateTimeRange? dateRange;
  final EnergyAnalyticsService _energyService = EnergyAnalyticsService();
  
  Map<String, dynamic> consumptionData = {};
  List<String> timeLabels = [];
  List<double> powerValues = [];
  Map<String, dynamic> metrics = {};
  String unit = 'kW';

  @override
  void initState() {
    super.initState();
    timeFormat = DateFormat('HH:mm');
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => isLoading = true);
    try {
      final response = await _energyService.getDataHistory(
        widget.deviceId,
        startDate: dateRange?.start ?? DateTime.now().subtract(const Duration(days: 7)),
        endDate: dateRange?.end ?? DateTime.now(),
        interval: 'hourly',
      );

      if (response['success'] == true) {
        setState(() {
          consumptionData = response['data']['data'] ?? {};
          timeLabels = List<String>.from(consumptionData['labels'] ?? []);
          powerValues = List<double>.from(consumptionData['data']?.map((v) => v.toDouble()) ?? []);
          metrics = response['data']['metrics'] ?? {};
          unit = consumptionData['unit'] ?? 'kW';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppLocalizations.of(context)!.dataLoadFailed}: ${e.toString()}')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: dateRange ??
          DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 7)),
            end: DateTime.now(),
          ),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0A5099),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        dateRange = DateTimeRange(
          start: DateTime(picked.start.year, picked.start.month, picked.start.day, 0, 0, 0),
          end: DateTime(picked.end.year, picked.end.month, picked.end.day, 23, 59, 59),
        );
      });
      await _loadInitialData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    children: [
                      _buildHeader(context),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitleRow(s),
                            const SizedBox(height: 20),
                            _buildFilterRow(context, s),
                            const SizedBox(height: 20),
                            _buildMetricsCards(s),
                            const SizedBox(height: 20),
                            isLoading
                                ? _buildLoadingIndicator(s)
                                : timeLabels.isEmpty
                                    ? _buildEmptyState(context, s)
                                    : _buildConsumptionChart(s),
                            const SizedBox(height: 20),
                            _buildDataTable(s),
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
    );
  }

  Widget _buildHeader(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 40, 25, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A5099), Color(0xFF1A73E8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                s.energyConsumption,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: _loadInitialData,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            s.energyConsumptionDescription,
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

  Widget _buildTitleRow(AppLocalizations s) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            s.energyConsumptionData,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF0A5099).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.bolt, size: 16, color: Color(0xFF0A5099)),
              const SizedBox(width: 6),
              Text(
                "${timeLabels.length} ${s.hours}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0A5099),
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterRow(BuildContext context, AppLocalizations s) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.calendar_today, size: 20),
                label: Text(
                  dateRange != null
                      ? '${DateFormat('dd MMM yyyy').format(dateRange!.start)} - ${DateFormat('dd MMM yyyy').format(dateRange!.end)}'
                      : s.selectDateRange,
                  style: const TextStyle(fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF0A5099),
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                  elevation: 0,
                ),
                onPressed: () => _selectDateRange(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsCards(AppLocalizations s) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 4),
          _buildMetricCard(
            title: s.avgEnergy,
            value: metrics['avg_daily_energy']?.toStringAsFixed(2) ?? '0',
            unit: unit,
            icon: Icons.av_timer,
          ),
          const SizedBox(width: 12),
          _buildMetricCard(
            title: s.peakPower,
            value: metrics['peak_power']?.toStringAsFixed(2) ?? '0',
            unit: s.watt,
            icon: Icons.bolt,
          ),
          const SizedBox(width: 12),
          _buildMetricCard(
            title: s.totalEnergy,
            value: metrics['total_energy']?.toStringAsFixed(2) ?? '0',
            unit: s.kilowattHour,
            icon: Icons.energy_savings_leaf,
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildMetricCard({required String title, required String value, required String unit, required IconData icon}) {
    return SizedBox(
      width: 180,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: const Color(0xFF0A5099)),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0A5099),
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                unit,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(AppLocalizations s) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 1.5),
      ),
      child: Column(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A5099)),
          ),
          const SizedBox(height: 20),
          Text(
            s.loadingEnergyData,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations s) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 1.5),
      ),
      child: Column(
        children: [
          const Icon(Icons.bolt, color: Colors.blueGrey, size: 48),
          const SizedBox(height: 16),
          Text(
            s.noEnergyData,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            s.adjustDateRange,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsumptionChart(AppLocalizations s) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.hourlyPowerConsumption,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0A5099),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() % 4 == 0 && value.toInt() < timeLabels.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                timeLabels[value.toInt()],
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black54,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                        interval: 0.00001,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(5),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: const Color(0xff37434d), width: 0.5),
                  ),
                  minX: 0,
                  maxX: (timeLabels.length - 1).toDouble(),
                  minY: 0.00,
                  maxY: (powerValues.reduce((a, b) => a > b ? a : b)) * 1.2,
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(timeLabels.length, (index) {
                        return FlSpot(index.toDouble(), powerValues[index]);
                      }),
                      isCurved: true,
                      color: const Color(0xFF0A5099),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF0A5099).withOpacity(0.3),
                            const Color(0xFF0A5099).withOpacity(0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
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

  Widget _buildDataTable(AppLocalizations s) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width - 32,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 24,
              horizontalMargin: 12,
              headingRowHeight: 50,
              dataRowHeight: 48,
              headingRowColor: MaterialStateProperty.all(Color(0xFF0A5099).withOpacity(0.05)),
              headingTextStyle: const TextStyle(
                color: Color(0xFF0A5099),
                fontWeight: FontWeight.w600,
                fontSize: 13,
                fontFamily: 'Poppins',
              ),
              dataTextStyle: const TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontFamily: 'Poppins',
              ),
              columns: [
                DataColumn(
                  label: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text(s.time),
                  ),
                ),
                DataColumn(
                  label: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text('${s.power} ($unit)'),
                  ),
                ),
              ],
              rows: List<DataRow>.generate(
                timeLabels.length,
                (index) => DataRow(
                  cells: [
                    DataCell(
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Text(timeLabels[index]),
                      ),
                    ),
                    DataCell(
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Text(powerValues[index].toStringAsFixed(2)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}