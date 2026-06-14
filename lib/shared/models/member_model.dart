import 'dart:convert';

class MemberModel {
  final String? id;
  final String? userId;

  final String? membershipNo;

  final String fullName;
  final String? icNumber;
  final String email;

  final String? phoneNumber;
  final String? address;
  final String? okuCategory;

  final String? profilePhoto;

  final String? membershipType;

  final String membershipStatus;

  final DateTime? registrationDate;
  final DateTime? expiryDate;

  const MemberModel({
    required this.id,
    required this.userId,
    required this.membershipNo,
    required this.fullName,
    required this.icNumber,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.okuCategory,
    required this.profilePhoto,
    required this.membershipType,
    required this.membershipStatus,
    required this.registrationDate,
    required this.expiryDate,
  });

  factory MemberModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MemberModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,

      membershipNo:
          json['membership_no'] as String?,

      fullName:
          json['full_name'] ?? '',

      icNumber:
          json['ic_number'] as String?,

      email:
          json['email'] ?? '',

      phoneNumber:
          json['phone_number'] as String?,

      address:
          json['address'] as String?,

      okuCategory:
          json['oku_category'] as String?,

      profilePhoto:
          json['profile_photo'] as String?,

      membershipType:
          json['membership_types'] != null
              ? json['membership_types']['name']
                  as String?
              : null,

      membershipStatus:
          json['membership_status'] ??
              'Pending',

      registrationDate:
          json['registration_date'] != null
              ? DateTime.parse(
                  json['registration_date'],
                )
              : null,

      expiryDate:
          json['expiry_date'] != null
              ? DateTime.parse(
                  json['expiry_date'],
                )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'membership_no': membershipNo,
      'full_name': fullName,
      'ic_number': icNumber,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
      'oku_category': okuCategory,
      'profile_photo': profilePhoto,
      'membership_type': membershipType,
      'membership_status': membershipStatus,
      'registration_date':
          registrationDate?.toIso8601String(),
      'expiry_date':
          expiryDate?.toIso8601String(),
    };
  }

  MemberModel copyWith({
    String? id,
    String? userId,
    String? membershipNo,
    String? fullName,
    String? icNumber,
    String? email,
    String? phoneNumber,
    String? address,
    String? okuCategory,
    String? profilePhoto,
    String? membershipType,
    String? membershipStatus,
    DateTime? registrationDate,
    DateTime? expiryDate,
  }) {
    return MemberModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      membershipNo:
          membershipNo ?? this.membershipNo,
      fullName:
          fullName ?? this.fullName,
      icNumber:
          icNumber ?? this.icNumber,
      email: email ?? this.email,
      phoneNumber:
          phoneNumber ?? this.phoneNumber,
      address:
          address ?? this.address,
      okuCategory:
          okuCategory ?? this.okuCategory,
      profilePhoto:
          profilePhoto ?? this.profilePhoto,
      membershipType:
          membershipType ?? this.membershipType,
      membershipStatus:
          membershipStatus ??
              this.membershipStatus,
      registrationDate:
          registrationDate ??
              this.registrationDate,
      expiryDate:
          expiryDate ?? this.expiryDate,
    );
  }

  String get qrData {
    return jsonEncode({
      'membership_no': membershipNo,
      'full_name': fullName,
      'ic_number': icNumber,
      'oku_category': okuCategory,
      'status': membershipStatus,
      'expiry_date':
          expiryDate?.toIso8601String(),
    });
  }
}