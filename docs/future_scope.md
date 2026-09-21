# Future Scope & Development Roadmap

## Roadmap Overview
The Enterprise WMS is built upon a modular architecture ready for hardware integrations, offline synchronization, and enterprise integrations.

---

## Short-Term Roadmap (Sprint 3)

### 1. Hardware Integration & Bluetooth Label Printing (`features/bluetooth/`)
- **Bluetooth ESC/POS & Zebra ZPL Printing**: Connect handheld thermal label printers via Bluetooth SPP/BLE.
- **On-Demand Printing**:
  - SKU & Barcode tags.
  - Location Bin labels (e.g. `LOC-A1-R2-S3`).
  - Pallet / LPN (License Plate Number) stickers.
  - Shipping Labels & GRN Slips.
- **Hardware Barcode Scanner Support**: Listen to HID keyboard wedge barcode hardware inputs (Honeywell, Zebra, Datalogic scanners).

---

### 2. Advanced Barcode & LPN Tracking (`features/barcode/`)
- **GS1-128 Standard Parsing**: Automatically extract SKU, Lot/Batch Number, Expiry Date, and Pack Quantity from complex GS1 barcodes in a single scan.
- **License Plate Number (LPN) Pallet Tracking**: Move and scan full pallet containers using LPN barcodes without scanning individual items.

---

### 3. Offline-First Queue & Background Sync
- **Local Transaction Queue**: Queue picking, putaway, cycle count, and RMA disposition operations in Hive local storage when in Wi-Fi dead zones.
- **Background Sync Service**: Automatically sync queued transactions when network connectivity is restored, with server conflict resolution.

---

## Long-Term Enterprise Features

### 1. Multi-Warehouse & Multi-Zone Management
- Switch active warehouse site (e.g., Warehouse NYC, Warehouse LAX).
- Zone-level stock transfers and cross-docking workflows.

### 2. Push Notifications & Real-Time Task Dispatch
- Integration with Firebase Cloud Messaging (FCM) for real-time task assignment alerts to warehouse operators.

### 3. Analytics & Productivity Dashboard
- Worker picking speed metrics (units/hour).
- Heatmaps of high-frequency bin locations.
- Export PDF & Excel reports.

### 4. RFID / NFC Integration
- RFID gate scanning for automated pallet receiving and shipment validation.
