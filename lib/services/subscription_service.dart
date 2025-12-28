import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/models.dart';

class SubscriptionService {
  final String baseUrl = "http://13.49.66.20:5000/api/v1";

  // Get active subscriptions
  Future<List<ActiveSubscriptionModel>> getActiveSubscriptions({
    required String token,
  }) async {
    final url = Uri.parse("$baseUrl/subscriptions/active");

    debugPrint("✅ Get Active Subscriptions API called");

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      debugPrint("✅ Get Active Subscriptions Response: ${response.statusCode}");
      debugPrint("✅ Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        if (result['success'] == true && result['data'] != null) {
          final subscriptionsData = result['data']['subscriptions'] as List<dynamic>;

          return subscriptionsData
              .map((sub) => ActiveSubscriptionModel.fromJson(sub))
              .toList();
        } else {
          throw Exception(result['message'] ?? "Failed to fetch subscriptions");
        }
      } else {
        final result = jsonDecode(response.body);
        throw Exception(result['message'] ?? "Failed to fetch subscriptions");
      }
    } catch (e) {
      debugPrint("❌ Get Active Subscriptions Error: $e");
      rethrow;
    }
  }
}

// Active Subscription Model based on API response
class ActiveSubscriptionModel {
  final String id;
  final String planId;
  final String type; // single_gym or multi_gym
  final String duration; // 1_month, 3_months, etc.
  final String durationLabel; // "1 Month", "3 Months"
  final String? gymId;
  final String? gymName;
  final String? gymAddress;
  final String? gymImage;
  final DateTime startDate;
  final DateTime endDate;
  final int daysRemaining;
  final bool isActive;
  final bool autoRenew;
  final String? qrCode;
  final DateTime createdAt;

  ActiveSubscriptionModel({
    required this.id,
    required this.planId,
    required this.type,
    required this.duration,
    required this.durationLabel,
    this.gymId,
    this.gymName,
    this.gymAddress,
    this.gymImage,
    required this.startDate,
    required this.endDate,
    required this.daysRemaining,
    required this.isActive,
    required this.autoRenew,
    this.qrCode,
    required this.createdAt,
  });

  factory ActiveSubscriptionModel.fromJson(Map<String, dynamic> json) {
    return ActiveSubscriptionModel(
      id: json['id'] ?? '',
      planId: json['plan_id'] ?? '',
      type: json['type'] ?? 'single_gym',
      duration: json['duration'] ?? '',
      durationLabel: json['duration_label'] ?? '',
      gymId: json['gym_id'],
      gymName: json['gym_name'],
      gymAddress: json['gym_address'],
      gymImage: json['gym_image'],
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : DateTime.now(),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : DateTime.now(),
      daysRemaining: json['days_remaining'] ?? 0,
      isActive: json['is_active'] ?? false,
      autoRenew: json['auto_renew'] ?? false,
      qrCode: json['qr_code'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plan_id': planId,
      'type': type,
      'duration': duration,
      'duration_label': durationLabel,
      'gym_id': gymId,
      'gym_name': gymName,
      'gym_address': gymAddress,
      'gym_image': gymImage,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'days_remaining': daysRemaining,
      'is_active': isActive,
      'auto_renew': autoRenew,
      'qr_code': qrCode,
      'created_at': createdAt.toIso8601String(),
    };
  }
}