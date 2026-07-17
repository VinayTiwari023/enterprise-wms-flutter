import '../error/failures.dart';

/// [Result] is a functional wrapper that encapsulates either a successful value
/// or a failure. This pattern ensures that errors are handled explicitly
/// rather than relying on side-effects like exceptions.
///
/// Use [Result] in Repositories to return data to the ViewModel.
sealed class Result<T> {
  const Result();

  /// Creates a [Success] result.
  factory Result.success(T value) => Success(value);

  /// Creates a [FailureResult] result.
  factory Result.failure(Failure failure) => FailureResult(failure);

  /// Executes [onSuccess] if this is a [Success], or [onFailure] if this is a [FailureResult].
  ///
  /// This uses Dart 3 exhaustive pattern matching.
  R when<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    return switch (this) {
      Success(value: var v) => onSuccess(v),
      FailureResult(failure: var f) => onFailure(f),
    };
  }
}

/// Represents a successful operation.
class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

/// Represents a failed operation.
/// We name it [FailureResult] to avoid naming collision with the [Failure] class.
class FailureResult<T> extends Result<T> {
  final Failure failure;
  const FailureResult(this.failure);
}

/// Practical helpers for working with [Result].
extension ResultExtension<T> on Result<T> {
  /// Returns the value if [Success], otherwise returns null.
  T? get valueOrNull => this is Success<T> ? (this as Success<T>).value : null;

  /// Returns the failure if [FailureResult], otherwise returns null.
  Failure? get failureOrNull =>
      this is FailureResult<T> ? (this as FailureResult<T>).failure : null;

  /// Returns true if this is a [Success].
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a [FailureResult].
  bool get isFailure => this is FailureResult<T>;
}
