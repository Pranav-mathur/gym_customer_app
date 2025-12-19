import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../models/models.dart';
import '../core/constants/constants.dart';

final String baseUrl = "http://13.49.66.20:5000/api/v1";

class HomeService {
  static final HomeService _instance = HomeService._internal();
  factory HomeService() => _instance;
  HomeService._internal();

  Future<List<GymModel>> fetchGyms({
    double? latitude,
    double? longitude,
  }) async {
    final queryParams = <String, String>{};

    if (latitude != null) queryParams['lat'] = latitude.toString();
    if (longitude != null) queryParams['lng'] = longitude.toString();

    final uri = Uri.parse("$baseUrl/home/gyms").replace(
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );

    debugPrint("📡 Fetch Gyms API → $uri");

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    debugPrint("📡 Fetch Gyms Status: ${response.statusCode}");
    debugPrint("📡 Fetch Gyms Body: ${response.body}");

    final result = jsonDecode(response.body);

    if (response.statusCode == 200 && result['success'] == true) {
      final List list = result['data'] ?? [];
      return list.map((e) => GymModel.fromJson(e)).toList();
    }

    throw Exception(result['message'] ?? "Failed to load gyms");
  }}

