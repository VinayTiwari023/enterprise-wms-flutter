import 'package:equatable/equatable.dart';

class BinMasterModel extends Equatable {
  final String binCode;
  final String zone;
  final String aisle;
  final String shelf;
  final int capacityUnits;
  final bool isOccupied;

  const BinMasterModel({
    required this.binCode,
    required this.zone,
    required this.aisle,
    required this.shelf,
    required this.capacityUnits,
    this.isOccupied = false,
  });

  @override
  List<Object?> get props => [
    binCode,
    zone,
    aisle,
    shelf,
    capacityUnits,
    isOccupied,
  ];

  BinMasterModel copyWith({
    String? binCode,
    String? zone,
    String? aisle,
    String? shelf,
    int? capacityUnits,
    bool? isOccupied,
  }) {
    return BinMasterModel(
      binCode: binCode ?? this.binCode,
      zone: zone ?? this.zone,
      aisle: aisle ?? this.aisle,
      shelf: shelf ?? this.shelf,
      capacityUnits: capacityUnits ?? this.capacityUnits,
      isOccupied: isOccupied ?? this.isOccupied,
    );
  }
}
