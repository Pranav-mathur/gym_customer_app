import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

class BookingProvider extends ChangeNotifier {
  // Booking state
  GymModel? _selectedGym;
  ServiceModel? _selectedService;
  DateTime? _selectedDate;
  TimeSlotModel? _selectedTimeSlot;
  int _slotCount = 1;
  String _bookingFor = '';
  AddressModel? _serviceLocation;

  // Subscription state
  String _subscriptionType = 'single_gym'; // single_gym or multi_gym
  SubscriptionModel? _selectedPlan;

  // General state
  List<BookingModel> _bookings = [];
  List<TimeSlotModel> _availableSlots = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  GymModel? get selectedGym => _selectedGym;
  ServiceModel? get selectedService => _selectedService;
  DateTime? get selectedDate => _selectedDate;
  TimeSlotModel? get selectedTimeSlot => _selectedTimeSlot;
  int get slotCount => _slotCount;
  String get bookingFor => _bookingFor;
  AddressModel? get serviceLocation => _serviceLocation;
  String get subscriptionType => _subscriptionType;
  SubscriptionModel? get selectedPlan => _selectedPlan;
  List<BookingModel> get bookings => _bookings;
  List<TimeSlotModel> get availableSlots => _availableSlots;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Price calculations
  double get serviceTotal {
    if (_selectedService == null) return 0;
    return _selectedService!.pricePerSlot * _slotCount.toDouble();
  }

  double get visitingFee => 99;
  double get tax => (serviceTotal * 0.18);
  double get totalAmount => serviceTotal + visitingFee + tax;

  // Initialize booking for a gym
  void initializeBooking(GymModel gym) {
    _selectedGym = gym;
    _selectedService = null;
    _selectedDate = DateTime.now();
    _selectedTimeSlot = null;
    _slotCount = 1;
    _loadAvailableSlots();
    notifyListeners();
  }

  // Select service
  void selectService(ServiceModel service) {
    _selectedService = service;
    notifyListeners();
  }

  // Select date
  void selectDate(DateTime date) {
    _selectedDate = date;
    _loadAvailableSlots();
    notifyListeners();
  }

  // Select time slot
  void selectTimeSlot(TimeSlotModel slot) {
    _selectedTimeSlot = slot;
    notifyListeners();
  }

  // Update slot count
  void updateSlotCount(int count) {
    if (count >= 1 && count <= 10) {
      _slotCount = count;
      notifyListeners();
    }
  }

  void incrementSlots() {
    if (_slotCount < 10) {
      _slotCount++;
      notifyListeners();
    }
  }

  void decrementSlots() {
    if (_slotCount > 1) {
      _slotCount--;
      notifyListeners();
    }
  }

  // Set booking for
  void setBookingFor(String name) {
    _bookingFor = name;
    notifyListeners();
  }

  // Set service location
  void setServiceLocation(AddressModel address) {
    _serviceLocation = address;
    notifyListeners();
  }

  // Subscription methods
  void setSubscriptionType(String type) {
    _subscriptionType = type;
    _selectedPlan = null;
    notifyListeners();
  }

  void selectPlan(SubscriptionModel plan) {
    _selectedPlan = plan;
    notifyListeners();
  }

  List<SubscriptionModel> getPlansForType(String type) {
    return MockData.subscriptionPlans
        .where((plan) => plan.type == type)
        .toList();
  }

  // Load available time slots
  void _loadAvailableSlots() {
    _availableSlots = MockData.timeSlots;
    notifyListeners();
  }

  // Load user bookings
  Future<void> loadBookings() async {
    try {
      _isLoading = true;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 500));
      _bookings = MockData.bookings;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Create service booking
  Future<BookingModel?> createServiceBooking() async {
    if (_selectedGym == null || _selectedService == null || 
        _selectedDate == null || _selectedTimeSlot == null) {
      _error = 'Please complete all booking details';
      notifyListeners();
      return null;
    }

    try {
      _isLoading = true;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 1));

      final booking = BookingModel(
        id: 'booking_${DateTime.now().millisecondsSinceEpoch}',
        gymId: _selectedGym!.id,
        gymName: _selectedGym!.name,
        gymAddress: _selectedGym!.fullAddress,
        type: BookingType.service,
        status: BookingStatus.confirmed,
        serviceId: _selectedService!.id,
        serviceName: _selectedService!.name,
        slots: _slotCount,
        bookingDate: _selectedDate!,
        timeSlot: _selectedTimeSlot!.label,
        bookingFor: _bookingFor,
        amount: serviceTotal,
        visitingFee: visitingFee,
        tax: tax,
        totalAmount: totalAmount,
        createdAt: DateTime.now(),
        instructions: '1. Arrive 5mins early to ensure timely entry\n2. Bring mobile, water bottle and workout shoes,',
      );

      _bookings.insert(0, booking);
      _isLoading = false;
      notifyListeners();

      return booking;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Create membership booking
  Future<BookingModel?> createMembershipBooking() async {
    if (_selectedGym == null || _selectedPlan == null) {
      _error = 'Please select a subscription plan';
      notifyListeners();
      return null;
    }

    try {
      _isLoading = true;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 1));

      final booking = BookingModel(
        id: 'booking_${DateTime.now().millisecondsSinceEpoch}',
        gymId: _subscriptionType == 'single_gym' ? _selectedGym!.id : '',
        gymName: _subscriptionType == 'single_gym' ? _selectedGym!.name : 'Multi Gym Access',
        gymAddress: _subscriptionType == 'single_gym' ? _selectedGym!.fullAddress : 'Access to all 112 Pro Gyms',
        type: BookingType.membership,
        status: BookingStatus.confirmed,
        bookingDate: DateTime.now(),
        membershipType: '${_subscriptionType == 'single_gym' ? 'Single Gym' : 'Multi Gym'} - ${_selectedPlan!.durationLabel}',
        bookingFor: _bookingFor,
        amount: _selectedPlan!.price.toDouble(),
        totalAmount: _selectedPlan!.price.toDouble(),
        createdAt: DateTime.now(),
        instructions: '1. Arrive 5mins early to ensure timely entry\n2. Bring mobile, water bottle and workout shoes,',
      );

      _bookings.insert(0, booking);
      _isLoading = false;
      notifyListeners();

      return booking;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Reset booking state
  void resetBooking() {
    _selectedService = null;
    _selectedDate = DateTime.now();
    _selectedTimeSlot = null;
    _slotCount = 1;
    _bookingFor = '';
    _serviceLocation = null;
    _selectedPlan = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
