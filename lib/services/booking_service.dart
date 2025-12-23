import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/booking_model.dart';

class BookingService {
  final String baseUrl = "http://13.49.66.20:5000/api/v1";

  /// Get user bookings
  /// GET /bookings?status=all&type=all&page=1&limit=20
  Future<List<BookingModel>> getUserBookings({
    required String token,
    String status = 'all',  // all|confirmed|completed|cancelled
    String type = 'all',    // all|service|membership
    int page = 1,
    int limit = 20,
  }) async {
    final url = Uri.parse("$baseUrl/bookings").replace(
      queryParameters: {
        'status': status,
        'type': type,
        'page': page.toString(),
        'limit': limit.toString(),
      },
    );

    debugPrint("✅ Get User Bookings API → $url");

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      debugPrint("✅ Get User Bookings Status: ${response.statusCode}");
      debugPrint("✅ Get User Bookings Body: ${response.body}");

      final result = jsonDecode(response.body);

      if (response.statusCode == 200 && result['success'] == true) {
        final data = result['data'];
        if (data == null) {
          throw Exception("No data found in response");
        }

        final List bookingsList = data['bookings'] ?? [];
        return bookingsList.map((b) => BookingModel.fromJson(b)).toList();
      } else {
        final error = result['error'];
        if (error != null && error['code'] == 'UNAUTHORIZED') {
          throw Exception("Session expired. Please login again.");
        } else {
          throw Exception(result['message'] ?? "Failed to load bookings");
        }
      }
    } catch (e) {
      debugPrint("❌ Get User Bookings API Error: $e");
      if (e is Exception) rethrow;
      throw Exception("Network error. Please check your connection.");
    }
  }

  /// Get available time slots for a service
  /// GET /gyms/{gym_id}/services/{service_id}/time-slots?date=2025-12-20
  Future<List<TimeSlotModel>> getTimeSlots({
    required String token,
    required String gymId,
    required String serviceId,
    required String date,  // YYYY-MM-DD format
  }) async {
    final url = Uri.parse("$baseUrl/gyms/$gymId/services/$serviceId/time-slots")
        .replace(queryParameters: {'date': date});

    debugPrint("✅ Get Time Slots API → $url");

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      debugPrint("✅ Get Time Slots Status: ${response.statusCode}");
      debugPrint("✅ Get Time Slots Body: ${response.body}");

      final result = jsonDecode(response.body);

      if (response.statusCode == 200 && result['success'] == true) {
        final data = result['data'];
        if (data == null) {
          throw Exception("No data found in response");
        }

        final slots = data['slots'];
        if (slots == null) {
          throw Exception("No slots found in response");
        }

        // Parse slots from all periods (morning, afternoon, evening)
        List<TimeSlotModel> allSlots = [];

        // Parse morning slots
        if (slots['morning'] != null) {
          final morningSlots = (slots['morning'] as List)
              .map((s) => TimeSlotModel.fromJson(s))
              .toList();
          allSlots.addAll(morningSlots);
        }

        // Parse afternoon slots
        if (slots['afternoon'] != null) {
          final afternoonSlots = (slots['afternoon'] as List)
              .map((s) => TimeSlotModel.fromJson(s))
              .toList();
          allSlots.addAll(afternoonSlots);
        }

        // Parse evening slots
        if (slots['evening'] != null) {
          final eveningSlots = (slots['evening'] as List)
              .map((s) => TimeSlotModel.fromJson(s))
              .toList();
          allSlots.addAll(eveningSlots);
        }

        debugPrint("✅ Loaded ${allSlots.length} time slots");
        return allSlots;
      } else {
        final error = result['error'];
        if (error != null && error['code'] == 'UNAUTHORIZED') {
          throw Exception("Session expired. Please login again.");
        } else {
          throw Exception(result['message'] ?? "Failed to load time slots");
        }
      }
    } catch (e) {
      debugPrint("❌ Get Time Slots API Error: $e");
      if (e is Exception) rethrow;
      throw Exception("Network error. Please check your connection.");
    }
  }
}