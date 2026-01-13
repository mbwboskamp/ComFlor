part of 'auth_bloc.dart';

/// Authentication status enum
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  needs2FA,
  needsConsent,
  error,
}

/// Authentication state
class AuthState extends Equatable {
  final AuthStatus status;
  final User user;
  final String? error;
  final String? sessionToken;
  final Locale locale;
  final WhiteLabelTheme? whiteLabelTheme;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user = User.empty,
    this.error,
    this.sessionToken,
    this.locale = const Locale('nl'),
    this.whiteLabelTheme,
  });

  /// Check if user is authenticated
  bool get isAuthenticated => status == AuthStatus.authenticated;

  /// Check if user needs to verify 2FA
  bool get needs2FA => status == AuthStatus.needs2FA;

  /// Check if user needs to accept consent
  bool get needsConsent => status == AuthStatus.needsConsent;

  /// Check if there's an error
  bool get hasError => status == AuthStatus.error;

  /// Check if loading
  bool get isLoading => status == AuthStatus.loading;

  /// Create copy with modifications
  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? error,
    String? sessionToken,
    Locale? locale,
    WhiteLabelTheme? whiteLabelTheme,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
      sessionToken: sessionToken ?? this.sessionToken,
      locale: locale ?? this.locale,
      whiteLabelTheme: whiteLabelTheme ?? this.whiteLabelTheme,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        error,
        sessionToken,
        locale,
        whiteLabelTheme,
      ];
}
