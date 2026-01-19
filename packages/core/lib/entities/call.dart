import 'package:equatable/equatable.dart';

/// Represents a call in the system.
/// Used for call history and active calls.
class Call extends Equatable {
  /// Unique identifier for the call.
  final String id;

  /// The caller user.
  final String callerId;

  /// The callee user.
  final String calleeId;

  /// Timestamp when the call started.
  final DateTime timestamp;

  /// Duration of the call in seconds, null if ongoing.
  final int? duration;

  /// Type of call: audio or video.
  final CallType type;

  /// Status of the call.
  final CallStatus status;

  const Call({
    required this.id,
    required this.callerId,
    required this.calleeId,
    required this.timestamp,
    this.duration,
    required this.type,
    required this.status,
  });

  @override
  List<Object?> get props => [id, callerId, calleeId, timestamp, duration, type, status];
}

/// Enumeration for call types.
enum CallType {
  audio,
  video,
}

/// Enumeration for call statuses.
enum CallStatus {
  outgoing,
  incoming,
  ongoing,
  ended,
  missed,
}