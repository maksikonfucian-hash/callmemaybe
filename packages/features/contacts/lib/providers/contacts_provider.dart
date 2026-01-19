import 'package:flutter/material.dart';

import 'package:core/core.dart';

/// Provider for managing contacts state.
class ContactsProvider extends ChangeNotifier {
  ContactsProvider();

  List<User> _contacts = [
    const User(id: '1', name: 'Alice', isOnline: true),
    const User(id: '2', name: 'Bob', isOnline: false),
  ];
  bool _isLoading = false;
  String? _error;

  List<User> get contacts => _contacts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadContacts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Mock loading
    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addContact(User user) async {
    // For now, just add to list
    _contacts.add(user);
    notifyListeners();
  }

  Future<void> removeContact(User user) async {
    // For now, just remove from list
    _contacts.remove(user);
    notifyListeners();
  }
}