# Folder Structure Documentation

The project structure adheres to the **Feature-First** architecture pattern, organizing business capabilities into isolated modules inside `lib/features/`.

```text
wms_new/
├── assets/                          # Static assets (images, icons, fonts)
│   ├── icons/                       # App icons and graphics
│   └── images/                      # Placeholder graphics
│
├── docs/                            # Project documentation & sprint handbooks
│   ├── architecture.md              # System architecture blueprint
│   ├── folder_structure.md          # Project folder structure guide
│   ├── state_management.md          # Riverpod + GetIt state management setup
│   ├── mock_api.md                  # Mock service and repository data strategy
│   ├── future_scope.md              # Feature roadmap and enterprise extensions
│   └── handbook/                    # Learning handbook and sprint logs
│       ├── 00_preface.md
│       ├── 01_sprint_1_enterprise_foundation.md
│       └── 02_sprint_2_wms_features_and_modules.md
│
├── lib/                             # Main Flutter Dart source code
│   ├── app/                         # App-wide configurations & router
│   │   ├── config/                  # App config and environment variables (env.dart)
│   │   ├── router/                  # GoRouter configuration & route names
│   │   │   ├── app_router.dart      # Central route mapping & navigation guards
│   │   │   └── route_names.dart     # Route string constants
│   │   ├── theme/                   # Material 3 design tokens & themes
│   │   │   ├── app_colors.dart      # Custom color palettes
│   │   │   └── app_theme.dart       # Light and Dark theme implementations
│   │   └── app.dart                 # Root MaterialApp widget setup
│   │
│   ├── core/                        # Core system services, utilities, and infrastructure
│   │   ├── constants/               # Global application constants
│   │   ├── di/                      # Dependency Injection (locator.dart setup)
│   │   ├── enums/                   # Global enums (e.g. ViewStatus)
│   │   ├── error/                   # Exception and Failure classes
│   │   ├── helpers/                 # UI helpers (ResponsiveHelper)
│   │   ├── initialization/          # AppInitializer (Hive, storage setup)
│   │   ├── logger/                  # Logger service configuration
│   │   ├── network/                 # REST API services (BaseApiService, NetworkApiService)
│   │   ├── result/                  # Result utility wrapper
│   │   ├── services/                # Hardware/Printing services (PrintingService)
│   │   ├── session/                 # User session & auth state storage
│   │   ├── storage/                 # Local DB storage (HiveService, SecureStorageService)
│   │   └── utils/                   # General utility functions
│   │
│   ├── features/                    # Feature-First Business Modules
│   │   ├── audit/                   # Cycle Counting & Stock Audits
│   │   │   ├── models/              # AuditModel, AuditItemModel
│   │   │   ├── viewmodels/          # AuditViewModel
│   │   │   └── views/               # AuditListView, AuditDetailsView
│   │   │
│   │   ├── authentication/          # User Authentication & Session
│   │   │   ├── data/                # Request & Response DTOs
│   │   │   ├── repositories/        # AuthRepository & AuthRepositoryImpl
│   │   │   ├── services/            # AuthMockService
│   │   │   ├── viewmodels/          # LoginViewModel, UserViewModel
│   │   │   ├── views/               # SplashView, LoginView
│   │   │   └── widgets/             # Auth input fields & buttons
│   │   │
│   │   ├── barcode/                 # Barcode Scanning & Verification
│   │   │   └── views/               # POScanView
│   │   │
│   │   ├── bluetooth/               # Bluetooth Scanner & Label Printer Integration
│   │   │
│   │   ├── dashboard/               # Main Dashboard & Overview Analytics
│   │   │   ├── models/              # Stats, Activities models
│   │   │   ├── repositories/        # DashboardRepository
│   │   │   ├── services/            # DashboardMockService
│   │   │   ├── viewmodels/          # HomeViewModel, ReportsViewModel
│   │   │   ├── views/               # HomeView, ReportsView
│   │   │   └── widgets/             # Performance & Stock charts, Stat cards
│   │   │
│   │   ├── inventory/               # Inventory Management & Relocation
│   │   │   ├── models/              # InventoryItemModel, StockTransferModel
│   │   │   ├── repositories/        # InventoryRepository & Impl
│   │   │   ├── services/            # InventoryMockService
│   │   │   ├── viewmodels/          # InventoryViewModel, StockTransferViewModel
│   │   │   ├── views/               # InventoryView, AddItemView, StockTransferView
│   │   │   └── widgets/             # Stock item cards & dialogs
│   │   │
│   │   ├── inward/                  # Inbound Operations & Receiving
│   │   │   ├── models/              # PutawayItemModel
│   │   │   ├── repositories/        # InwardRepository
│   │   │   ├── services/            # InwardMockService
│   │   │   ├── viewmodels/          # InboundViewModel, PutawayViewModel
│   │   │   ├── views/               # InboundView, DirectedPutawayView, GRNSummaryView, DamageReportView
│   │   │   └── widgets/             # PO cards, Receiving chips
│   │   │
│   │   ├── picklist/                # Wave & Batch Picking Module
│   │   │   ├── models/              # PicklistModel, PicklistItemModel
│   │   │   ├── repositories/        # PicklistRepository
│   │   │   ├── services/            # PicklistMockService
│   │   │   ├── viewmodels/          # PicklistViewModel
│   │   │   ├── views/               # PicklistListView, PicklistDetailsView
│   │   │   └── widgets/             # GuidedPickTile, PicklistCard
│   │   │
│   │   ├── purchase_order/          # Purchase Order Management
│   │   │   ├── models/              # PurchaseOrderModel, PurchaseOrderItemModel
│   │   │   └── views/               # AddPOView, PODetailsView
│   │   │
│   │   ├── returns/                 # Reverse Logistics & RMA Returns
│   │   │   ├── models/              # ReturnOrderModel, ReturnItemModel
│   │   │   ├── repositories/        # ReturnsRepository
│   │   │   ├── services/            # ReturnsMockService
│   │   │   ├── viewmodels/          # ReturnsViewModel
│   │   │   ├── views/               # ReturnsListView, ReturnInspectionView, CreateRMAView
│   │   │   └── widgets/             # ReturnOrderCard, ReturnInspectionTile
│   │   │
│   │   ├── settings/                # App Settings & Personalization
│   │   │   ├── services/            # SettingsService
│   │   │   ├── viewmodels/          # ThemeViewModel
│   │   │   ├── views/               # ProfileView
│   │   │   └── widgets/             # Theme selector & profile cards
│   │   │
│   │   ├── shipment/                # Outbound Shipping & Order Picking
│   │   │   ├── models/              # OutboundOrderModel, OutboundOrderItemModel
│   │   │   ├── repositories/        # ShipmentRepository
│   │   │   ├── services/            # ShipmentMockService
│   │   │   ├── viewmodels/          # OutboundViewModel
│   │   │   ├── views/               # OutboundView, PickingView, ManifestView
│   │   │   └── widgets/             # Order cards, shipping buttons
│   │   │
│   │   └── tasks/                   # Worker Task Queue
│   │       ├── models/              # TaskModel
│   │       ├── services/            # TasksMockService
│   │       ├── viewmodels/          # TasksViewModel
│   │       └── views/               # TaskQueueView
│   │
│   ├── l10n/                        # Localization / i18n
│   │   └── generated/               # Generated localization files (AppLocalizations)
│   │
│   ├── shared/                      # Shared reusable UI elements
│   │   ├── dialogs/                 # Reusable dialogs (LogoutDialog)
│   │   └── widgets/                 # Common widgets (MainDrawer, CustomSliverDelegate)
│   │
│   └── main.dart                    # Application entry point
│
├── pubspec.yaml                     # Dependencies and configuration
└── README.md                        # Project landing page
```
