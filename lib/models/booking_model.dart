enum BookingType { service, membership }

enum BookingStatus { pending, confirmed, completed, cancelled }

class BookingModel {
  final String id;
  final String? bookingNumber;
  final String gymId;
  final String gymName;
  final String gymAddress;
  final String? gymImage;
  final BookingType type;
  final BookingStatus status;
  final String? serviceId;
  final String? serviceName;
  final int? slots;
  final DateTime bookingDate;
  final String? timeSlot;
  final String? membershipType;
  final String bookingFor;
  final double amount;
  final double? visitingFee;
  final double? tax;
  final double totalAmount;
  final String? paymentMethod;
  final String? paymentId;
  final String? paymentStatus;
  final DateTime createdAt;
  final String? instructions;
  final String? qrCode;

  BookingModel({
    required this.id,
    this.bookingNumber,
    required this.gymId,
    required this.gymName,
    required this.gymAddress,
    this.gymImage,
    required this.type,
    required this.status,
    this.serviceId,
    this.serviceName,
    this.slots,
    required this.bookingDate,
    this.timeSlot,
    this.membershipType,
    required this.bookingFor,
    required this.amount,
    this.visitingFee,
    this.tax,
    required this.totalAmount,
    this.paymentMethod,
    this.paymentId,
    this.paymentStatus,
    required this.createdAt,
    this.instructions,
    this.qrCode,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      bookingNumber: json['booking_number'] ?? json['bookingNumber'],
      gymId: json['gym_id'] ?? json['gymId'] ?? '',
      gymName: json['gym_name'] ?? json['gymName'] ?? '',
      gymAddress: json['gym_address'] ?? json['gymAddress'] ?? '',
      gymImage: json['gym_image'] ?? json['gymImage'],
      type: BookingType.values.firstWhere(
            (e) => e.name == (json['type'] ?? 'service'),
        orElse: () => BookingType.service,
      ),
      status: BookingStatus.values.firstWhere(
            (e) => e.name == (json['status'] ?? 'pending'),
        orElse: () => BookingStatus.pending,
      ),
      serviceId: json['service_id'] ?? json['serviceId'],
      serviceName: json['service_name'] ?? json['serviceName'],
      slots: json['slots'],
      bookingDate: json['booking_date'] != null
          ? DateTime.parse(json['booking_date'])
          : DateTime.now(),
      timeSlot: json['time_slot'] ?? json['timeSlot'],
      membershipType: json['membership_type'] ?? json['membershipType'],
      bookingFor: json['booking_for'] ?? json['bookingFor'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      visitingFee: json['visiting_fee'] != null
          ? (json['visiting_fee']).toDouble()
          : null,
      tax: json['tax'] != null ? (json['tax']).toDouble() : null,
      totalAmount: (json['total_amount'] ?? json['totalAmount'] ?? 0).toDouble(),
      paymentMethod: json['payment_method'] ?? json['paymentMethod'],
      paymentId: json['payment_id'] ?? json['paymentId'],
      paymentStatus: json['payment_status'] ?? json['paymentStatus'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      instructions: json['instructions'],
      qrCode: json['qr_code'] ?? json['qrCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_number': bookingNumber,
      'gym_id': gymId,
      'gym_name': gymName,
      'gym_address': gymAddress,
      'gym_image': gymImage,
      'type': type.name,
      'status': status.name,
      'service_id': serviceId,
      'service_name': serviceName,
      'slots': slots,
      'booking_date': bookingDate.toIso8601String(),
      'time_slot': timeSlot,
      'membership_type': membershipType,
      'booking_for': bookingFor,
      'amount': amount,
      'visiting_fee': visitingFee,
      'tax': tax,
      'total_amount': totalAmount,
      'payment_method': paymentMethod,
      'payment_id': paymentId,
      'payment_status': paymentStatus,
      'created_at': createdAt.toIso8601String(),
      'instructions': instructions,
      'qr_code': qrCode,
    };
  }
}

class TimeSlotModel {
  final String id;
  final String label;
  final String startTime;
  final String endTime;
  final bool isAvailable;
  final String period;
  final int? availableCount;
  final int? maxCapacity;

  TimeSlotModel({
    required this.id,
    required this.label,
    required this.startTime,
    required this.endTime,
    this.isAvailable = true,
    required this.period,
    this.availableCount,
    this.maxCapacity,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      id: json['id'] ?? '',
      label: json['label'] ?? '',
      startTime: json['start_time'] ?? json['startTime'] ?? '',
      endTime: json['end_time'] ?? json['endTime'] ?? '',
      isAvailable: json['is_available'] ?? json['isAvailable'] ?? true,
      period: json['period'] ?? 'morning',
      availableCount: json['available_count'] ?? json['availableCount'],
      maxCapacity: json['max_capacity'] ?? json['maxCapacity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'start_time': startTime,
      'end_time': endTime,
      'is_available': isAvailable,
      'period': period,
      'available_count': availableCount,
      'max_capacity': maxCapacity,
    };
  }
}

class SubscriptionModel {
  final String id;
  final String type; // single_gym, multi_gym
  final String duration; // daily, weekly, monthly, quarterly, half_yearly, yearly
  final String durationLabel;
  final int price;
  final int? originalPrice;
  final String? gymId;
  final String? gymName;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isActive;

  SubscriptionModel({
    required this.id,
    required this.type,
    required this.duration,
    required this.durationLabel,
    required this.price,
    this.originalPrice,
    this.gymId,
    this.gymName,
    this.startDate,
    this.endDate,
    this.isActive = false,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] ?? '',
      type: json['type'] ?? 'single_gym',
      duration: json['duration'] ?? '',
      durationLabel: json['duration_label'] ?? json['durationLabel'] ?? '',
      price: json['price'] ?? 0,
      originalPrice: json['original_price'] ?? json['originalPrice'],
      gymId: json['gym_id'] ?? json['gymId'],
      gymName: json['gym_name'] ?? json['gymName'],
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : null,
      isActive: json['is_active'] ?? json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'duration': duration,
      'duration_label': durationLabel,
      'price': price,
      'original_price': originalPrice,
      'gym_id': gymId,
      'gym_name': gymName,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_active': isActive,
    };
  }
}