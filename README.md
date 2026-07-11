<div align="center">

# 📦 Enterprise WMS Flutter

### *Where a warehouse meets clean architecture.*

**A production-grade Warehouse Management System, built in Flutter — not to ship features fast, but to ship them right.**

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20%2B%20MVVM-8A2BE2?style=for-the-badge)]()
[![Status](https://img.shields.io/badge/Status-In%20Development-orange?style=for-the-badge)]()
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

</div>

---

## 🧭 Why This Exists

Most side projects prove you can *build something*.
This one is built to prove something narrower and harder: **that I build the way enterprise teams build** — with boundaries, contracts, and code that survives contact with a second engineer.

Every folder, pattern, and dependency choice here is deliberate. This isn't a WMS that happens to be clean — it's a clean architecture that happens to be a WMS.

---

## 🏗️ The Blueprint

A **Feature-First** structure, wired together with **MVVM** and the **Repository Pattern** — so each feature is an independent, testable unit, not a thread tangled into everything else.

```text
lib/
│
├── core/                 # The skeleton — shared across every feature
│   ├── api/
│   ├── constants/
│   ├── di/
│   ├── services/
│   ├── storage/
│   └── utils/
│
├── features/             # The muscles — each one self-contained
│   ├── authentication/
│   ├── dashboard/
│   ├── inventory/
│   ├── inward/
│   ├── outbound/
│   └── settings/
│
└── shared/               # The connective tissue — reusable, opinion-free
```

---

## 🛠 Tech Stack

| Layer            | Choice                              |
|------------------|-------------------------------------|
| Framework        | Flutter / Dart                      |
| State Management | Riverpod                            |
| Service Locator  | GetIt                               |
| Architecture     | MVVM + Repository Pattern           |
| Storage          | Flutter Secure Storage (abstracted) |
| Networking       | REST APIs                           |

---

## ✅ Enterprise Patterns in Play

Not a checklist for its own sake — each pattern here is solving a specific problem a real WMS runs into at scale.

* Feature-First Architecture
* MVVM
* Repository Pattern
* Dependency Injection (constructor-based)
* GetIt Service Locator
* Singleton & Lazy Singleton
* Factory Pattern
* Interface-Based Programming
* Secure Storage Abstraction

---

## 🔐 Storage, Decoupled

The app never talks to a storage implementation directly — it talks to a contract.

```text
        StorageService   ← the contract
              ▲
              │  implements
              │
    SecureStorageService  ← the concrete detail
```

Swap the implementation tomorrow — encrypted storage, in-memory for tests, a different vendor entirely — and not a single feature module notices. That's the point.

---

## 📦 Dependency Injection, Centralized

Every dependency in this app is born in one place, registered through **GetIt**.

**Why it matters:**
* 🔗 Loose coupling between layers
* 🧪 Trivial to mock for testing
* 🧩 One source of truth for object creation
* 🛠 Maintainable as the feature count grows

---

## 🧪 Quality Gate

Nothing merges without clearing:

```bash
flutter analyze
flutter test
```

Every milestone is a checkpoint, not a checkbox.

---

## 📈 Development Philosophy

> Build it like someone else has to maintain it in two years — because eventually, someone will.

* Clean Code & SOLID Principles
* Separation of Concerns
* Testability by design, not by accident
* Scalability over shortcuts
* Reusability wherever it earns its keep

---

## 🚧 Roadmap

- [ ] Authentication
- [ ] Dashboard
- [ ] Inward Management
- [ ] Outward Management
- [ ] Inventory Management
- [ ] Barcode Scanning
- [ ] Offline Support
- [ ] Sync Engine
- [ ] User Roles & Permissions
- [ ] Settings
- [ ] Reports
- [ ] Notifications

---

## 🤝 Contributing

Got a sharper way to structure a layer, or spotted an antipattern hiding in plain sight? Open an issue or a PR — this project is as much about the conversation as the code.

---

## 📄 License

MIT — see [LICENSE](LICENSE) for details.

---

<div align="center">

## 👨‍💻 Author

**Vinay Kumar**
*Flutter Developer · Android Developer*

Learning enterprise Flutter the only way that sticks — by building a production-quality application, one deliberate decision at a time.

🔗 [Repository](https://github.com/VinayTiwari023/enterprise-wms-flutter) — actively under development

</div>
