class UsageData {
  final int uptime;
  final double cpu;
  final int ram;
  final int disk;
  final bool isSuspended;
  final String currentState;

  UsageData({
    required this.uptime,
    required this.cpu,
    required this.ram,
    required this.disk,
    required this.isSuspended,
    required this.currentState,
  });
}
