import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/subscription_service.dart';

class SubscriptionProvider extends ChangeNotifier {
  final SubscriptionService _subscriptionService = SubscriptionService();

  List<ActiveSubscriptionModel> _subscriptions = [];
  bool _isLoading = false;
  String? _error;

  List<ActiveSubscriptionModel> get subscriptions => _subscriptions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get auth token helper
  Future<String?> _getAuthToken() async {
    try {
      final storage = const FlutterSecureStorage();
      return await storage.read(key: 'auth_token');
    } catch (e) {
      debugPrint("Error getting auth token: $e");
      return null;
    }
  }

  // Load active subscriptions
  Future<void> loadActiveSubscriptions() async {
    // Don't trigger loading state if already loading
    if (_isLoading) return;

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final token = await _getAuthToken();
      if (token == null) {
        throw Exception("Authentication required. Please login again.");
      }

      _subscriptions = await _subscriptionService.getActiveSubscriptions(
        token: token,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      debugPrint("❌ Load Active Subscriptions Error: $e");
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}