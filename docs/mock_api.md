# Mock API & Data Strategy

## Overview
The application uses a modular **Mock API + Repository** data strategy. This allows offline development, UI testing, and workflow validation prior to back-end integration.

---

## Mock Services Architecture

Every feature contains a dedicated mock service class responsible for seeding realistic initial enterprise data and simulating network latency:

```text
                     +----------------------------+
                     |    Feature Repository      |
                     |  (e.g., PicklistRepository)|
                     +----------------------------+
                                   |
                     +-------------+-------------+
                     |                           |
                     v                           v
        +-------------------------+ +------------------------+
        |   Mock Service Class    | |   BaseApiService       |
        | (PicklistMockService)   | |  (NetworkApiService)   |
        +-------------------------+ +------------------------+
                     |                           |
                     v                           v
        +-------------------------+ +------------------------+
        | Initial Static Data     | | Live REST Backend      |
        | + Simulated Delay       | | Endpoint Calls         |
        +-------------------------+ +------------------------+
```

---

## Registered Mock Services

| Service | Feature Area | Key Data Seeded |
| :--- | :--- | :--- |
| `AuthMockService` | Authentication | Default enterprise user profile (`vinay@wms-new.com`), JWT tokens |
| `InventoryMockService` | Inventory | Bin locations, stock counts, low stock alerts, stock transfers |
| `InwardMockService` | Inbound / Receiving | Purchase Orders (PO), Supplier details, Putaway bin locations |
| `ShipmentMockService` | Outbound / Shipping | Customer orders, item picking checklists, shipping manifests |
| `TasksMockService` | Worker Task Queue | Assigned tasks (Putaway, Picking, Replenishment, Cycle Count) |
| `DashboardMockService` | Dashboard & Analytics | Daily KPI stats, performance overview metrics, activity logs |
| `PicklistMockService` | Wave & Batch Picking | Wave picklists, sequential Aisle/Rack/Shelf route stops |
| `ReturnsMockService` | Returns / RMA | RMA return requests, customer details, disposition actions |

---

## Local Persistence Fallback (Hive Storage)

For offline capability and state retention across app restarts, repositories write state updates directly to Hive local boxes:

```dart
// Example: Updating order status and writing to Hive local box
await _repository.updateOrder(updatedOrder);
```

- **Hive Adapters**: Registered during `AppInitializer.init()` in `lib/core/initialization/app_initializer.dart`.
- **Hive Boxes**: Registered for inventory items, outbound orders, and purchase orders.

---

## Backend Integration Strategy

Transitioning from mock data to live REST APIs requires zero changes to ViewModels or Views:

1. Implement the API endpoint methods in `NetworkApiService`.
2. Update the feature `RepositoryImpl` to attempt `BaseApiService` calls first.
3. Fall back to local Hive cached data or MockService when offline.

```dart
// Seamless Repository Transition Example
Future<List<PurchaseOrderModel>> fetchOrders() async {
  try {
    final response = await _apiService.get('/api/v1/inbound/orders');
    final orders = (response as List).map((json) => PurchaseOrderModel.fromJson(json)).toList();
    await _hiveService.cacheOrders(orders);
    return orders;
  } catch (e) {
    // Fallback to offline Hive storage or MockService
    return await _hiveService.getCachedOrders();
  }
}
```
