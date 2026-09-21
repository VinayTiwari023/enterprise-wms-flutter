# State Management & Dependency Injection

## Overview
The application utilizes **Riverpod (v2.6)** for reactive state management and UI state binding, combined with **GetIt (v8.0)** as a service locator for managing singletons and infrastructure lifecycle.

---

## State Management Architecture

```text
               +----------------------------------+
               |        GetIt Service Locator     |
               |        (Composition Root)        |
               +----------------------------------+
                                |
                                v
               +----------------------------------+
               |        Riverpod Provider         |
               | (Exposes ViewModel / Repository) |
               +----------------------------------+
                                |
                                v
               +----------------------------------+
               |     Notifier / NotifierProvider  |
               |     (Holds Immutable UI State)   |
               +----------------------------------+
                                |
                                v
               +----------------------------------+
               |          ConsumerWidget          |
               |     (Rebuilds on state change)   |
               +----------------------------------+
```

---

## Key Components

### 1. View State Representation
Every feature defines an immutable state class containing current data models, state status, and optional error messages:

```dart
enum ViewStatus { idle, loading, success, error }

class PicklistState {
  final List<PicklistModel> picklists;
  final ViewStatus status;
  final String? errorMessage;

  const PicklistState({
    this.picklists = const [],
    this.status = ViewStatus.idle,
    this.errorMessage,
  });

  PicklistState copyWith({ ... });
}
```

---

### 2. Notifier-Based ViewModels
ViewModels extend Riverpod's `Notifier<T>` to expose state changes predictably and cleanly:

```dart
class PicklistViewModel extends Notifier<PicklistState> {
  @override
  PicklistState build() {
    Future.microtask(() => fetchPicklists());
    return const PicklistState();
  }

  PicklistRepository get _repository => ref.read(picklistRepositoryProvider);

  Future<void> fetchPicklists() async { ... }
  Future<void> pickItem(String picklistId, String sku, int quantity) async { ... }
}

final picklistViewModelProvider =
    NotifierProvider<PicklistViewModel, PicklistState>(() {
  return PicklistViewModel();
});
```

---

### 3. Family Providers for Item Selection
To optimize UI rebuilds, family providers extract specific items from feature states without rebuilding parent lists:

```dart
final singlePicklistProvider =
    Provider.family<PicklistModel?, String>((ref, id) {
  final list = ref.watch(picklistViewModelProvider.select((s) => s.picklists));
  final index = list.indexWhere((p) => p.id == id);
  return index != -1 ? list[index] : null;
});
```

---

### 4. Router Listening & Dynamic Theme Sync
- **Router Integration**: `RouterNotifier` listens to `userViewModelProvider` to evaluate authentication guards dynamically during route transitions.
- **Theme Sync**: `themeViewModelProvider` allows users to toggle dark mode or change accent colors dynamically across all app components without restarting the app.

---

## Dependency Injection Setup (`locator.dart`)

Infrastructure, Services, and Repositories are initialized inside `setupLocator()` in `lib/core/di/locator.dart`:

```dart
final locator = GetIt.instance;

void setupLocator() {
  // Services
  locator.registerLazySingleton<AuthMockService>(() => AuthMockService());
  locator.registerLazySingleton<PicklistMockService>(() => PicklistMockService());
  locator.registerLazySingleton<ReturnsMockService>(() => ReturnsMockService());

  // Repositories
  locator.registerLazySingleton<PicklistRepository>(
    () => PicklistRepository(mockService: locator<PicklistMockService>()),
  );
  locator.registerLazySingleton<ReturnsRepository>(
    () => ReturnsRepository(mockService: locator<ReturnsMockService>()),
  );
}
```

---

## Best Practices Followed
1. **Immutable States**: All state classes use `final` fields and provide a `copyWith()` method.
2. **Selective Watching**: Views use `ref.watch(provider.select(...))` to rebuild only when relevant state properties change.
3. **No Direct Instantiation in Views**: Views never create ViewModels or Repositories using `new` or `locator<T>()` directly.
