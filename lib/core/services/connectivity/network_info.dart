import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// =======================
/// INTERFACE
/// =======================
abstract interface class INetworkInfo {
  Future<bool> get isConnected;
}

/// =======================
/// PROVIDER
/// =======================
final networkInfoProvider = Provider<INetworkInfo>((ref) {
  return NetworkInfo(connectivity: Connectivity());
});

/// =======================
/// IMPLEMENTATION
/// =======================
class NetworkInfo implements INetworkInfo {
  final Connectivity _connectivity;

  NetworkInfo({required Connectivity connectivity})
      : _connectivity = connectivity;

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();

    // No network (wifi / mobile / ethernet)
    if (result.contains(ConnectivityResult.none)) {
      return false;
    }

    // For localhost / development purpose
    return true;

    // If you want real internet check, use this instead:
    // return await _checkForInternet();
  }

  /// Optional: Real internet availability check
  Future<bool> _checkForInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }
}
