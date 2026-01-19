import 'package:equatable/equatable.dart';

/// Base class for all failures in the application.
/// Used with Either<Failure, Data> for functional error handling.
abstract class Failure extends Equatable {
  /// Message describing the failure.
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Failure for network-related errors.
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Failure for permission-related errors.
class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

/// Failure for WebRTC-related errors.
class WebRTCFailure extends Failure {
  const WebRTCFailure(super.message);
}

/// Failure for general server errors.
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Failure for cache-related errors.
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}