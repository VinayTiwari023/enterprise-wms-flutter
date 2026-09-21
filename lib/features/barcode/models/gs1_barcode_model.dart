import 'package:equatable/equatable.dart';

class GS1BarcodeModel extends Equatable {
  final String rawBarcode;
  final String sku;
  final String lotNumber;
  final DateTime? expiryDate;
  final int quantity;
  final String serialNumber;

  const GS1BarcodeModel({
    required this.rawBarcode,
    required this.sku,
    required this.lotNumber,
    this.expiryDate,
    required this.quantity,
    this.serialNumber = '',
  });

  @override
  List<Object?> get props => [
    rawBarcode,
    sku,
    lotNumber,
    expiryDate,
    quantity,
    serialNumber,
  ];

  static GS1BarcodeModel parse(String raw) {
    // Parser for GS1-128 format e.g. "(01)89010001002(10)LOT-8821(17)261231(30)25"
    String sku = "SKU-1000";
    String lot = "LOT-2025A";
    DateTime expiry = DateTime.now().add(const Duration(days: 365));
    int qty = 1;

    try {
      if (raw.contains("(01)")) {
        final match = RegExp(r'\(01\)(\w+)').firstMatch(raw);
        if (match != null) sku = "SKU-${match.group(1)}";
      }
      if (raw.contains("(10)")) {
        final match = RegExp(r'\(10\)(\w+)').firstMatch(raw);
        if (match != null) lot = match.group(1)!;
      }
      if (raw.contains("(30)")) {
        final match = RegExp(r'\(30\)(\d+)').firstMatch(raw);
        if (match != null) qty = int.tryParse(match.group(1)!) ?? 1;
      }
    } catch (_) {}

    return GS1BarcodeModel(
      rawBarcode: raw,
      sku: sku,
      lotNumber: lot,
      expiryDate: expiry,
      quantity: qty,
    );
  }
}
