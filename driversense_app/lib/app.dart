import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:driversense_app/core/di/injection.dart';
import 'package:driversense_app/core/router/app_router.dart';
import 'package:driversense_app/core/theme/white_label_theme.dart';
import 'package:driversense_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:driversense_app/features/tracking/presentation/bloc/tracking_bloc.dart';
import 'package:driversense_app/shared/services/connectivity_service.dart';
import 'package:driversense_app/l10n/generated/app_localizations.dart';

class DriverSenseApp extends StatelessWidget {
  const DriverSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => getIt<AuthBloc>()..add(const AuthCheckRequested()),
        ),
        BlocProvider<TrackingBloc>(
          create: (_) => getIt<TrackingBloc>(),
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (previous, current) =>
            previous.whiteLabelTheme != current.whiteLabelTheme ||
            previous.locale != current.locale,
        builder: (context, authState) {
          final theme = authState.whiteLabelTheme ?? WhiteLabelTheme.defaultTheme;

          return StreamBuilder<bool>(
            stream: getIt<ConnectivityService>().connectivityStream,
            initialData: true,
            builder: (context, connectivitySnapshot) {
              return MaterialApp.router(
                title: theme.appName,
                debugShowCheckedModeBanner: false,
                theme: theme.toThemeData(),
                darkTheme: theme.toThemeData(isDark: true),
                themeMode: ThemeMode.system,
                locale: authState.locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                routerConfig: getIt<AppRouter>().config,
                builder: (context, child) {
                  return _AppWrapper(
                    isOnline: connectivitySnapshot.data ?? true,
                    child: child!,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _AppWrapper extends StatelessWidget {
  final bool isOnline;
  final Widget child;

  const _AppWrapper({
    required this.isOnline,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!isOnline) _OfflineBanner(),
        Expanded(child: child),
      ],
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Material(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: Colors.orange.shade700,
        child: SafeArea(
          bottom: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                l10n?.offline ?? 'Offline',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
