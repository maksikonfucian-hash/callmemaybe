import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import 'package:core/core.dart';

import '../repositories/contacts_repository.dart';
import '../usecases/get_contacts_usecase.dart';

/// Provider for managing contacts state.
class ContactsProvider extends ChangeNotifier {
  final GetContactsUsecase getContactsUsecase;

  ContactsProvider(this.getContactsUsecase);

  List<User> _contacts = [];
  bool _isLoading = false;
  String? _error;

  List<User> get contacts => _contacts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadContacts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await getContactsUsecase(NoParams());

    result.fold(
      (failure) {
        _error = failure.message;
      },
      (contacts) {
        _contacts = contacts;
      },
    );

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