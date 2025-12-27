import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/constants.dart';
import '../core/widgets/widgets.dart';
import '../providers/providers.dart';
import 'home_screen.dart';
import 'attendance_screen.dart';
import 'subscription_screen.dart';
import 'set_location_screen.dart';
import 'notification_screen.dart';
import 'side_menu_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(showAppBar: false),
    AttendanceScreen(showAppBar: false),
    SubscriptionScreen(showAppBar: false),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final homeProvider = context.read<HomeProvider>();
    final attendanceProvider = context.read<AttendanceProvider>();
    final authProvider = context.read<AuthProvider>();
    final locationProvider = context.read<LocationProvider>();

    await locationProvider.loadSavedLocation();

    final token = authProvider.token;

    if (token != null) {
      await Future.wait([
        homeProvider.loadGyms(token: token),
        homeProvider.loadUserProfile(token),
        homeProvider.loadBanners(),
        attendanceProvider.loadAttendance(),
      ]);
    } else {
      await homeProvider.loadBanners();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      endDrawer: const SideMenuScreen(),
      body: SafeArea(
        child: Column(
          children: [
            // Common HomeAppBar for all tabs
            Consumer<AddressProvider>(
              builder: (context, addressProvider, child) {
                final defaultAddress = addressProvider.defaultAddress;

                return HomeAppBar(
                  location: defaultAddress?.roadArea ?? 'Set Location',
                  address: defaultAddress?.fullAddress ?? 'Tap to set your location',
                  onLocationTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SetLocationScreen(),
                      ),
                    );
                  },
                  onNotificationTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationScreen(),
                      ),
                    );
                  },
                  onMenuTap: () {
                    _scaffoldKey.currentState?.openEndDrawer();
                  },
                );
              },
            ),

            // Tab content
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: _screens,
              ),
            ),
          ],
        ),
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