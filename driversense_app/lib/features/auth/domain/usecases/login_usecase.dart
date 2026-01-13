import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:driversense_app/core/error/failures.dart';
import 'package:driversense_app/features/auth/domain/repositories/auth_repository.dart';

/// Use case for user login
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  /// Execute login with email and password
  Future<Either<Failure, LoginResult>> call(LoginParams params) {
    return _repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

/// Parameters for login use case
class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}
