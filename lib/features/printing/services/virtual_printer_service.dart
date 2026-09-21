import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrinterDevice {
  final String name;
  final String macAddress;
  final String model;
  final bool isConnected;

  const PrinterDevice({
    required this.name,
    required this.macAddress,
    required this.model,
    this.isConnected = false,
  });

  PrinterDevice copyWith({bool? isConnected}) {
    return PrinterDevice(
      name: name,
      macAddress: macAddress,
      model: model,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}

class VirtualPrinterState {
  final List<PrinterDevice> discoveredPrinters;
  final PrinterDevice? connectedPrinter;
  final bool isScanning;
  final bool isPrinting;
  final String? printStatusMessage;

  const VirtualPrinterState({
    this.discoveredPrinters = const [],
    this.connectedPrinter,
    this.isScanning = false,
    this.isPrinting = false,
    this.printStatusMessage,
  });

  VirtualPrinterState copyWith({
    List<PrinterDevice>? discoveredPrinters,
    PrinterDevice? connectedPrinter,
    bool? isScanning,
    bool? isPrinting,
    String? printStatusMessage,
    bool clearConnected = false,
  }) {
    return VirtualPrinterState(
      discoveredPrinters: discoveredPrinters ?? this.discoveredPrinters,
      connectedPrinter: clearConnected
          ? null
          : (connectedPrinter ?? this.connectedPrinter),
      isScanning: isScanning ?? this.isScanning,
      isPrinting: isPrinting ?? this.isPrinting,
      printStatusMessage: printStatusMessage ?? this.printStatusMessage,
    );
  }
}

class VirtualPrinterViewModel extends Notifier<VirtualPrinterState> {
  static const _samplePrinters = [
    PrinterDevice(
      name: "Zebra ZD421 Bluetooth",
      macAddress: "4C:11:AE:88:92:01",
      model: "Zebra ZPL II Thermal Printer",
    ),
    PrinterDevice(
      name: "Honeywell RP4 Mobile",
      macAddress: "00:1A:7D:DA:71:13",
      model: "Honeywell ESC/POS Mobile Printer",
    ),
    PrinterDevice(
      name: "TSC Alpha-3R BLE",
      macAddress: "D4:36:39:10:88:51",
      model: "TSC Direct Thermal",
    ),
  ];

  @override
  VirtualPrinterState build() {
    // Default auto-connected sample printer for smooth showcase experience
    return VirtualPrinterState(
      discoveredPrinters: _samplePrinters,
      connectedPrinter: _samplePrinters[0].copyWith(isConnected: true),
    );
  }

  Future<void> scanForPrinters() async {
    state = state.copyWith(
      isScanning: true,
      printStatusMessage: "Scanning Bluetooth BLE devices...",
    );
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(
      isScanning: false,
      discoveredPrinters: _samplePrinters,
      printStatusMessage: "Found 3 Bluetooth Printers",
    );
  }

  void connectPrinter(PrinterDevice printer) {
    state = state.copyWith(
      connectedPrinter: printer.copyWith(isConnected: true),
      printStatusMessage: "Connected to ${printer.name}",
    );
  }

  Future<bool> sendPrintJob(String code, String title) async {
    state = state.copyWith(
      isPrinting: true,
      printStatusMessage: "Sending ZPL II raw commands via Bluetooth SPP...",
    );
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(
      isPrinting: false,
      printStatusMessage:
          "Label Printed Successfully on ${state.connectedPrinter?.name ?? 'Zebra ZD421'}",
    );
    return true;
  }
}

final virtualPrinterViewModelProvider =
    NotifierProvider<VirtualPrinterViewModel, VirtualPrinterState>(() {
      return VirtualPrinterViewModel();
    });
