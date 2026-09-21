import 'package:equatable/equatable.dart';

class PartnerMasterModel extends Equatable {
  final String id;
  final String name;
  final String type; // 'Supplier' or 'Customer'
  final String contactPerson;
  final String phone;
  final String city;

  const PartnerMasterModel({
    required this.id,
    required this.name,
    required this.type,
    required this.contactPerson,
    required this.phone,
    required this.city,
  });

  @override
  List<Object?> get props => [id, name, type, contactPerson, phone, city];

  PartnerMasterModel copyWith({
    String? id,
    String? name,
    String? type,
    String? contactPerson,
    String? phone,
    String? city,
  }) {
    return PartnerMasterModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      contactPerson: contactPerson ?? this.contactPerson,
      phone: phone ?? this.phone,
      city: city ?? this.city,
    );
  }
}
