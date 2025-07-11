import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ta_mobile/l10n/app_localizations.dart';
import 'package:ta_mobile/services/energy_analytic_service.dart';

class SensorHistoryPage extends StatefulWidget {
  const SensorHistoryPage({Key? key}) : super(key: key);

  @override
  _SensorHistoryPageState createState() => _SensorHistoryPageState();
}

class _SensorHistoryPageState extends State<SensorHistoryPage> {
 late DateFormat dateFormat;
  List<Map<String, dynamic>> sensorData = [];
  bool isLoading = true;
  DateTimeRange? dateRange;
  final EnergyAnalyticsService _energyService = EnergyAnalyticsService();
  final String deviceId = 'F024F95AB9EC';
  @override
  void initState() {
    super.initState();
    dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    _loadInitialData();
  }
Future<void> _loadInitialData() async {
    setState(() => isLoading = true);
    
    try {
      final response = await _energyService.getDataHistory(
        deviceId,
        startDate: dateRange?.start,
        endDate: dateRange?.end,
        interval: 'hourly',
      );

      if (response['success']) {
        setState(() {
          sensorData = List<Map<String, dynamic>>.from(response['data']);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: ${e.toString()}')),
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
      initialDateRange: dateRange ?? DateTimeRange(
        start: DateTime.now().subtract(Duration(days: 7)),
        end: DateTime.now(),
      ),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
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
        dateRange = picked;
      });
      await _loadInitialData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    
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
                        _buildHeader(context),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Sensor Data History",
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Poppins',
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF0A5099).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.sensors,
                                            size: 16, color: Color(0xFF0A5099)),
                                        const SizedBox(width: 6),
                                        Text(
                                          "${sensorData.length} Records",
                                          style: TextStyle(
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
                              ),
                              const SizedBox(height: 20),
                              _buildFilterRow(context),
                              const SizedBox(height: 20),
                              isLoading
                                  ? _buildLoadingIndicator()
                                  : sensorData.isEmpty
                                      ? _buildEmptyState(context)
                                      : _buildDataTable(context),
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

  Widget _buildHeader(BuildContext context) {
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
                "Sensor Analytics",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
              IconButton(
                icon: Icon(Icons.refresh, color: Colors.white),
                onPressed: _loadInitialData,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "View historical sensor data and measurements",
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

  Widget _buildFilterRow(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(Icons.calendar_today, size: 20),
                label: Text(
                  dateRange != null
                      ? '${DateFormat('dd MMM yyyy').format(dateRange!.start)} - ${DateFormat('dd MMM yyyy').format(dateRange!.end)}'
                      : "Select Date Range",
                  style: TextStyle(fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color(0xFF0A5099),
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                  elevation: 0,
                ),
                onPressed: () => _selectDateRange(context),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFF0A5099).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.filter_alt, color: Color(0xFF0A5099)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
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
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A5099)),
          ),
          const SizedBox(height: 20),
          Text(
            "Loading sensor data...",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sensors_off,
            color: Colors.blueGrey[400],
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            "No Sensor Data Available",
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
            "Try adjusting your date range or check your connection",
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

  Widget _buildDataTable(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columnSpacing: 24,
              horizontalMargin: 12,
              headingRowHeight: 50,
              dataRowHeight: 48,
              headingRowColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) => Color(0xFF0A5099).withOpacity(0.05),
              ),
              headingTextStyle: TextStyle(
                color: Color(0xFF0A5099),
                fontWeight: FontWeight.w600,
                fontSize: 13,
                fontFamily: 'Poppins',
              ),
              dataRowColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) => Colors.transparent,
              ),
              dataTextStyle: TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontFamily: 'Poppins',
              ),
              columns: [
                DataColumn(label: _buildTableHeader("Time")),
                DataColumn(label: _buildTableHeader("Temp (°C)")),
                DataColumn(label: _buildTableHeader("Humidity (%)")),
                DataColumn(label: _buildTableHeader("Voltage (V)")),
                DataColumn(label: _buildTableHeader("Current (A)")),
                DataColumn(label: _buildTableHeader("Power (W)")),
                DataColumn(label: _buildTableHeader("Energy (kWh)")),
                DataColumn(label: _buildTableHeader("Power Factor")),
              ],
              rows: sensorData.map((data) {
                return DataRow(
                  cells: [
                    DataCell(Text(dateFormat.format(DateTime.parse(data["measured_at"])))),
                    DataCell(_buildDataCell(data["temperature"].toStringAsFixed(1))),
                    DataCell(_buildDataCell(data["humidity"].toStringAsFixed(1))),
                    DataCell(_buildDataCell(data["voltage"].toStringAsFixed(1))),
                    DataCell(_buildDataCell(data["current"].toStringAsFixed(3))),
                    DataCell(_buildDataCell(data["power"].toStringAsFixed(2))),
                    DataCell(_buildDataCell(data["energy"].toStringAsFixed(3))),
                    DataCell(
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getPowerFactorColor(data["power_factor"]).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getPowerFactorColor(data["power_factor"]).withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          data["power_factor"].toStringAsFixed(2),
                          style: TextStyle(
                            color: _getPowerFactorColor(data["power_factor"]),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 13,
        color: Color(0xFF0A5099),
      ),
    );
  }

  Widget _buildDataCell(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        color: Colors.black87,
      ),
    );
  }

  Color _getPowerFactorColor(double pf) {
    if (pf >= 0.9) return Colors.green;
    if (pf >= 0.8) return Colors.lightGreen;
    if (pf >= 0.7) return Colors.orange;
    return Colors.red;
  }
}