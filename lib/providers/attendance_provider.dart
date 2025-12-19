import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

class AttendanceProvider extends ChangeNotifier {
  Map<DateTime, bool> _attendanceData = {};
  DateTime _selectedMonth = DateTime.now();
  bool _isLoading = false;
  String? _error;
  bool _showRatePrompt = false;
  String? _lastVisitedGymId;
  String? _lastVisitedGymName;

  Map<DateTime, bool> get attendanceData => _attendanceData;
  DateTime get selectedMonth => _selectedMonth;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get showRatePrompt => _showRatePrompt;
  String? get lastVisitedGymId => _lastVisitedGymId;
  String? get lastVisitedGymName => _lastVisitedGymName;

  int get presentDays {
    return _attendanceData.values.where((v) => v).length;
  }

  int get absentDays {
    return _attendanceData.values.where((v) => !v).length;
  }

  double get attendancePercentage {
    if (_attendanceData.isEmpty) return 0;
    return (presentDays / _attendanceData.length) * 100;
  }

  String get dateRangeText {
    final start = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final end = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    return '${start.day} ${_getMonthName(start.month).toLowerCase()} - ${end.day} ${_getMonthName(end.month).toLowerCase()}';
  }

  Future<void> loadAttendance() async {
    if (_isLoading) return; // Prevent duplicate calls

    try {
      _isLoading = true;
      // Don't call notifyListeners() here to avoid setState during build

      await Future.delayed(const Duration(milliseconds: 500));
      _attendanceData = MockData.attendanceData;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  void changeMonth(int delta) {
    _selectedMonth = DateTime(
      _selectedMonth.year,
      _selectedMonth.month + delta,
      1,
    );
    notifyListeners();
  }

  void setMonth(DateTime month) {
    _selectedMonth = DateTime(month.year, month.month, 1);
    notifyListeners();
  }

  Future<bool> markAttendance(String gymId, String gymName) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final today = DateTime.now();
      final dateKey = DateTime(today.year, today.month, today.day);
      _attendanceData[dateKey] = true;

      // Show rate prompt after first session
      _showRatePrompt = true;
      _lastVisitedGymId = gymId;
      _lastVisitedGymName = gymName;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void dismissRatePrompt() {
    _showRatePrompt = false;
    _lastVisitedGymId = null;
    _lastVisitedGymName = null;
    notifyListeners();
  }

  bool? getAttendanceForDate(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    return _attendanceData[dateKey];
  }

  List<DateTime> getPresentDates() {
    return _attendanceData.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();
  }

  List<DateTime> getAbsentDates() {
    return _attendanceData.entries
        .where((e) => !e.value)
        .map((e) => e.key)
        .toList();
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
