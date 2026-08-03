import 'package:equatable/equatable.dart';

class AuditModel extends Equatable {
  final String id;
  final String title;
  final String zone;
  final String status; // 'Pending', 'In-Progress', 'Completed'
  final DateTime dueDate;
  final List<AuditItemModel> items;

  const AuditModel({
    required this.id,
    required this.title,
    required this.zone,
    required this.status,
    required this.dueDate,
    this.items = const [],
  });

  @override
  List<Object?> get props => [id, title, zone, status, dueDate, items];

  AuditModel copyWith({
    String? id,
    String? title,
    String? zone,
    String? status,
    DateTime? dueDate,
    List<AuditItemModel>? items,
  }) {
    return AuditModel(
      id: id ?? this.id,
      title: title ?? this.title,
      zone: zone ?? this.zone,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      items: items ?? this.items,
    );
  }
}

class AuditItemModel extends Equatable {
  final String sku;
  final String itemName;
  final String bin;
  final int systemQty;
  final int? countedQty;

  const AuditItemModel({
    required this.sku,
    required this.itemName,
    required this.bin,
    required this.systemQty,
    this.countedQty,
  });

  bool get isCounted => countedQty != null;
  int get variance => (countedQty ?? 0) - systemQty;

  @override
  List<Object?> get props => [sku, itemName, bin, systemQty, countedQty];

  AuditItemModel copyWith({
    String? sku,
    String? itemName,
    String? bin,
    int? systemQty,
    int? countedQty,
  }) {
    return AuditItemModel(
      sku: sku ?? this.sku,
      itemName: itemName ?? this.itemName,
      bin: bin ?? this.bin,
      systemQty: systemQty ?? this.systemQty,
      countedQty: countedQty ?? this.countedQty,
    );
  }
}
