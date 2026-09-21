# Sprint 2 — Core WMS Business Features & Modules

## Sprint Goal
Implement full end-to-end WMS warehouse workflows across Inbound, Outbound, Inventory, Wave Picking, Returns, Auditing, and Personalization modules.

---

# Modules Implemented

## 1. Inbound / Receiving (`features/inward/` & `features/purchase_order/`)
- **Purchase Order (PO) Management**: List POs, filter by status (*Pending, Partial, Completed*), search by PO # or supplier.
- **Add Purchase Order**: Form view to create new incoming vendor purchase orders.
- **Barcode PO Scanning**: Camera-based scanning screen (`mobile_scanner`) to verify incoming items against PO line items.
- **Goods Received Note (GRN) Summary**: Summary screen showing received item quantities and supplier sign-off.
- **Directed Putaway**: Automated suggested bin destination (e.g., *Aisle 1 - Rack B - Shelf 2*) based on category and zone.
- **Damage Reporting**: Log damaged goods during receiving with photo attachment notes and carrier defect codes.

---

## 2. Outbound / Shipping (`features/shipment/`)
- **Outbound Sales Orders**: Manage customer orders, search order # or customer, filter by status (*Pending, Picking, Shipped*).
- **Line Item Order Picking**: Interactive picking checklist where operators pick items, record quantity, and update stock in real-time.
- **Shipping Manifest / Bill of Lading**: Generate shipping manifests for shipped orders.

---

## 3. Wave & Batch Picking (`features/picklist/`)
- **Batch Picklists**: Consolidate multiple sales orders into single wave picklists to optimize walking distance.
- **Sequential Bin Route Stops**: Display items sorted by warehouse coordinates (*Aisle 1 $\rightarrow$ Aisle 2 $\rightarrow$ Aisle 3*) with zone indicators.
- **Confirm Pick Scan**: Item picking confirmation dialog that deducts stock directly from inventory.

---

## 4. Reverse Logistics & RMA Returns (`features/returns/`)
- **RMA (Return Merchandise Authorization) Processing**: Handle customer returns tied to original sales orders.
- **Item Condition & Disposition Inspection**: Operators inspect returned goods and assign disposition actions:
  - **Restock to Bin**: Adds item back to active inventory stock.
  - **Quarantine / Rework**: Holds item for further testing.
  - **Scrap / Write-off**: Marks item as unusable damage.
- **Create RMA Request**: Form to generate new customer return requests.

---

## 5. Inventory & Bin Transfers (`features/inventory/`)
- **Real-Time Stock Lookup**: Live stock availability, bin location, and category filters.
- **Add New SKU**: Form to add new items into the warehouse catalog.
- **Bin-to-Bin Stock Transfer**: Move stock between locations (*Source Bin $\rightarrow$ Target Bin*) with transfer logs.

---

## 6. Worker Task Queue & Cycle Audits (`features/tasks/` & `features/audit/`)
- **Worker Task Queue**: Queue of assigned tasks (*Putaway, Picking, Replenishment, Stock Count*).
- **Stock Cycle Counting / Audits**: Scheduled zone audits where workers count items and record physical stock counts.

---

## 7. App Personalization & Localization (`features/settings/`)
- **Dynamic Material 3 Theme Switcher**:
  - Dark Mode & Light Mode toggle.
  - 8 Accent Color options (*Indigo, Blue, Green, Pink, Orange, Purple, Cyan, Blue Grey*).
- **Localization (i18n)**: English localization setup with `flutter_localizations` and `AppLocalizations`.

---

# Architecture Verification

```bash
flutter analyze
# Result: 0 issues found!

flutter test
# Result: All unit tests pass!
```

---

# Sprint 2 Summary

## Completed
* ✅ Inbound PO Receiving, Barcode Scanning, GRN, Directed Putaway & Damage Reports
* ✅ Outbound Order Picking & Shipping Manifest
* ✅ Wave & Batch Picklists with Sequential Bin Routing
* ✅ Reverse Logistics & RMA Returns with Item Disposition
* ✅ Real-time Inventory Lookup & Bin-to-Bin Stock Transfers
* ✅ Worker Task Queue & Stock Cycle Counting
* ✅ Dynamic Material 3 Themes & Dark Mode
* ✅ GoRouter Route Guard Integration
* ✅ Complete Documentation in `docs/`

---

# Sprint Status

**Sprint 1:** ✅ Completed (Enterprise Foundation)
**Sprint 2:** ✅ Completed (Core WMS Features)
**Next Sprint:** Hardware Bluetooth Printing, GS1 Barcode Parsing, Offline Hive Sync
