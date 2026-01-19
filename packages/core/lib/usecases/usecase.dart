import 'package:fpdart/fpdart.dart';

import '../failures/failure.dart';

/// Base abstract class for all use cases.
/// Use cases encapsulate business logic and return Either<Failure, Result>.
abstract class UseCase<Type, Params> {
  /// Executes the use case with given parameters.
  /// Returns Either<Failure, Type> for functional error handling.
  Future<Either<Failure, Type>> call(Params params);
}

/// No parameters use case.
class NoParams {
  const NoParams();
}