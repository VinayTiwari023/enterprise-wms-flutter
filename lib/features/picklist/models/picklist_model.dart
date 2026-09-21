import 'package:equatable/equatable.dart';
import 'picklist_item_model.dart';

class PicklistModel extends Equatable {
  final String id; // e.g. "PL-2024-001"
  final String waveNumber; // e.g. "WAVE-101"
  final String assignedPicker; // e.g. "Alex Rivera"
  final String status; // "Pending", "In Progress", "Completed"
  final DateTime createdAt;
  final List<PicklistItemModel> items;

  const PicklistModel({
    required this.id,
    required this.waveNumber,
    required this.assignedPicker,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  int get totalRequestedQty =>
      items.fold(0, (sum, item) => sum + item.requestedQty);
  int get totalPickedQty => items.fold(0, (sum, item) => sum + item.pickedQty);

  double get progress {
    if (items.isEmpty) return 0.0;
    int pickedCount = items.where((item) => item.isPicked).length;
    return pickedCount / items.length;
  }

  String get progressText {
    int pickedCount = items.where((item) => item.isPicked).length;
    return "$pickedCount/${items.length} items";
  }

  PicklistModel copyWith({
    String? id,
    String? waveNumber,
    String? assignedPicker,
    String? status,
    DateTime? createdAt,
    List<PicklistItemModel>? items,
  }) {
    return PicklistModel(
      id: id ?? this.id,
      waveNumber: waveNumber ?? this.waveNumber,
      assignedPicker: assignedPicker ?? this.assignedPicker,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [
    id,
    waveNumber,
    assignedPicker,
    status,
    createdAt,
    items,
  ];
}
