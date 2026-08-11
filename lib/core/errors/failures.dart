/// Base class for all domain-level failures.
sealed class Failure {
  const Failure(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Returned when a network or Supabase request fails.
final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error. Please try again.']);
}

/// Returned when a local cache / SharedPreferences operation fails.
final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local storage error.']);
}

/// Returned when the user is not authenticated.
final class AuthFailure extends Failure {
  const AuthFailure([super.message = 'You are not signed in.']);
}

/// Returned when a requested resource is not found.
final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found.']);
}

/// Returned when input validation fails.
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
