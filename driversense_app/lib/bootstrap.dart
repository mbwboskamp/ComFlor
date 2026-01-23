import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driversense_app/core/config/env_config.dart';
import 'package:driversense_app/core/di/injection.dart';
import 'package:driversense_app/core/utils/logger.dart';
import 'package:driversense_app/shared/services/notification_service.dart';
import 'package:driversense_app/shared/services/connectivity_service.dart';

/// Bootstraps the application with required configurations
Future<void> bootstrap(EnvConfig config) async {
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Configure logging
  AppLogger.init(
    isDebug: config.environment != Environment.prod,
  );

  // Initialize dependency injection
  await configureDependencies(config);

  // Initialize notifications
  await getIt<NotificationService>().initialize();

  // Initialize connectivity monitoring
  getIt<ConnectivityService>().initialize();

  // Set up BLoC observer for debugging
  if (kDebugMode) {
    Bloc.observer = AppBlocObserver();
  }

  AppLogger.info('App bootstrapped successfully');
}

/// BLoC observer for debugging state changes
class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    AppLogger.debug('onCreate: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    AppLogger.debug('onEvent: ${bloc.runtimeType} - $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    AppLogger.debug('onChange: ${bloc.runtimeType} - $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    AppLogger.error('onError: ${bloc.runtimeType}', error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    AppLogger.debug('onClose: ${bloc.runtimeType}');
  }
}
