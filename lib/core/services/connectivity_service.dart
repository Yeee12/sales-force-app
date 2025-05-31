import 'package:connectivity_plus/connectivity_plus.dart'; // Make sure you're using connectivity_plus
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  final RxBool _isConnected = false.obs;

  bool get isConnected => _isConnected.value;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      _isConnected.value = false;
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    _isConnected.value = results.any(
      (result) => result != ConnectivityResult.none,
    );
    if (_isConnected.value) {
    } else {}
  }

  Future<bool> checkCurrentConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);
      return isConnected;
    } catch (e) {
      _isConnected.value = false;
      return false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
