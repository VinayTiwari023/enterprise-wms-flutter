class DashboardStats {
  final int pendingCount;
  final int completedCount;
  final int inProgressCount;
  final int alertsCount;

  DashboardStats({
    required this.pendingCount,
    required this.completedCount,
    required this.inProgressCount,
    required this.alertsCount,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      pendingCount: json['pendingCount'] ?? 0,
      completedCount: json['completedCount'] ?? 0,
      inProgressCount: json['inProgressCount'] ?? 0,
      alertsCount: json['alertsCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pendingCount': pendingCount,
      'completedCount': completedCount,
      'inProgressCount': inProgressCount,
      'alertsCount': alertsCount,
    };
  }
}
