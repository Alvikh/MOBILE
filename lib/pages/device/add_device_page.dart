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
              primary: Color(0xFF2196F3),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF2196F3),
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
          const SnackBar(
            content: Text('Device added successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
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
      appBar: AppBar(
        title: const Text('Add New Device'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
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
                  CustomTextField(
                    label: 'Device Name',
                    controller: _nameController,
                    prefixIcon: Icons.devices,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'Device ID',
                    controller: _deviceIdController,
                    prefixIcon: Icons.confirmation_number,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _typeController.text.isEmpty
                        ? null
                        : _typeController.text,
                    items: _deviceTypes.map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value.capitalize()),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() {
                      if (value != null) _typeController.text = value;
                    }),
                    decoration: const InputDecoration(
                      labelText: 'Device Type',
                      prefixIcon: Icon(Icons.category),
                    ),
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
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Installation Date',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _installationDate == null
                                ? 'Select date'
                                : DateFormat('yyyy-MM-dd')
                                    .format(_installationDate!),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
                        : const Text('SAVE DEVICE'),
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
