class VendorUserModel {
  String venddorid;
  String storageImage;
  String bName;
  String email;
  String number;
  String country;
  String state;
  String city;
  String taxStatus;
  String taxNumber;
  bool approved;

  VendorUserModel({
    required this.venddorid,
    required this.storageImage,
    required this.bName,
    required this.email,
    required this.number,
    required this.country,
    required this.state,
    required this.city,
    required this.taxStatus,
    required this.taxNumber,
    required this.approved,
  });

  factory VendorUserModel.fromJson(Map<String, dynamic> json) {
    return VendorUserModel(
      venddorid: json['venddorid'] as String,
      storageImage: json['storageImage'] as String,
      bName: json['bName'] as String,
      email: json['email'] as String,
      number: json['number'] as String,
      country: json['country'] as String,
      state: json['state'] as String,
      city: json['city'] as String,
      taxStatus: json['taxStatus'] as String,
      taxNumber: json['taxNumber'] as String,
      approved: json['approved'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'venddorid':venddorid,
      'storageImage': storageImage,
      'bName': bName,
      'email': email,
      'number': number,
      'country': country,
      'state': state,
      'city': city,
      'taxStatus': taxStatus,
      'taxNumber': taxNumber,
      'approved': approved
    };
  }
}
