import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:driversense_app/core/config/env_config.dart';
import 'package:driversense_app/core/storage/local_storage.dart';
import 'package:driversense_app/core/storage/secure_storage.dart';
import 'package:driversense_app/core/network/network_info.dart';
import 'package:driversense_app/core/network/api_client.dart';
import 'package:driversense_app/core/storage/database/app_database.dart';
import 'package:driversense_app/core/router/app_router.dart';
import 'package:driversense_app/core/router/route_guards.dart';
import 'package:driversense_app/shared/services/connectivity_service.dart';
import 'package:driversense_app/shared/services/notification_service.dart';
import 'package:driversense_app/shared/services/sync_service.dart';
import 'package:driversense_app/shared/services/location_service.dart';
import 'package:driversense_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:driversense_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:driversense_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:driversense_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:driversense_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:driversense_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:driversense_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:driversense_app/features/tracking/presentation/bloc/tracking_bloc.dart';

final GetIt getIt = GetIt.instance;

/// Configure dependency injection
@InjectableInit(preferRelativeImports: true)
Future<void> configureDependencies(EnvConfig config) async {
  // Register environment config
  getIt.registerSingleton<EnvConfig>(config);

  // Initialize local storage
  final localStorage = LocalStorage();
  await localStorage.init();
  getIt.registerSingleton<LocalStorage>(localStorage);

  // Manual registrations for core services
  _registerCoreDependencies();
  _registerDataSources();
  _registerRepositories();
  _registerUseCases();
  _registerBlocs();
}

void _registerCoreDependencies() {
  // Secure storage
  if (!getIt.isRegistered<SecureStorage>()) {
    getIt.registerLazySingleton<SecureStorage>(() => SecureStorage());
  }

  // Network info
  if (!getIt.isRegistered<NetworkInfo>()) {
    getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  }

  // API client
  if (!getIt.isRegistered<ApiClient>()) {
    getIt.registerLazySingleton<ApiClient>(
      () => ApiClient(
        getIt<SecureStorage>(),
        getIt<EnvConfig>(),
      ),
    );
  }

  // Database
  if (!getIt.isRegistered<AppDatabase>()) {
    getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());
  }

  // Services
  if (!getIt.isRegistered<ConnectivityService>()) {
    getIt.registerLazySingleton<ConnectivityService>(
      () => ConnectivityService(getIt<NetworkInfo>()),
    );
  }

  if (!getIt.isRegistered<NotificationService>()) {
    getIt.registerLazySingleton<NotificationService>(
      () => NotificationService(),
    );
  }

  if (!getIt.isRegistered<SyncService>()) {
    getIt.registerLazySingleton<SyncService>(
      () => SyncService(
        getIt<ConnectivityService>(),
        getIt<AppDatabase>(),
        getIt<ApiClient>(),
      ),
    );
  }

  if (!getIt.isRegistered<LocationService>()) {
    getIt.registerLazySingleton<LocationService>(
      () => LocationService(),
    );
  }

  // Router
  if (!getIt.isRegistered<AuthGuard>()) {
    getIt.registerLazySingleton<AuthGuard>(
      () => AuthGuard(
        getIt<SecureStorage>(),
        getIt<LocalStorage>(),
      ),
    );
  }

  if (!getIt.isRegistered<AppRouter>()) {
    getIt.registerLazySingleton<AppRouter>(
      () => AppRouter(getIt<AuthGuard>()),
    );
  }
}

void _registerDataSources() {
  // Auth
  if (!getIt.isRegistered<AuthRemoteDatasource>()) {
    getIt.registerLazySingleton<AuthRemoteDatasource>(
      () => AuthRemoteDatasourceImpl(getIt<ApiClient>()),
    );
  }

  if (!getIt.isRegistered<AuthLocalDatasource>()) {
    getIt.registerLazySingleton<AuthLocalDatasource>(
      () => AuthLocalDatasourceImpl(
        getIt<SecureStorage>(),
        getIt<LocalStorage>(),
      ),
    );
  }

  // TODO: Add Check and Tracking datasources when implemented
}

void _registerRepositories() {
  // Auth
  if (!getIt.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        getIt<AuthRemoteDatasource>(),
        getIt<AuthLocalDatasource>(),
        getIt<NetworkInfo>(),
      ),
    );
  }

  // TODO: Add Check and Tracking repositories when implemented
}

void _registerUseCases() {
  // Auth
  if (!getIt.isRegistered<LoginUseCase>()) {
    getIt.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<LogoutUseCase>()) {
    getIt.registerLazySingleton<LogoutUseCase>(
      () => LogoutUseCase(getIt<AuthRepository>()),
    );
  }

  // TODO: Add Check and Tracking usecases when implemented
}

void _registerBlocs() {
  // Auth
  if (!getIt.isRegistered<AuthBloc>()) {
    getIt.registerFactory<AuthBloc>(
      () => AuthBloc(
        getIt<LoginUseCase>(),
        getIt<LogoutUseCase>(),
        getIt<AuthLocalDatasource>(),
      ),
    );
  }

  // Tracking - simple version without dependencies
  if (!getIt.isRegistered<TrackingBloc>()) {
    getIt.registerFactory<TrackingBloc>(
      () => TrackingBloc(),
    );
  }

  // TODO: Add CheckBloc when implemented
}
