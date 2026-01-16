import 'package:dartz/dartz.dart';
import 'package:driversense_app/core/error/failures.dart';
import 'package:driversense_app/features/auth/domain/repositories/auth_repository.dart';

/// Use case for user logout
class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  /// Execute logout
  Future<Either<Failure, void>> call() {
    return _repository.logout();
  }
}
