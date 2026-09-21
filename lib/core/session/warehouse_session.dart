import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WarehouseSiteModel extends Equatable {
  final String id;
  final String code;
  final String name;
  final String city;
  final String state;
  final int totalBins;

  const WarehouseSiteModel({
    required this.id,
    required this.code,
    required this.name,
    required this.city,
    required this.state,
    required this.totalBins,
  });

  @override
  List<Object?> get props => [id, code, name, city, state, totalBins];
}

class WarehouseState {
  final WarehouseSiteModel activeSite;
  final List<WarehouseSiteModel> availableSites;

  const WarehouseState({
    required this.activeSite,
    required this.availableSites,
  });

  WarehouseState copyWith({
    WarehouseSiteModel? activeSite,
    List<WarehouseSiteModel>? availableSites,
  }) {
    return WarehouseState(
      activeSite: activeSite ?? this.activeSite,
      availableSites: availableSites ?? this.availableSites,
    );
  }
}

class WarehouseViewModel extends Notifier<WarehouseState> {
  static const _defaultSites = [
    WarehouseSiteModel(
      id: "WH-MUM-01",
      code: "MH-01",
      name: "Mumbai Central Logistics Hub",
      city: "Bhiwandi, Thane",
      state: "Maharashtra",
      totalBins: 1250,
    ),
    WarehouseSiteModel(
      id: "WH-DEL-02",
      code: "DL-02",
      name: "Delhi NCR Fulfillment Center",
      city: "Gurugram",
      state: "Haryana",
      totalBins: 980,
    ),
    WarehouseSiteModel(
      id: "WH-BLR-03",
      code: "KA-03",
      name: "Bengaluru Tech Park Warehouse",
      city: "Hoskanahalli, Bengaluru",
      state: "Karnataka",
      totalBins: 1500,
    ),
  ];

  @override
  WarehouseState build() {
    return WarehouseState(
      activeSite: _defaultSites[0],
      availableSites: _defaultSites,
    );
  }

  void switchSite(WarehouseSiteModel site) {
    state = state.copyWith(activeSite: site);
  }
}

final warehouseViewModelProvider =
    NotifierProvider<WarehouseViewModel, WarehouseState>(() {
      return WarehouseViewModel();
    });
