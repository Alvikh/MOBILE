import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ta_mobile/models/device.dart';
import 'package:ta_mobile/services/device_service.dart';
import 'package:ta_mobile/widgets/custom_text_field.dart';

class AddDevicePage extends StatefulWidget {
  const AddDevicePage({Key? key}) : super(key: key);

  @override
  _AddDevicePageState createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {
  final _formKey = GlobalKey<FormState>();
  final DeviceService _deviceService = DeviceService();

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _deviceIdController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  DateTime? _installationDate;
  bool _isLoading = false;

  // Available device types
  final List<String> _deviceTypes = [
    'Monitoring Device',
    'Control Device',
  ];

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
              primary: Color(0xFF2196F3), // header background
              onPrimary: Colors.white, // header text
              onSurface: Colors.black87, // body text
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF2196F3), // button text
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
        const SnackBar(
          content: Text('Please select installation date'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final newDevice = Device(
        name: _nameController.text,
        deviceId: _deviceIdController.text,
        type: _typeController.text,
        building: _buildingController.text,
        installationDate: _installationDate!,
      );

      await _deviceService.addDevice(newDevice);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Device added successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add device: $e'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Add New Device',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white, size: 26),
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
                  const SizedBox(height: 10),
                  // Device Name
                  CustomTextField(
                    label: 'Device Name',
                    controller: _nameController,
                    iconColor: const Color(0xFF2196F3),
                    borderColor: Colors.grey[300]!,
                    focusedBorderColor: const Color(0xFF2196F3),
                    textColor: Colors.black87,
                    labelColor: Colors.grey[600]!,
                    prefixIcon: Icons.devices,
                  ),
                  const SizedBox(height: 20),

                  // Device ID
                  CustomTextField(
                    label: 'Device ID',
                    controller: _deviceIdController,
                    iconColor: const Color(0xFF2196F3),
                    borderColor: Colors.grey[300]!,
                    focusedBorderColor: const Color(0xFF2196F3),
                    textColor: Colors.black87,
                    labelColor: Colors.grey[600]!,
                    prefixIcon: Icons.confirmation_number,
                  ),
                  const SizedBox(height: 20),

                  // Device Type (Dropdown)
                  DropdownButtonFormField<String>(
                    value: _typeController.text.isEmpty
                        ? null
                        : _typeController.text,
                    decoration: InputDecoration(
                      labelText: 'Device Type',
                      labelStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                      prefixIcon:
                          const Icon(Icons.category, color: Color(0xFF2196F3)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF2196F3), width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 15,
                      ),
                    ),
                    items: _deviceTypes.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        _typeController.text = value;
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select device type';
                      }
                      return null;
                    },
                    dropdownColor: Colors.white,
                    icon: const Icon(Icons.arrow_drop_down,
                        color: Color(0xFF2196F3)),
                    style: const TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(height: 20),

                  // Building
                  CustomTextField(
                    label: 'Building',
                    controller: _buildingController,
                    iconColor: const Color(0xFF2196F3),
                    borderColor: Colors.grey[300]!,
                    focusedBorderColor: const Color(0xFF2196F3),
                    textColor: Colors.black87,
                    labelColor: Colors.grey[600]!,
                    prefixIcon: Icons.location_city,
                  ),
                  const SizedBox(height: 20),

                  // Installation Date
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Installation Date',
                        labelStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                        prefixIcon: const Icon(Icons.calendar_today,
                            color: Color(0xFF2196F3)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF2196F3), width: 1.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 15,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _installationDate == null
                                ? 'Select date'
                                : DateFormat('yyyy-MM-dd')
                                    .format(_installationDate!),
                            style: TextStyle(
                              color: _installationDate == null
                                  ? Colors.grey[500]
                                  : Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down,
                              color: Color(0xFF2196F3)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Submit Button
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shadowColor: const Color(0xFF2196F3).withOpacity(0.3),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : const Text(
                              'SAVE DEVICE',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating Navbar
          // const CustomFloatingNavbar(selectedIndex: 1),
        ],
      ),
    );
  }
}
