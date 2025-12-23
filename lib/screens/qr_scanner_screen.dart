import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/constants.dart';
import '../providers/providers.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool _isProcessing = false;
  final TextEditingController _customQRController = TextEditingController();
  final TextEditingController _gymIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill with default gym ID
    _gymIdController.text = 'GYM_30dff536933645d8';
  }

  @override
  void dispose() {
    _customQRController.dispose();
    _gymIdController.dispose();
    super.dispose();
  }

  Future<void> _scanCustomQR() async {
    final qrData = _customQRController.text.trim();
    final gymId = _gymIdController.text.trim();

    if (qrData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter QR code data'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (gymId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter Gym ID'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isProcessing = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Testing with custom QR code...'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 1),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 500));
    await _processQRCode(qrData, gymId);
  }

  Future<void> _processQRCode(String qrData, String gymId) async {
    try {
      debugPrint("✅ QR Code Data: $qrData");
      debugPrint("✅ Gym ID: $gymId");

      if (qrData.isEmpty || gymId.isEmpty) {
        throw Exception("QR code and Gym ID are required");
      }

      // Get user location
      final locationProvider = context.read<LocationProvider>();
      final location = locationProvider.currentLocation;

      if (location == null) {
        throw Exception("Location not available. Please enable location services.");
      }

      debugPrint("✅ Location: ${location.latitude}, ${location.longitude}");

      // Call check-in API
      final attendanceProvider = context.read<AttendanceProvider>();
      debugPrint("🔄 Calling check-in API...");
      debugPrint("📤 Payload:");
      debugPrint("   qr_code: $qrData");
      debugPrint("   gym_id: $gymId");
      debugPrint("   latitude: ${location.latitude}");
      debugPrint("   longitude: ${location.longitude}");

      final result = await attendanceProvider.checkIn(
        qrCode: qrData,
        gymId: gymId,
        latitude: location.latitude,
        longitude: location.longitude,
      );

      if (!mounted) return;

      debugPrint("📥 Result: ${result['success']}");

      if (result['success'] == true) {
        debugPrint("✅ Check-in successful!");
        await attendanceProvider.loadAttendance();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Check-in successful!'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 3),
          ),
        );

        Navigator.pop(context, true);
      } else {
        debugPrint("❌ Check-in failed: ${result['message']}");

        if (!mounted) return;

        setState(() => _isProcessing = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Check-in failed'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() => _isProcessing = false);

      debugPrint("❌ Error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'QR Scanner (Test Mode)',
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Warning notice
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 24),
                      AppSpacing.w12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Need Real QR Code from Backend',
                              style: AppTextStyles.labelLarge.copyWith(color: Colors.orange),
                            ),
                            AppSpacing.h4,
                            Text(
                              'The backend validates QR codes. You need the actual QR string (not just gym ID).',
                              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                AppSpacing.h24,

                Text('Test with Custom QR Code', style: AppTextStyles.heading4),
                AppSpacing.h8,
                Text(
                  'Enter the actual QR code data from your backend',
                  style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                ),
                AppSpacing.h16,

                // QR Code input
                Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.cardGradient,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    controller: _customQRController,
                    maxLines: 3,
                    style: AppTextStyles.bodyMedium,
                    decoration: InputDecoration(
                      labelText: 'QR Code Data',
                      hintText: 'Paste full QR code string from backend...',
                      hintStyle: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      labelStyle: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryGreen),
                    ),
                  ),
                ),

                AppSpacing.h12,

                // Gym ID input
                Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.cardGradient,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    controller: _gymIdController,
                    style: AppTextStyles.bodyMedium,
                    decoration: InputDecoration(
                      labelText: 'Gym ID',
                      hintText: 'GYM_30dff536933645d8',
                      hintStyle: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      labelStyle: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryGreen),
                    ),
                  ),
                ),

                AppSpacing.h16,

                // Test button
                ElevatedButton(
                  onPressed: _isProcessing ? null : _scanCustomQR,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: AppColors.primaryDark,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.qr_code_scanner),
                      AppSpacing.w8,
                      const Text('Test Check-in', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),

                AppSpacing.h32,

                // Instructions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: AppColors.cardGradient,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGreen.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.info_outline, color: AppColors.primaryGreen, size: 20),
                          ),
                          AppSpacing.w12,
                          Text('How to Get Real QR', style: AppTextStyles.labelLarge.copyWith(color: AppColors.primaryGreen)),
                        ],
                      ),
                      AppSpacing.h12,
                      Text(
                        '1. Contact your backend team\n'
                            '2. Ask for a test QR code for gym: GYM_30dff536933645d8\n'
                            '3. They provide the full QR string (might be encrypted)\n'
                            '4. Paste that string above\n'
                            '5. Tap "Test Check-in"',
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, height: 1.5),
                      ),
                    ],
                  ),
                ),

                AppSpacing.h24,

                // Error explanation
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.error),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                          AppSpacing.w8,
                          Text('Why "INVALID_QR"?', style: AppTextStyles.labelMedium.copyWith(color: AppColors.error)),
                        ],
                      ),
                      AppSpacing.h8,
                      Text(
                        'Backend validates QR codes to prevent fake check-ins. '
                            'Real QR codes have security signatures. '
                            'Just using gym_id won\'t work.',
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, height: 1.5),
                      ),
                    ],
                  ),
                ),

                AppSpacing.h24,

                // Location status
                Consumer<LocationProvider>(
                  builder: (context, provider, _) {
                    final hasLocation = provider.currentLocation != null;
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: hasLocation ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: hasLocation ? AppColors.success : AppColors.error),
                      ),
                      child: Row(
                        children: [
                          Icon(hasLocation ? Icons.check_circle : Icons.error_outline,
                              color: hasLocation ? AppColors.success : AppColors.error),
                          AppSpacing.w12,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hasLocation ? 'Location Available' : 'Location Required',
                                  style: AppTextStyles.labelMedium.copyWith(
                                      color: hasLocation ? AppColors.success : AppColors.error),
                                ),
                                if (hasLocation) ...[
                                  AppSpacing.h4,
                                  Text(
                                    'Lat: ${provider.currentLocation!.latitude.toStringAsFixed(4)}, '
                                        'Lng: ${provider.currentLocation!.longitude.toStringAsFixed(4)}',
                                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Loading overlay
          if (_isProcessing)
            Container(
              color: Colors.black87,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: AppColors.primaryGreen),
                    AppSpacing.h16,
                    Text('Processing check-in...', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textPrimary)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}