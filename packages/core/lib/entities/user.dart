import 'package:equatable/equatable.dart';

/// Represents a user in the system.
/// Used across features like contacts, calls, and settings.
class User extends Equatable {
  /// Unique identifier for the user.
  final String id;

  /// Display name of the user.
  final String name;

  /// Optional profile photo URL.
  final String? photoUrl;

  /// Indicates if the user is online.
  final bool isOnline;

  /// Last seen timestamp.
  final DateTime? lastSeen;

  const User({
    required this.id,
    required this.name,
    this.photoUrl,
    this.isOnline = false,
    this.lastSeen,
  });

  @override
  List<Object?> get props => [id, name, photoUrl, isOnline, lastSeen];
}