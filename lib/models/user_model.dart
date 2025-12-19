class UserModel {
  final String? id;
  final String phoneNumber;
  final String? name;
  final String? email;
  final String? gender;
  final String? profileImage;
  final DateTime? createdAt;

  UserModel({
    this.id,
    required this.phoneNumber,
    this.name,
    this.email,
    this.gender,
    this.profileImage,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      phoneNumber: json['phone_number'] ?? json['phoneNumber'] ?? '',
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      profileImage: json['profile_image'] ?? json['profileImage'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone_number': phoneNumber,
      'name': name,
      'email': email,
      'gender': gender,
      'profile_image': profileImage,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? phoneNumber,
    String? name,
    String? email,
    String? gender,
    String? profileImage,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get isProfileComplete => name != null && name!.isNotEmpty;
}

class AuthResponse {
  final bool success;
  final String? message;
  final String? token;
  final UserModel? user;
  final bool isNewUser;

  AuthResponse({
    required this.success,
    this.message,
    this.token,
    this.user,
    this.isNewUser = false,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'],
      token: json['token'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      isNewUser: json['is_new_user'] ?? json['isNewUser'] ?? false,
    );
  }
}

class OtpResponse {
  final bool success;
  final String? message;
  final String? otp; // Only for development/testing

  OtpResponse({
    required this.success,
    this.message,
    this.otp,
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      success: json['success'] ?? false,
      message: json['message'],
      otp: json['otp'],
    );
  }
}
