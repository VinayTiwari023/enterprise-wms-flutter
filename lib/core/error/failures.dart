/// [Failure] is the domain layer representation of an error.
///
/// In Enterprise Flutter Architecture, we differentiate between Exceptions and Failures:
/// 1. **Exceptions**: Occur at the Data Layer (e.g., SocketException, HttpException).
/// 2. **Failures**: Occur at the Domain/Presentation Layer.
///
/// **Why Repositories return Failures instead of Exceptions?**
/// Repositories act as a boundary. By converting low-level Exceptions into Failures,
/// we ensure that the rest of the app (ViewModels/UI) doesn't depend on specific
/// data-layer implementations (like HTTP or Hive).
///
/// **Why ViewModels should never know about low-level exceptions?**
/// This maintains "Separation of Concerns". If we switch from `http` to `dio` or 
/// from `Hive` to `Sqflite`, we only change the Repository implementation.
/// The ViewModel continues to handle a generic `NetworkFailure` or `StorageFailure`,
/// making the code highly maintainable and testable.
abstract class Failure {
  final String message;

  const Failure(this.message);
}

/// Represent a failure to connect to the internet.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection. Please check your network.']);
}

/// Represents an error response from the server (e.g., 500 Internal Server Error).
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'A server error occurred. Please try again later.']);
}

/// Represents a failure due to invalid credentials or expired tokens (401/403).
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Unauthorized access. Please login again.']);
}

/// Represents a request timeout.
class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Connection timed out. Please try again.']);
}

/// Represents a failure during local data persistence (e.g., Hive/SecureStorage error).
class StorageFailure extends Failure {
  const StorageFailure([super.message = 'Failed to access local storage.']);
}

/// A fallback failure for unexpected errors.
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred.']);
}
