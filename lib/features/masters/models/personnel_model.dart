import 'package:equatable/equatable.dart';

class PersonnelModel extends Equatable {
  final String id;
  final String name;
  final String role; // 'Picker', 'Loader', 'Manager', 'Auditor', 'Driver'
  final String phone;
  final String assignedZone;
  final String status; // 'Active', 'On Shift', 'Off Shift'

  const PersonnelModel({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
    required this.assignedZone,
    this.status = 'Active',
  });

  @override
  List<Object?> get props => [id, name, role, phone, assignedZone, status];

  PersonnelModel copyWith({
    String? id,
    String? name,
    String? role,
    String? phone,
    String? assignedZone,
    String? status,
  }) {
    return PersonnelModel(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      assignedZone: assignedZone ?? this.assignedZone,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'role': role,
    'phone': phone,
    'assignedZone': assignedZone,
    'status': status,
  };

  factory PersonnelModel.fromJson(Map<String, dynamic> json) => PersonnelModel(
    id: json['id'] as String,
    name: json['name'] as String,
    role: json['role'] as String,
    phone: json['phone'] as String,
    assignedZone: json['assignedZone'] as String,
    status: json['status'] as String? ?? 'Active',
  );
}
