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
    _connectivity.onConnectivityChanged.listen((results) {
      final isConnected = _isConnectedFromResults(results);
      _connectivityController.add(isConnected);
    });
  }

  bool _isConnectedFromResults(List<ConnectivityResult> results) {
    return results.any((result) =>
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet);
  }

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return _isConnectedFromResults(results);
  }

  @override
  Stream<bool> get connectivityStream => _connectivityController.stream;

  void dispose() {
    _connectivityController.close();
  }
}
