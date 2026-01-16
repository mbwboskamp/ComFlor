part of 'auth_bloc.dart';

/// Base class for auth events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check authentication status on app start
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Event to request login
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

/// Event to verify 2FA code
class Auth2FARequested extends AuthEvent {
  final String code;

  const Auth2FARequested({
    required this.code,
  });

  @override
  List<Object> get props => [code];
}

/// Event to request logout
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// Event when consent is accepted
class AuthConsentAccepted extends AuthEvent {
  final String version;

  const AuthConsentAccepted({
    required this.version,
  });

  @override
  List<Object> get props => [version];
}

/// Event to change locale
class AuthLocaleChanged extends AuthEvent {
  final Locale locale;

  const AuthLocaleChanged({
    required this.locale,
  });

  @override
  List<Object> get props => [locale];
}

/// Event when user profile is updated
class AuthUserUpdated extends AuthEvent {
  final User user;

  const AuthUserUpdated({
    required this.user,
  });

  @override
  List<Object> get props => [user];
}

/// Event for biometric authentication
class AuthBiometricRequested extends AuthEvent {
  const AuthBiometricRequested();
}

/// Event to refresh authentication
class AuthRefreshRequested extends AuthEvent {
  const AuthRefreshRequested();
}
