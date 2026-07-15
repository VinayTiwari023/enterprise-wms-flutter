# Sprint 1 — Enterprise Foundation

## Sprint Goal

Build a solid enterprise architecture before implementing any business features.

---

# Project Architecture

## Architecture Style

```text
Feature First
        +
MVVM
        +
Repository Pattern
        +
Riverpod
        +
GetIt
```

---

## Why Feature First?

Instead of grouping files by type:

```text
screens/
models/
repositories/
```

the project groups files by business feature:

```text
features/

authentication/

inventory/

dashboard/

barcode/
```

### Advantages

* Easier navigation
* Better scalability
* Independent feature development
* Cleaner maintenance

---

# MVVM

## What is MVVM?

MVVM stands for:

* Model
* View
* ViewModel

### Responsibilities

### View

Responsible for:

* Displaying UI
* Receiving user interaction

Must NOT:

* Call APIs
* Store data
* Contain business logic

---

### ViewModel

Responsible for:

* UI business logic
* Managing state
* Calling Repository

Must NOT:

* Make HTTP requests directly

---

### Model

Represents application data.

Example:

```
User
Product
Inventory
Shipment
```

---

# Repository Pattern

## Definition

A Repository provides application data **without exposing where the data comes from.**

The ViewModel only knows:

```
repository.login()
```

It never knows whether data comes from:

* REST API
* Cache
* Secure Storage
* Local Database

---

## WMS Analogy

Operator

↓

Supervisor

↓

Warehouse System

↓

Database

The operator asks the supervisor.

The operator never directly accesses the database.

The Repository acts like the supervisor.

---

# Dependency Injection

## Definition

Dependency Injection means a class receives the objects it needs instead of creating them itself.

Instead of:

```dart
final api = NetworkApiService();
```

we use:

```dart
class AuthRepositoryImpl implements AuthRepository {
  final BaseApiService apiService;

  AuthRepositoryImpl({
    required this.apiService,
  });
}
```

---

## Why?

Benefits:

* Loose coupling
* Better testing
* Easier maintenance
* Easier replacement of implementations

---

# Constructor Injection

## Definition

Constructor Injection is a form of Dependency Injection where dependencies are provided through the constructor.

Example:

```dart
class AuthRepositoryImpl implements AuthRepository {
  final BaseApiService apiService;

  AuthRepositoryImpl({
    required this.apiService,
  });
}
```

The Repository never creates its own dependencies.

---

# GetIt

## Responsibility

GetIt is responsible for:

* Creating objects
* Managing object lifetime
* Providing dependencies

Business classes never call:

```dart
locator()
```

Object creation belongs only to the Composition Root.

---

# Composition Root

## Definition

The Composition Root is the place where the application is assembled.

In this project:

```
lib/core/di/locator.dart
```

Responsibilities:

* Register services
* Register repositories
* Register storage
* Register infrastructure

No business logic belongs here.

---

# Riverpod

## Responsibility

Riverpod is used for:

* State Management
* Exposing dependencies

Example:

```dart
final authRepositoryProvider =
    Provider<AuthRepository>(
        (_) => locator<AuthRepository>(),
    );
```

Riverpod does NOT create repositories.

GetIt does.

---

# Network Layer

Architecture:

```
BaseApiService
        ▲
        │
NetworkApiService
```

BaseApiService defines the contract.

NetworkApiService implements the contract.

---

# Storage Layer

Architecture:

```
StorageService
        ▲
        │
SecureStorageService
```

Storage is abstracted behind an interface.

Business code never depends on FlutterSecureStorage directly.

---

# Repository Architecture

```
AuthRepository
        ▲
        │
AuthRepositoryImpl
        │
        ├── BaseApiService
        │
        └── AuthMockService
```

Repository responsibilities:

* Coordinate data
* Hide data source
* Return application data

---

# Dependency Flow

```
View

↓

ViewModel

↓

Repository

↓

BaseApiService

↓

Server
```

Every layer has exactly one responsibility.

---

# Git Workflow

Every milestone ends with:

```bash
flutter analyze

flutter test

git add .

git commit -m "Meaningful commit"

git push
```

Never push code without analysis and tests.

---

# Best Practices Learned

✅ Depend on abstractions.

✅ Constructor Injection over object creation.

✅ One Composition Root.

✅ Repository hides data source.

✅ Feature First organization.

✅ Riverpod for state.

✅ GetIt for dependency injection.

---

# Common Mistakes

❌ Creating NetworkApiService inside Repository.

❌ ViewModel calling API directly.

❌ Multiple Composition Roots.

❌ Riverpod creating repositories.

❌ Tight coupling.

---

# Interview Questions

### What is Repository Pattern?

A Repository provides data without exposing whether it comes from an API, cache, or local storage.

---

### Why Dependency Injection?

To separate object creation from business logic, making the application easier to test and maintain.

---

### What is Constructor Injection?

Providing dependencies through a class constructor instead of creating them inside the class.

---

### Why GetIt?

To centralize object creation in one Composition Root.

---

### Why use a Repository contract?

To depend on abstractions rather than concrete implementations, making the codebase easier to extend and test.

---

# Sprint 1 Summary

## Completed

* ✅ Feature First Architecture
* ✅ MVVM
* ✅ Repository Pattern
* ✅ Repository Contract
* ✅ Repository Implementation
* ✅ GetIt
* ✅ Dependency Injection
* ✅ Constructor Injection
* ✅ Composition Root
* ✅ Riverpod Integration
* ✅ Network Layer
* ✅ Storage Layer
* ✅ Git Workflow

---

# 💡 Vinay's Takeaways

* A Repository provides data without exposing where the data comes from.
* Business classes should never create their own dependencies.
* GetIt is responsible for object creation through the Composition Root.
* Constructor Injection keeps classes loosely coupled and easier to test.
* Riverpod is responsible for state management, while GetIt is responsible for dependency creation.
* Understanding *why* an architecture exists is more valuable than memorizing folder structures.

---

# Sprint Status

**Sprint 1:** ✅ Completed

**Next Sprint:** Authentication (Login Feature)
