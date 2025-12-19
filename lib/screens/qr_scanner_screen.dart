import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../core/constants/constants.dart';
import '../providers/providers.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController? _controller;
  bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (!_isScanning) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final barcode = barcodes.first;
    if (barcode.rawValue == null) return;

    setState(() => _isScanning = false);

    // Process QR code
    final qrData = barcode.rawValue!;
    
    // For demo, assume QR contains gym ID
    final attendanceProvider = context.read<AttendanceProvider>();
    final success = await attendanceProvider.markAttendance(
      qrData,
      'Zinga Fitness & Training', // In real app, get from QR data
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Attendance marked successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      } else {
        setState(() => _isScanning = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(attendanceProvider.error ?? 'Failed to mark attendance'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Camera view
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),

          // Overlay
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            ),
          ),

          // Scan area
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primaryGreen,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          // Header
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.h16,
                Text(
                  'Capture QR Code',
                  style: AppTextStyles.heading3,
                ),
                AppSpacing.h8,
                Text(
                  'food image or barcode',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Capture button
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  // Manual capture if needed
                },
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.textPrimary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryGreen,
                      width: 4,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Loading overlay
          if (!_isScanning)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
