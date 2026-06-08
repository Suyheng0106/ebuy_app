class AddressReq {
  int? userId;
  String? line1;
  String? line2;
  String? city;
  String? state;
  String? country;
  int? postalCode;
  num? longitude;
  num? latitude;

  AddressReq(
      {this.userId,
        this.line1,
        this.line2,
        this.city,
        this.state,
        this.country,
        this.postalCode,
        this.longitude,
        this.latitude});

  AddressReq.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    line1 = json['line1'];
    line2 = json['line2'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    postalCode = json['postal_code'];
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['line1'] = this.line1;
    data['line2'] = this.line2;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['postal_code'] = this.postalCode;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    return data;
  }
}
