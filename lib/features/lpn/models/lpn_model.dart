import 'lpn_item_model.dart';

class LpnModel {
  final String lpnNumber;
  final String location;
  final String
  containerType; // Standard Pallet, Wire Tote, Gaylord Box, Wooden Crate
  final String status; // Staged, Putaway, In Transit, Shipped, Quarantine
  final double maxWeightKg;
  final double currentWeightKg;
  final List<LpnItemModel> items;
  final DateTime createdAt;
  final String createdBy;

  LpnModel({
    required this.lpnNumber,
    required this.location,
    required this.containerType,
    required this.status,
    required this.maxWeightKg,
    required this.currentWeightKg,
    required this.items,
    required this.createdAt,
    required this.createdBy,
  });

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);
  int get uniqueSkuCount => items.length;

  factory LpnModel.fromJson(Map<String, dynamic> json) {
    return LpnModel(
      lpnNumber: json['lpnNumber'] ?? '',
      location: json['location'] ?? '',
      containerType: json['containerType'] ?? 'Standard Pallet',
      status: json['status'] ?? 'Putaway',
      maxWeightKg: (json['maxWeightKg'] ?? 1000.0).toDouble(),
      currentWeightKg: (json['currentWeightKg'] ?? 0.0).toDouble(),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => LpnItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      createdBy: json['createdBy'] ?? 'System',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lpnNumber': lpnNumber,
      'location': location,
      'containerType': containerType,
      'status': status,
      'maxWeightKg': maxWeightKg,
      'currentWeightKg': currentWeightKg,
      'items': items.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
    };
  }

  LpnModel copyWith({
    String? lpnNumber,
    String? location,
    String? containerType,
    String? status,
    double? maxWeightKg,
    double? currentWeightKg,
    List<LpnItemModel>? items,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return LpnModel(
      lpnNumber: lpnNumber ?? this.lpnNumber,
      location: location ?? this.location,
      containerType: containerType ?? this.containerType,
      status: status ?? this.status,
      maxWeightKg: maxWeightKg ?? this.maxWeightKg,
      currentWeightKg: currentWeightKg ?? this.currentWeightKg,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
