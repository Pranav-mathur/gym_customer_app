import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/constants.dart';
import '../core/widgets/widgets.dart';
import '../providers/providers.dart';
import 'home_screen.dart';
import 'attendance_screen.dart';
import 'subscription_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    AttendanceScreen(),
    SubscriptionScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Load initial data
    final homeProvider = context.read<HomeProvider>();
    final attendanceProvider = context.read<AttendanceProvider>();
    final authProvider = context.read<AuthProvider>();
    final locationProvider = context.read<LocationProvider>();

    // CRITICAL: Load saved location FIRST so address bar shows correctly
    await locationProvider.loadSavedLocation();

    // Get token from auth provider
    final token = authProvider.token;

    if (token != null) {
      await Future.wait([
        homeProvider.loadGyms(token: token),
        homeProvider.loadUserProfile(token),  // Load user profile
        attendanceProvider.loadAttendance(),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}