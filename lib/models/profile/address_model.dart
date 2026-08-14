class AddressResponse {
  final String? success;
  final int? status;
  final String? message;
  final List<AddressData>? data;

  AddressResponse({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  factory AddressResponse.fromJson(Map<String, dynamic> json) {
    return AddressResponse(
      success: json['success'],
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => AddressData.fromJson(i)).toList()
          : null,
    );
  }
}

class AddressData {
  final int? id;
  final String? type;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final int? stateId;
  final int? countryId;
  final String? postalCode;
  final int? isDefault;
  final String? countryName;
  final String? stateName;

  AddressData({
    this.id,
    this.type,
    this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.stateId,
    this.countryId,
    this.postalCode,
    this.isDefault,
    this.countryName,
    this.stateName,
  });

  factory AddressData.fromJson(Map<String, dynamic> json) {
    int? parseIsDefault(dynamic value) {
      if (value == null) return 0;
      if (value is bool) return value ? 1 : 0;
      if (value is String) return int.tryParse(value) ?? 0;
      if (value is int) return value;
      return 0;
    }

    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is String) return int.tryParse(value);
      if (value is int) return value;
      return null;
    }

    return AddressData(
      id: json['id'],
      type: json['type'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      addressLine1: json['address_line_1'],
      addressLine2: json['address_line_2'],
      city: json['city'],
      stateId: parseInt(json['state_id']),
      countryId: parseInt(json['country_id']),
      postalCode: json['postal_code'],
      isDefault: parseIsDefault(json['is_default']),
      countryName: json['country'] != null ? json['country']['name'] : json['country_name'],
      stateName: json['state'] != null ? json['state']['name'] : json['state_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'address_line_1': addressLine1,
      'address_line_2': addressLine2,
      'city': city,
      'state_id': stateId,
      'country_id': countryId,
      'postal_code': postalCode,
      'is_default': isDefault,
    };
  }
}
