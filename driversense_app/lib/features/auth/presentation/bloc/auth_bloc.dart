import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:driversense_app/core/theme/white_label_theme.dart';
import 'package:driversense_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:driversense_app/features/auth/domain/entities/user.dart';
import 'package:driversense_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:driversense_app/features/auth/domain/usecases/logout_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// BLoC for handling authentication state
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final AuthLocalDatasource _localDatasource;

  AuthBloc(
    this._loginUseCase,
    this._logoutUseCase,
    this._localDatasource,
  ) : super(const AuthState()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<Auth2FARequested>(_onVerify2FARequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthConsentAccepted>(_onConsentAccepted);
    on<AuthLocaleChanged>(_onLocaleChanged);
    on<AuthUserUpdated>(_onUserUpdated);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    // Check stored user
    final user = await _localDatasource.getUser();
    final locale = await _localDatasource.getLocale();
    final hasConsent = await _localDatasource.isConsentAccepted();

    if (user != null) {
      emit(state.copyWith(
        status: hasConsent ? AuthStatus.authenticated : AuthStatus.needsConsent,
        user: user,
        locale: locale != null ? Locale(locale) : const Locale('nl'),
      ));
    } else {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        locale: locale != null ? Locale(locale) : const Locale('nl'),
      ));
    }
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));

    final result = await _loginUseCase(LoginParams(
      email: event.email,
      password: event.password,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        error: failure.message,
      )),
      (loginResult) {
        if (loginResult.needsTwoFactor) {
          emit(state.copyWith(
            status: AuthStatus.needs2FA,
            sessionToken: loginResult.sessionToken,
          ));
        } else {
          _handleSuccessfulLogin(emit, loginResult.user);
        }
      },
    );
  }

  Future<void> _onVerify2FARequested(
    Auth2FARequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));

    // TODO: Implement 2FA verification
    // For now, just show error
    emit(state.copyWith(
      status: AuthStatus.error,
      error: '2FA verification not implemented',
    ));
  }

  Future<void> _handleSuccessfulLogin(
    Emitter<AuthState> emit,
    User user,
  ) async {
    final hasConsent = await _localDatasource.isConsentAccepted();

    if (hasConsent) {
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        locale: Locale(user.language),
      ));
    } else {
      emit(state.copyWith(
        status: AuthStatus.needsConsent,
        user: user,
        locale: Locale(user.language),
      ));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    await _logoutUseCase();

    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  Future<void> _onConsentAccepted(
    AuthConsentAccepted event,
    Emitter<AuthState> emit,
  ) async {
    await _localDatasource.saveConsentAccepted(event.version);

    emit(state.copyWith(
      status: AuthStatus.authenticated,
    ));
  }

  Future<void> _onLocaleChanged(
    AuthLocaleChanged event,
    Emitter<AuthState> emit,
  ) async {
    await _localDatasource.saveLocale(event.locale.languageCode);

    emit(state.copyWith(
      locale: event.locale,
    ));
  }

  Future<void> _onUserUpdated(
    AuthUserUpdated event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(
      user: event.user,
    ));
  }
}
