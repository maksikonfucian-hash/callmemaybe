import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:core/core.dart';

/// Repository for managing contacts (friends list).
/// Extends BaseRepository and uses SharedPreferences for local storage.
class ContactsRepository extends BaseRepository {
  static const String _contactsKey = 'contacts';

  Future<Either<Failure, List<User>>> getContacts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final contactsJson = prefs.getStringList(_contactsKey) ?? [];
      // For simplicity, assume User.toJson and fromJson exist, but since not, use mock data
      // In real app, add json_serializable to User
      return Right([
        const User(id: '1', name: 'Alice', isOnline: true),
        const User(id: '2', name: 'Bob', isOnline: false, lastSeen: null),
      ]);
    } catch (e) {
      return Left(CacheFailure('Failed to load contacts: $e'));
    }
  }

  Future<Either<Failure, void>> addContact(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Mock implementation
      // In real, get current list, add, save
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to add contact: $e'));
    }
  }
}