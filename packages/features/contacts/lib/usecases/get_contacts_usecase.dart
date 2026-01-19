import 'package:fpdart/fpdart.dart';

import 'package:core/core.dart';

import '../repositories/contacts_repository.dart';

/// Use case for getting the list of contacts.
class GetContactsUsecase extends Usecase<List<User>, NoParams> {
  final ContactsRepository repository;

  GetContactsUsecase(this.repository);

  @override
  Future<Either<Failure, List<User>>> call(NoParams params) async {
    return repository.getContacts();
  }
}

/// No params needed for this use case.
class NoParams {}