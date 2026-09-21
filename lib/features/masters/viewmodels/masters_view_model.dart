import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/personnel_model.dart';
import '../models/item_master_model.dart';
import '../models/bin_master_model.dart';
import '../models/partner_master_model.dart';
import '../../../core/enums/view_status.dart';

class MastersState {
  final List<PersonnelModel> personnel;
  final List<ItemMasterModel> items;
  final List<BinMasterModel> bins;
  final List<PartnerMasterModel> partners;
  final ViewStatus status;
  final String? errorMessage;

  const MastersState({
    this.personnel = const [],
    this.items = const [],
    this.bins = const [],
    this.partners = const [],
    this.status = ViewStatus.idle,
    this.errorMessage,
  });

  MastersState copyWith({
    List<PersonnelModel>? personnel,
    List<ItemMasterModel>? items,
    List<BinMasterModel>? bins,
    List<PartnerMasterModel>? partners,
    ViewStatus? status,
    String? errorMessage,
  }) {
    return MastersState(
      personnel: personnel ?? this.personnel,
      items: items ?? this.items,
      bins: bins ?? this.bins,
      partners: partners ?? this.partners,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class MastersViewModel extends Notifier<MastersState> {
  @override
  MastersState build() {
    return _initialState();
  }

  MastersState _initialState() {
    return const MastersState(
      status: ViewStatus.success,
      personnel: [
        PersonnelModel(
          id: "EMP-101",
          name: "Rahul Sharma",
          role: "Picker",
          phone: "+91 98765 43210",
          assignedZone: "Zone A",
          status: "On Shift",
        ),
        PersonnelModel(
          id: "EMP-102",
          name: "Priya Patel",
          role: "Picker",
          phone: "+91 98765 43211",
          assignedZone: "Zone B",
          status: "On Shift",
        ),
        PersonnelModel(
          id: "EMP-103",
          name: "Amit Verma",
          role: "Loader",
          phone: "+91 98765 43212",
          assignedZone: "Loading Bay 1",
          status: "On Shift",
        ),
        PersonnelModel(
          id: "EMP-104",
          name: "Suresh Kumar",
          role: "Loader",
          phone: "+91 98765 43213",
          assignedZone: "Loading Bay 2",
          status: "Active",
        ),
        PersonnelModel(
          id: "EMP-105",
          name: "Vikram Singh",
          role: "Auditor",
          phone: "+91 98765 43214",
          assignedZone: "All Zones",
          status: "Active",
        ),
        PersonnelModel(
          id: "EMP-106",
          name: "Ananya Sen",
          role: "Manager",
          phone: "+91 98765 43215",
          assignedZone: "HQ Warehouse",
          status: "Active",
        ),
        PersonnelModel(
          id: "EMP-107",
          name: "Rajesh Gupta",
          role: "Driver",
          phone: "+91 98765 43216",
          assignedZone: "Fleet A",
          status: "Active",
        ),
      ],
      items: [
        ItemMasterModel(
          sku: "SKU-1000",
          name: "Heavy Duty Wood Pallet",
          category: "Storage",
          unitOfMeasure: "Pcs",
          defaultBin: "BIN-A0",
          minStock: 10,
          maxStock: 100,
          unitPrice: 1200.0,
        ),
        ItemMasterModel(
          sku: "SKU-1001",
          name: "Industrial Stretch Wrap Film",
          category: "Packaging",
          unitOfMeasure: "Rolls",
          defaultBin: "BIN-A1",
          minStock: 20,
          maxStock: 200,
          unitPrice: 450.0,
        ),
        ItemMasterModel(
          sku: "SKU-1002",
          name: "Barcode Scanner Handheld Wireless",
          category: "Hardware",
          unitOfMeasure: "Pcs",
          defaultBin: "BIN-A2",
          minStock: 5,
          maxStock: 30,
          unitPrice: 8500.0,
        ),
        ItemMasterModel(
          sku: "SKU-1003",
          name: "Heavy Duty Poly Strapping Tape",
          category: "Packaging",
          unitOfMeasure: "Rolls",
          defaultBin: "BIN-A3",
          minStock: 15,
          maxStock: 150,
          unitPrice: 320.0,
        ),
        ItemMasterModel(
          sku: "SKU-1004",
          name: "Corrugated Master Shipping Boxes XL",
          category: "Packaging",
          unitOfMeasure: "Boxes",
          defaultBin: "BIN-A4",
          minStock: 50,
          maxStock: 500,
          unitPrice: 85.0,
        ),
      ],
      bins: [
        BinMasterModel(
          binCode: "BIN-A0",
          zone: "Zone A",
          aisle: "Aisle 1",
          shelf: "Shelf 1",
          capacityUnits: 200,
          isOccupied: true,
        ),
        BinMasterModel(
          binCode: "BIN-A1",
          zone: "Zone A",
          aisle: "Aisle 1",
          shelf: "Shelf 2",
          capacityUnits: 150,
          isOccupied: true,
        ),
        BinMasterModel(
          binCode: "BIN-B1",
          zone: "Zone B",
          aisle: "Aisle 2",
          shelf: "Shelf 1",
          capacityUnits: 300,
          isOccupied: false,
        ),
        BinMasterModel(
          binCode: "BIN-C1",
          zone: "Zone C",
          aisle: "Aisle 3",
          shelf: "Shelf 3",
          capacityUnits: 500,
          isOccupied: false,
        ),
      ],
      partners: [
        PartnerMasterModel(
          id: "SUP-201",
          name: "Tata Supply Chain Solutions Ltd",
          type: "Supplier",
          contactPerson: "Ramesh Iyer",
          phone: "+91 22 6789 1234",
          city: "Mumbai",
        ),
        PartnerMasterModel(
          id: "SUP-202",
          name: "Reliance Logistics India",
          type: "Supplier",
          contactPerson: "Deepak Agarwal",
          phone: "+91 11 4567 8901",
          city: "New Delhi",
        ),
        PartnerMasterModel(
          id: "CUST-301",
          name: "Mahindra Retail Express",
          type: "Customer",
          contactPerson: "Sunil Deshmukh",
          phone: "+91 20 2345 6789",
          city: "Pune",
        ),
        PartnerMasterModel(
          id: "CUST-302",
          name: "Bengaluru Tech Supplies Pvt Ltd",
          type: "Customer",
          contactPerson: "Kavita Reddy",
          phone: "+91 80 8765 4321",
          city: "Bengaluru",
        ),
      ],
    );
  }

  // --- Personnel Actions ---
  void addPersonnel(PersonnelModel person) {
    final list = List<PersonnelModel>.from(state.personnel);
    list.add(person);
    state = state.copyWith(personnel: list);
  }

  void updatePersonnel(PersonnelModel person) {
    final list = List<PersonnelModel>.from(state.personnel);
    final idx = list.indexWhere((p) => p.id == person.id);
    if (idx != -1) {
      list[idx] = person;
      state = state.copyWith(personnel: list);
    }
  }

  void deletePersonnel(String id) {
    final list = state.personnel.where((p) => p.id != id).toList();
    state = state.copyWith(personnel: list);
  }

  // --- Item Actions ---
  void addItem(ItemMasterModel item) {
    final list = List<ItemMasterModel>.from(state.items);
    list.add(item);
    state = state.copyWith(items: list);
  }

  void updateItem(ItemMasterModel item) {
    final list = List<ItemMasterModel>.from(state.items);
    final idx = list.indexWhere((i) => i.sku == item.sku);
    if (idx != -1) {
      list[idx] = item;
      state = state.copyWith(items: list);
    }
  }

  void deleteItem(String sku) {
    final list = state.items.where((i) => i.sku != sku).toList();
    state = state.copyWith(items: list);
  }

  // --- Bin Actions ---
  void addBin(BinMasterModel bin) {
    final list = List<BinMasterModel>.from(state.bins);
    list.add(bin);
    state = state.copyWith(bins: list);
  }

  void deleteBin(String binCode) {
    final list = state.bins.where((b) => b.binCode != binCode).toList();
    state = state.copyWith(bins: list);
  }

  // --- Partner Actions ---
  void addPartner(PartnerMasterModel partner) {
    final list = List<PartnerMasterModel>.from(state.partners);
    list.add(partner);
    state = state.copyWith(partners: list);
  }

  void deletePartner(String id) {
    final list = state.partners.where((p) => p.id != id).toList();
    state = state.copyWith(partners: list);
  }
}

final mastersViewModelProvider =
    NotifierProvider<MastersViewModel, MastersState>(() {
      return MastersViewModel();
    });
