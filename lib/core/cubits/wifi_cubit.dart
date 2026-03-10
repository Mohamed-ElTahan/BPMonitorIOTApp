import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum WifiStatus { wifi, mobile, none }

class WifiCubit extends Cubit<WifiStatus> {
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  WifiCubit({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity(),
      super(WifiStatus.none) {
    _init();
  }

  Future<void> _init() async {
    // Check current state immediately
    final results = await _connectivity.checkConnectivity();
    emit(_mapResults(results));

    // Listen to changes
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      emit(_mapResults(results));
    });
  }

  WifiStatus _mapResults(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.wifi)) return WifiStatus.wifi;
    if (results.contains(ConnectivityResult.mobile)) return WifiStatus.mobile;
    return WifiStatus.none;
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
