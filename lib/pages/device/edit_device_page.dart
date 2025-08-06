import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ta_mobile/models/device.dart';
import 'package:ta_mobile/services/device_service.dart';
import 'package:ta_mobile/widgets/custom_text_field.dart';

class EditDevicePage extends ConsumerStatefulWidget {
  final Device device;

  const EditDevicePage({Key? key, required this.device}) : super(key: key);

  @override
  ConsumerState<EditDevicePage> createState() => _EditDevicePageState();
}

class _EditDevicePageState extends ConsumerState<EditDevicePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _deviceIdController;
  late final TextEditingController _buildingController;
  late DateTime? _installationDate;
  late String _status;
  bool _isLoading = false;

  // Using late initialization for type controller to ensure dropdown value exists
  late final String _selectedType;
  late final TextEditingController _typeController;

  static const List<String> _deviceTypes = [
    'monitoring',
    'control',
  ];

  static const List<String> _statusOptions = [
    'active',
    'inactive',
    'maintenance',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.device.name);
    _deviceIdController = TextEditingController(text: widget.device.deviceId);

    // Ensure the initial type exists in our dropdown options
    _selectedType = _deviceTypes.contains(widget.device.type)
        ? widget.device.type
        : _deviceTypes.first;
    _typeController = TextEditingController(text: _selectedType);

    _buildingController = TextEditingController(text: widget.device.building);
    _installationDate = widget.device.installationDate;

    // Ensure the initial status exists in our options
    _status = _statusOptions.contains(widget.device.status)
        ? widget.device.status
        : 'active';
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
      initialDate: _installationDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _installationDate) {
      setState(() => _installationDate = picked);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_installationDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap pilih tanggal instalasi')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final deviceService = ref.read(deviceServiceProvider);

      await deviceService.updateDevice(
        id: widget.device.deviceId,
        name: _nameController.text,
        deviceId: _deviceIdController.text,
        type: _typeController.text,
        building: _buildingController.text,
        installationDate: _installationDate!,
        status: _status,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perangkat berhasil diperbarui')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui: ${e.toString()}')),
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
        title: const Text('Edit Perangkat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _submitForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                label: 'Nama Perangkat',
                controller: _nameController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'ID Perangkat',
                controller: _deviceIdController,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _typeController.text,
                items: _deviceTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _typeController.text = value;
                    });
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Tipe Perangkat',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih tipe perangkat';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Gedung',
                controller: _buildingController,
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Instalasi',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _installationDate == null
                            ? 'Pilih Tanggal'
                            : DateFormat('dd/MM/yyyy')
                                .format(_installationDate!),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _status,
                items: _statusOptions.map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _status = value);
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'SIMPAN PERUBAHAN',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
