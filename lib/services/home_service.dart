import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../models/models.dart';

class HomeService {
  // Update this with your actual base URL
  final String baseUrl = "http://13.49.66.20:5000/api/v1";

  Future<List<GymModel>> fetchGyms({
    required String token,
    double? latitude,
    double? longitude,
  }) async {
    final queryParams = <String, String>{};

    if (latitude != null) queryParams['lat'] = latitude.toString();
    if (longitude != null) queryParams['lng'] = longitude.toString();

    final uri = Uri.parse("$baseUrl/gyms").replace(  // ✅ Changed from /home/gyms to /gyms
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );

    debugPrint("✅ Fetch Gyms API → $uri");
    debugPrint("✅ Fetch Gyms API token → $token");

    try {
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",  // ✅ Added Bearer token
        },
      );

      debugPrint("✅ Fetch Gyms Status: ${response.statusCode}");
      debugPrint("✅ Fetch Gyms Body: ${response.body}");

      final result = jsonDecode(response.body);

      if (response.statusCode == 200 && result['success'] == true) {
        // ✅ Extract gyms from nested structure: data.gyms
        final data = result['data'];
        if (data == null) {
          throw Exception("No data found in response");
        }

        final List list = data['gyms'] ?? [];  // ✅ Changed from result['data'] to data['gyms']
        return list.map((e) => GymModel.fromJson(e)).toList();
      } else {
        // Handle error response
        final error = result['error'];
        if (error != null && error['code'] == 'UNAUTHORIZED') {
          throw Exception("Session expired. Please login again.");
        } else {
          throw Exception(result['message'] ?? "Failed to load gyms");
        }
      }
    } catch (e) {
      debugPrint("❌ Fetch Gyms API Error: $e");
      if (e is Exception) rethrow;
      throw Exception("Network error. Please check your connection.");
    }
  }

  Future<GymModel> getGymDetails({
    required String token,
    required String gymId,
  }) async {
    final uri = Uri.parse("$baseUrl/gyms/$gymId");

    debugPrint("✅ Get Gym Details API → $uri");

    try {
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      debugPrint("✅ Get Gym Details Status: ${response.statusCode}");
      debugPrint("✅ Get Gym Details Body: ${response.body}");

      final result = jsonDecode(response.body);

      if (response.statusCode == 200 && result['success'] == true) {
        final data = result['data'];
        if (data == null) {
          throw Exception("No data found in response");
        }

        final gymData = data['gym'];
        if (gymData == null) {
          throw Exception("Gym details not found");
        }

        return GymModel.fromJson(gymData);
      } else {
        final error = result['error'];
        if (error != null && error['code'] == 'UNAUTHORIZED') {
          throw Exception("Session expired. Please login again.");
        } else {
          throw Exception(result['message'] ?? "Failed to load gym details");
        }
      }
    } catch (e) {
      debugPrint("❌ Get Gym Details API Error: $e");
      if (e is Exception) rethrow;
      throw Exception("Network error. Please check your connection.");
    }
  }

  Future<List<BannerModel>> fetchBanners() async {
    // Banner API uses different base URL
    final uri = Uri.parse("http://ec2-13-49-66-20.eu-north-1.compute.amazonaws.com:3000/api/v1/uploads/documents");

    debugPrint("✅ Fetch Banners API → $uri");

    try {
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      debugPrint("✅ Fetch Banners Status: ${response.statusCode}");
      debugPrint("✅ Fetch Banners Body: ${response.body}");

      final result = jsonDecode(response.body);

      if (response.statusCode == 200 && result['success'] == true) {
        final bannerResponse = BannerResponse.fromJson(result);
        debugPrint("✅ Loaded ${bannerResponse.banners.length} banner images");
        return bannerResponse.banners;
      } else {
        throw Exception(result['message'] ?? "Failed to load banners");
      }
    } catch (e) {
      debugPrint("❌ Fetch Banners API Error: $e");
      // Return empty list instead of throwing error to prevent blocking UI
      return [];
    }
  }
}