import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

/// Interface for checking network connectivity
abstract class NetworkInfo {
  /// Check if device is connected to the internet
  Future<bool> get isConnected;

  /// Stream of connectivity changes
  Stream<bool> get connectivityStream;
}

/// Implementation of NetworkInfo using connectivity_plus
@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;
  final StreamController<bool> _connectivityController =
      StreamController<bool>.broadcast();

  NetworkInfoImpl() : _connectivity = Connectivity() {
    _connectivity.onConnectivityChanged.listen((result) {
      final isConnected = _isConnectedFromResult(result);
      _connectivityController.add(isConnected);
    });
  }

  bool _isConnectedFromResult(dynamic result) {
    // Handle both single ConnectivityResult and List<ConnectivityResult>
    if (result is List<ConnectivityResult>) {
      return result.any((r) =>
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.ethernet);
    } else if (result is ConnectivityResult) {
      return result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet;
    }
    return false;
  }

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return _isConnectedFromResult(result);
  }

  @override
  Stream<bool> get connectivityStream => _connectivityController.stream;

  void dispose() {
    _connectivityController.close();
  }
}
