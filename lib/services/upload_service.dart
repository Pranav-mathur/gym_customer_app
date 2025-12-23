import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

class UploadService {
  final String baseUrl = "http://13.49.66.20:3000/api/v1";

  /// Upload file using presigned URL approach
  /// Returns the final uploaded file URL
  Future<String> uploadFile({
    required String token,
    required File file,
  }) async {
    try {
      final fileName = path.basename(file.path);
      debugPrint("✅ Uploading file: $fileName");

      // Read file as bytes
      final fileBytes = await file.readAsBytes();

      // Call presign API
      final url = Uri.parse("$baseUrl/uploads/presign");

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/octet-stream",
          "x-file-name": fileName,
        },
        body: fileBytes,
      );

      debugPrint("✅ Presign Upload Status: ${response.statusCode}");
      debugPrint("✅ Presign Upload Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = jsonDecode(response.body);

        // Extract uploaded URL from response
        // Adjust this based on actual API response structure
        String? uploadedUrl;

        if (result['success'] == true) {
          // Try different possible response structures
          uploadedUrl = result['data']?['view_url'] ??
              result['data']?['fileUrl'] ??
              result['data']?['uploadUrl'] ??
              result['url'] ??
              result['fileUrl'];
        }

        if (uploadedUrl != null && uploadedUrl.isNotEmpty) {
          debugPrint("✅ File uploaded successfully: $uploadedUrl");
          return uploadedUrl;
        } else {
          throw Exception("Upload URL not found in response");
        }
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? "Failed to upload file");
      }
    } catch (e) {
      debugPrint("❌ Upload File Error: $e");
      if (e is Exception) rethrow;
      throw Exception("Failed to upload file. Please try again.");
    }
  }
}