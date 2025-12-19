class GymModel {
  final String id;
  final String name;
  final String address;
  final String locality;
  final String city;
  final String pincode;
  final double latitude;
  final double longitude;
  final double distance;
  final double rating;
  final int reviewCount;
  final int pricePerDay;
  final bool is24x7;
  final bool hasTrainer;
  final List<String> images;
  final String? aboutUs;
  final List<FacilityModel> facilities;
  final List<ServiceModel> services;
  final List<EquipmentModel> equipments;
  final List<BusinessHours> businessHours;
  final bool isOpen;

  GymModel({
    required this.id,
    required this.name,
    required this.address,
    required this.locality,
    required this.city,
    required this.pincode,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.rating,
    required this.reviewCount,
    required this.pricePerDay,
    this.is24x7 = false,
    this.hasTrainer = false,
    this.images = const [],
    this.aboutUs,
    this.facilities = const [],
    this.services = const [],
    this.equipments = const [],
    this.businessHours = const [],
    this.isOpen = true,
  });

  factory GymModel.fromJson(Map<String, dynamic> json) {
    return GymModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      locality: json['locality'] ?? '',
      city: json['city'] ?? '',
      pincode: json['pincode'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      distance: (json['distance'] ?? 0.0).toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['review_count'] ?? json['reviewCount'] ?? 0,
      pricePerDay: json['price_per_day'] ?? json['pricePerDay'] ?? 0,
      is24x7: json['is_24x7'] ?? json['is24x7'] ?? false,
      hasTrainer: json['has_trainer'] ?? json['hasTrainer'] ?? false,
      images: List<String>.from(json['images'] ?? []),
      aboutUs: json['about_us'] ?? json['aboutUs'],
      facilities: (json['facilities'] as List<dynamic>?)
              ?.map((f) => FacilityModel.fromJson(f))
              .toList() ??
          [],
      services: (json['services'] as List<dynamic>?)
              ?.map((s) => ServiceModel.fromJson(s))
              .toList() ??
          [],
      equipments: (json['equipments'] as List<dynamic>?)
              ?.map((e) => EquipmentModel.fromJson(e))
              .toList() ??
          [],
      businessHours: (json['business_hours'] as List<dynamic>?)
              ?.map((b) => BusinessHours.fromJson(b))
              .toList() ??
          [],
      isOpen: json['is_open'] ?? json['isOpen'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'locality': locality,
      'city': city,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
      'rating': rating,
      'review_count': reviewCount,
      'price_per_day': pricePerDay,
      'is_24x7': is24x7,
      'has_trainer': hasTrainer,
      'images': images,
      'about_us': aboutUs,
      'facilities': facilities.map((f) => f.toJson()).toList(),
      'services': services.map((s) => s.toJson()).toList(),
      'equipments': equipments.map((e) => e.toJson()).toList(),
      'business_hours': businessHours.map((b) => b.toJson()).toList(),
      'is_open': isOpen,
    };
  }

  String get fullAddress => '$address, $locality, $city - $pincode';
}

class FacilityModel {
  final String id;
  final String name;
  final String? icon;
  final bool isAvailable;

  FacilityModel({
    required this.id,
    required this.name,
    this.icon,
    this.isAvailable = true,
  });

  factory FacilityModel.fromJson(Map<String, dynamic> json) {
    return FacilityModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'],
      isAvailable: json['is_available'] ?? json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'is_available': isAvailable,
    };
  }
}

class ServiceModel {
  final String id;
  final String name;
  final String? image;
  final int pricePerSlot;
  final String? schedule;
  final String? timing;
  final List<String>? availableDays;

  ServiceModel({
    required this.id,
    required this.name,
    this.image,
    required this.pricePerSlot,
    this.schedule,
    this.timing,
    this.availableDays,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'],
      pricePerSlot: json['price_per_slot'] ?? json['pricePerSlot'] ?? 0,
      schedule: json['schedule'],
      timing: json['timing'],
      availableDays: json['available_days'] != null
          ? List<String>.from(json['available_days'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price_per_slot': pricePerSlot,
      'schedule': schedule,
      'timing': timing,
      'available_days': availableDays,
    };
  }
}

class EquipmentModel {
  final String id;
  final String name;
  final String? image;
  final int? quantity;

  EquipmentModel({
    required this.id,
    required this.name,
    this.image,
    this.quantity,
  });

  factory EquipmentModel.fromJson(Map<String, dynamic> json) {
    return EquipmentModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'quantity': quantity,
    };
  }
}

class BusinessHours {
  final String day;
  final bool isOpen;
  final String? openTime;
  final String? closeTime;

  BusinessHours({
    required this.day,
    required this.isOpen,
    this.openTime,
    this.closeTime,
  });

  factory BusinessHours.fromJson(Map<String, dynamic> json) {
    return BusinessHours(
      day: json['day'] ?? '',
      isOpen: json['is_open'] ?? json['isOpen'] ?? false,
      openTime: json['open_time'] ?? json['openTime'],
      closeTime: json['close_time'] ?? json['closeTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'is_open': isOpen,
      'open_time': openTime,
      'close_time': closeTime,
    };
  }
}
