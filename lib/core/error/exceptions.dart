// [Exception]s belong to the Data Layer.
//
// These are low-level errors thrown by data sources (APIs, Databases, Device Sensors).
// In a Clean Architecture flow:
// 1. Data Source throws an [Exception].
// 2. Repository catches the [Exception].
// 3. Repository maps the [Exception] to a [Failure].
// 4. Repository returns the [Failure] to the ViewModel.
//
// This prevents leaking implementation details (like HTTP status codes or DB errors)
// into the business logic.

class ServerException implements Exception {
  final String? message;
  const ServerException([this.message]);
}

class UnauthorizedException implements Exception {
  final String? message;
  const UnauthorizedException([this.message]);
}

class CacheException implements Exception {
  final String? message;
  const CacheException([this.message]);
}

class StorageException implements Exception {
  final String? message;
  const StorageException([this.message]);
}
