import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:driversense_app/core/network/network_info.dart';
import 'package:driversense_app/core/utils/logger.dart';

/// Service for monitoring network connectivity
@lazySingleton
class ConnectivityService {
  final NetworkInfo _networkInfo;
  final StreamController<bool> _connectivityController =
      StreamController<bool>.broadcast();

  bool _isOnline = true;
  StreamSubscription<bool>? _subscription;

  ConnectivityService(this._networkInfo);

  /// Initialize connectivity monitoring
  void initialize() {
    _subscription = _networkInfo.connectivityStream.listen((isConnected) {
      _isOnline = isConnected;
      _connectivityController.add(isConnected);
      AppLogger.info('Connectivity changed: ${isConnected ? 'online' : 'offline'}');
    });

    // Check initial state
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    _isOnline = await _networkInfo.isConnected;
    _connectivityController.add(_isOnline);
  }

  /// Current connectivity state
  bool get isOnline => _isOnline;

  /// Check if offline
  bool get isOffline => !_isOnline;

  /// Stream of connectivity changes
  Stream<bool> get connectivityStream => _connectivityController.stream;

  /// Check current connectivity
  Future<bool> checkConnectivity() async {
    _isOnline = await _networkInfo.isConnected;
    return _isOnline;
  }

  /// Wait for connectivity
  Future<void> waitForConnectivity({Duration? timeout}) async {
    if (_isOnline) return;

    final completer = Completer<void>();
    StreamSubscription<bool>? subscription;

    subscription = connectivityStream.listen((isConnected) {
      if (isConnected) {
        subscription?.cancel();
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    });

    if (timeout != null) {
      Future.delayed(timeout, () {
        subscription?.cancel();
        if (!completer.isCompleted) {
          completer.completeError(TimeoutException('Waiting for connectivity timed out'));
        }
      });
    }

    return completer.future;
  }

  /// Dispose of resources
  void dispose() {
    _subscription?.cancel();
    _connectivityController.close();
  }
}
