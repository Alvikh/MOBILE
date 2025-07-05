import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ta_mobile/services/device_service.dart';
import 'package:ta_mobile/services/provider/user_notifier.dart'
    show userProvider;
import 'package:ta_mobile/widgets/custom_text_field.dart';

class AddDevicePage extends ConsumerStatefulWidget {
  const AddDevicePage({Key? key}) : super(key: key);

  @override
  ConsumerState<AddDevicePage> createState() => _AddDevicePageState();
}

class _AddDevicePageState extends ConsumerState<AddDevicePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _deviceIdController;
  late final TextEditingController _typeController;
  late final TextEditingController _buildingController;
  final _formKey = GlobalKey<FormState>();
  DateTime? _installationDate;
  bool _isLoading = false;

  final List<String> _deviceTypes = [
    'monitoring',
    'control',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _deviceIdController = TextEditingController();
    _typeController = TextEditingController();
    _buildingController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _deviceIdController.dispose();
    _typeController.dispose();
    _buildingController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0A5099),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF0A5099),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _installationDate) {
      setState(() {
        _installationDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_installationDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select installation date',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final deviceService = ref.read(deviceServiceProvider);
      final user = ref.read(userProvider);

      await deviceService.createDevice(
        name: _nameController.text,
        deviceId: _deviceIdController.text,
        type: _typeController.text,
        building: _buildingController.text,
        installationDate: _installationDate!,
        status: 'active',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Device added successfully',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${e.toString()}',
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F9),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add New Device',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF0A5099),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _isLoading ? null : _submitForm,
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          CustomTextField(
                            label: 'Device Name',
                            controller: _nameController,
                            prefixIcon: Icons.devices_other,
                            iconColor: const Color(0xFF0A5099),
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            label: 'Device ID',
                            controller: _deviceIdController,
                            prefixIcon: Icons.confirmation_number,
                            iconColor: const Color(0xFF0A5099),
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: _typeController.text.isEmpty
                                ? null
                                : _typeController.text,
                            items: _deviceTypes.map((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value.capitalize(),
                                  style: const TextStyle(fontFamily: 'Poppins'),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) => setState(() {
                              if (value != null) _typeController.text = value;
                            }),
                            decoration: InputDecoration(
                              labelText: 'Device Type',
                              labelStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.grey,
                              ),
                              prefixIcon: Icon(
                                Icons.category,
                                color: const Color(0xFF0A5099),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFF0A5099),
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 15,
                              ),
                            ),
                            style: const TextStyle(fontFamily: 'Poppins'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select device type';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            label: 'Building',
                            controller: _buildingController,
                            prefixIcon: Icons.location_city,
                            iconColor: const Color(0xFF0A5099),
                          ),
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: () => _selectDate(context),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Installation Date',
                                labelStyle: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.grey,
                                ),
                                prefixIcon: Icon(
                                  Icons.calendar_today,
                                  color: const Color(0xFF0A5099),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF0A5099),
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 15,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    _installationDate == null
                                        ? 'Select date'
                                        : DateFormat('yyyy-MM-dd')
                                            .format(_installationDate!),
                                    style:
                                        const TextStyle(fontFamily: 'Poppins'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A5099),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'SAVE DEVICE',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
