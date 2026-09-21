# Enterprise WMS Architecture

## Overview
The **Enterprise Warehouse Management System (WMS)** is engineered using modern Flutter best practices with a **Feature-First + MVVM + Repository Pattern + Riverpod + GetIt** architecture. The codebase is designed for scalability, testability, high maintainability, and clean separation of concerns.

```text
+-----------------------------------------------------------------------+
|                              VIEW LAYER                               |
|                  (Flutter Widgets, ConsumerWidget)                    |
+-----------------------------------------------------------------------+
                                   |
                                   v
+-----------------------------------------------------------------------+
|                            VIEWMODEL LAYER                            |
|             (Riverpod Notifier, NotifierProvider, State)              |
+-----------------------------------------------------------------------+
                                   |
                                   v
+-----------------------------------------------------------------------+
|                            REPOSITORY LAYER                           |
|       (AuthRepository, InventoryRepository, PicklistRepository)       |
+-----------------------------------------------------------------------+
                                   |
             +---------------------+---------------------+
             |                                           |
             v                                           v
+--------------------------+               +----------------------------+
|     NETWORK / API LAYER  |               |     LOCAL / MOCK / HIVE    |
|   (NetworkApiService)    |               |  (MockServices, Hive,    |
|                          |               |    SecureStorage)          |
+--------------------------+               +----------------------------+
```

---

## Architectural Principles

### 1. Feature-First Organization
Code is organized by domain features rather than horizontal technical layers. Each feature folder (e.g., `features/picklist`, `features/returns`, `features/inventory`) is self-contained with its own models, services, repositories, viewmodels, views, and widgets.

### 2. Model-View-ViewModel (MVVM)
- **View**: Dumb UI components (`ConsumerWidget` / `ConsumerStatefulWidget`). Responsible only for rendering UI and delegating user actions to the ViewModel.
- **ViewModel**: Manages feature UI state (`Notifier<T>`). Processes business logic, executes repository requests, and emits updated immutable states.
- **Model**: Pure Dart data classes representing domain objects (e.g., `PicklistModel`, `ReturnOrderModel`, `PurchaseOrderModel`).

### 3. Repository Pattern
Acts as a single source of truth for domain data. ViewModel interacts strictly with repositories, remaining agnostic to whether data originates from REST APIs, Hive local caches, or mock simulation services.

### 4. Hybrid Dependency Injection (GetIt + Riverpod)
- **GetIt**: Service locator used for instantiating singletons and infrastructure dependencies (`HiveService`, `SecureStorageService`, `BaseApiService`, `MockServices`, `Repositories`) inside the Composition Root (`lib/core/di/locator.dart`).
- **Riverpod**: Manages reactive UI state and exposes viewmodels and repositories to Flutter widgets seamlessly.

---

## Layer Responsibilities

| Layer | Primary Responsibilities | Key Classes / Interfaces |
| :--- | :--- | :--- |
| **Presentation (Views & Widgets)** | UI rendering, user interaction, animation, theme adaptation | `HomeView`, `PicklistListView`, `ReturnInspectionView` |
| **State Management (ViewModel)** | State modification, async workflow handling, user notifications | `OutboundViewModel`, `PicklistViewModel`, `ReturnsViewModel` |
| **Domain Data (Repository)** | Data aggregation, cache strategy, network fallback | `InventoryRepositoryImpl`, `ShipmentRepository`, `PicklistRepository` |
| **Data Sources (Services)** | REST HTTP calls, Hive DB operations, mock generators | `NetworkApiService`, `HiveService`, `AuthMockService` |
| **Core Infrastructure** | App initialization, router navigation, logging, storage | `AppInitializer`, `GoRouter`, `SessionManager`, `AppLogger` |

---

## Error Handling & Data Flow
- Network errors and service exceptions are caught at the Repository level and converted into domain-friendly `Failure` objects or thrown as explicit exceptions.
- ViewModels expose explicit state statuses (`ViewStatus.idle`, `ViewStatus.loading`, `ViewStatus.success`, `ViewStatus.error`) along with immutable error messages.
- UI components listen to ViewModel states and display contextual error banners, progress indicators, or user notifications via `SnackBar` or Dialogs.
