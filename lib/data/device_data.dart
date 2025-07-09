class DeviceData {
  final Map<String, dynamic> device;
  final Map<String, dynamic> consumption;
  final Map<String, dynamic> prediction;
  final Map<String, dynamic> energyHistory;
  final Map<String, dynamic> metrics;

  DeviceData({
    required this.device,
    required this.consumption,
    required this.prediction,
    required this.energyHistory,
    required this.metrics,
  });

  factory DeviceData.fromJson(Map<String, dynamic> json) {
    return DeviceData(
      device: json['device'] ?? {},
      consumption: json['consumption'] ?? {},
      prediction: json['prediction'] ?? {},
      energyHistory: json['energy_history'] ?? {},
      metrics: json['metrics'] ?? {},
    );
  }
}
