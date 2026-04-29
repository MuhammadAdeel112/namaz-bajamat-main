class VisitorModel {
  VisitorModel({
      this.message, 
      this.token, 
      this.visitor,});

  VisitorModel.fromJson(dynamic json) {
    message = json['message'];
    token = json['token'];
    visitor = json['visitor'] != null ? Visitor.fromJson(json['visitor']) : null;
  }
  String? message;
  String? token;
  Visitor? visitor;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['token'] = token;
    if (visitor != null) {
      map['visitor'] = visitor?.toJson();
    }
    return map;
  }

}

class Visitor {
  Visitor({
      this.location, 
      this.id, 
      this.name, 
      this.email, 
      this.phone, 
      this.password, 
      this.role, 
      this.subscriptionStatus, 
      this.createdAt, 
      this.updatedAt, 
      this.v,});

  Visitor.fromJson(dynamic json) {
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    role = json['role'];
    subscriptionStatus = json['subscriptionStatus'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
  Location? location;
  String? id;
  String? name;
  String? email;
  String? phone;
  String? password;
  String? role;
  String? subscriptionStatus;
  String? createdAt;
  String? updatedAt;
  num? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (location != null) {
      map['location'] = location?.toJson();
    }
    map['_id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['phone'] = phone;
    map['password'] = password;
    map['role'] = role;
    map['subscriptionStatus'] = subscriptionStatus;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }

}

class Location {
  Location({
      this.coordinates, 
      this.address,});

  Location.fromJson(dynamic json) {
    coordinates = json['coordinates'] != null ? Coordinates.fromJson(json['coordinates']) : null;
    address = json['address'];
  }
  Coordinates? coordinates;
  String? address;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (coordinates != null) {
      map['coordinates'] = coordinates?.toJson();
    }
    map['address'] = address;
    return map;
  }

}

class Coordinates {
  Coordinates({
      this.lat, 
      this.lng,});

  Coordinates.fromJson(dynamic json) {
    lat = json['lat'];
    lng = json['lng'];
  }
  num? lat;
  num? lng;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = lat;
    map['lng'] = lng;
    return map;
  }

}