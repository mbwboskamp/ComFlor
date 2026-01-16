import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:driversense_app/core/error/failures.dart';
import 'package:driversense_app/features/auth/domain/repositories/auth_repository.dart';

/// Use case for verifying 2FA code
class Verify2FAUseCase {
  final AuthRepository _repository;

  Verify2FAUseCase(this._repository);

  /// Execute 2FA verification
  Future<Either<Failure, LoginResult>> call(Verify2FAParams params) {
    return _repository.verify2FA(
      sessionToken: params.sessionToken,
      code: params.code,
    );
  }
}

/// Parameters for 2FA verification
class Verify2FAParams extends Equatable {
  final String sessionToken;
  final String code;

  const Verify2FAParams({
    required this.sessionToken,
    required this.code,
  });

  @override
  List<Object> get props => [sessionToken, code];
}
