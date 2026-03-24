import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/models.dart';
import '../services/subscription_service.dart';

class SubscriptionProvider extends ChangeNotifier {
  final SubscriptionService _subscriptionService = SubscriptionService();

  // ─── Active Subscriptions state ─────────────────────────────────────────

  List<ActiveSubscriptionModel> _subscriptions = [];
  bool _isLoading = false;
  String? _error;

  List<ActiveSubscriptionModel> get subscriptions => _subscriptions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ─── Multi-Gym Pricing state ─────────────────────────────────────────────

  List<MultiGymPricingModel> _multiGymPricing = [];
  bool _isPricingLoading = false;
  String? _pricingError;
  bool _pricingLoaded = false; // guard to avoid redundant fetches

  bool get isPricingLoading => _isPricingLoading;
  String? get pricingError => _pricingError;

  /// Raw pricing models (useful if you need tax/discount breakdown in the UI).
  List<MultiGymPricingModel> get multiGymPricing => _multiGymPricing;

  /// Converted to [SubscriptionModel] list so the existing booking flow
  /// works with zero changes.
  List<SubscriptionModel> get multiGymPlans =>
      _multiGymPricing.map((p) => p.toSubscriptionModel()).toList();

  // ─── Helpers ─────────────────────────────────────────────────────────────

  Future<String?> _getAuthToken() async {
    try {
      return await const FlutterSecureStorage().read(key: 'auth_token');
    } catch (e) {
      debugPrint("Error getting auth token: $e");
      return null;
    }
  }

  // ─── Active Subscriptions ────────────────────────────────────────────────

  Future<void> loadActiveSubscriptions() async {
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

  // ─── Multi-Gym Pricing ───────────────────────────────────────────────────

  /// Fetches multi-gym pricing from the API.
  /// Pass [forceRefresh: true] to bypass the already-loaded guard.
  Future<void> fetchMultiGymPricing({bool forceRefresh = false}) async {
    if (_isPricingLoading) return;
    if (_pricingLoaded && !forceRefresh) return;

    try {
      _isPricingLoading = true;
      _pricingError = null;
      notifyListeners();

      final token = await _getAuthToken();
      if (token == null) {
        throw Exception("Authentication required. Please login again.");
      }

      _multiGymPricing = await _subscriptionService.fetchMultiGymPricing(
        token: token,
      );

      _pricingLoaded = true;
      _isPricingLoading = false;
      notifyListeners();

      debugPrint("✅ Multi-Gym Pricing loaded: ${_multiGymPricing.length} tiers");
    } catch (e) {
      _isPricingLoading = false;
      _pricingError = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      debugPrint("❌ Fetch Multi-Gym Pricing Error: $e");
    }
  }

  // ─── Error helpers ───────────────────────────────────────────────────────

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearPricingError() {
    _pricingError = null;
    notifyListeners();
  }
}