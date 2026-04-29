class ImamModel {
  ImamModel({
      this.message, 
      this.token, 
      this.imam,});

  ImamModel.fromJson(dynamic json) {
    message = json['message'];
    token = json['token'];
    imam = json['imam'] != null ? Imam.fromJson(json['imam']) : null;
  }
  String? message;
  String? token;
  Imam? imam;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['token'] = token;
    if (imam != null) {
      map['imam'] = imam?.toJson();
    }
    return map;
  }

}

class Imam {
  Imam({
      this.id, 
      this.maslik, 
      this.imamPic, 
      this.name, 
      this.phoneNo, 
      this.email, 
      this.password, 
      this.address, 
      this.cnic, 
      this.designation, 
      this.masjid, 
      this.status, 
      this.role, 
      this.createdAt, 
      this.updatedAt, 
      this.v,});

  Imam.fromJson(dynamic json) {
    id = json['_id'];
    maslik = json['maslik'];
    imamPic = json['imamPic'];
    name = json['name'];
    phoneNo = json['phoneNo'];
    email = json['email'];
    password = json['password'];
    address = json['address'];
    cnic = json['cnic'];
    designation = json['designation'];
    masjid = json['masjid'] != null ? Masjid.fromJson(json['masjid']) : null;
    status = json['status'];
    role = json['role'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
  String? id;
  String? maslik;
  dynamic imamPic;
  String? name;
  String? phoneNo;
  String? email;
  String? password;
  String? address;
  String? cnic;
  String? designation;
  Masjid? masjid;
  String? status;
  String? role;
  String? createdAt;
  String? updatedAt;
  num? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['maslik'] = maslik;
    map['imamPic'] = imamPic;
    map['name'] = name;
    map['phoneNo'] = phoneNo;
    map['email'] = email;
    map['password'] = password;
    map['address'] = address;
    map['cnic'] = cnic;
    map['designation'] = designation;
    if (masjid != null) {
      map['masjid'] = masjid?.toJson();
    }
    map['status'] = status;
    map['role'] = role;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }

}

class Masjid {
  Masjid({
      this.masjidAddress, 
      this.id, 
      this.name, 
      this.maslik, 
      this.city, 
      this.province, 
      this.country, 
      this.contactInfo, 
      this.nearbyLandmark, 
      this.masjidPic, 
      this.jummahPrayer, 
      this.eidPrayer, 
      this.parkingFacility, 
      this.magribPrayerDelay, 
      this.womenFacility, 
      this.prayerArea, 
      this.wazuArea, 
      this.status, 
      this.role, 
      this.prayerTimings, 
      this.createdAt, 
      this.updatedAt, 
      this.v,});

  Masjid.fromJson(dynamic json) {
    masjidAddress = json['masjidAddress'] != null ? MasjidAddress.fromJson(json['masjidAddress']) : null;
    id = json['_id'];
    name = json['name'];
    maslik = json['maslik'];
    city = json['city'];
    province = json['province'];
    country = json['country'];
    contactInfo = json['contactInfo'];
    nearbyLandmark = json['nearbyLandmark'];
    masjidPic = json['masjidPic'];
    jummahPrayer = json['jummahPrayer'];
    eidPrayer = json['eidPrayer'];
    parkingFacility = json['parkingFacility'];
    magribPrayerDelay = json['magribPrayerDelay'];
    womenFacility = json['womenFacility'];
    prayerArea = json['prayerArea'];
    wazuArea = json['wazuArea'];
    status = json['status'];
    role = json['role'];
    if (json['prayerTimings'] != null) {
      prayerTimings = [];
      json['prayerTimings'].forEach((v) {
        prayerTimings?.add(PrayerTimings.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
  MasjidAddress? masjidAddress;
  String? id;
  String? name;
  String? maslik;
  String? city;
  String? province;
  String? country;
  String? contactInfo;
  String? nearbyLandmark;
  dynamic masjidPic;
  String? jummahPrayer;
  String? eidPrayer;
  String? parkingFacility;
  String? magribPrayerDelay;
  String? womenFacility;
  String? prayerArea;
  String? wazuArea;
  String? status;
  String? role;
  List<PrayerTimings>? prayerTimings;
  String? createdAt;
  String? updatedAt;
  num? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (masjidAddress != null) {
      map['masjidAddress'] = masjidAddress?.toJson();
    }
    map['_id'] = id;
    map['name'] = name;
    map['maslik'] = maslik;
    map['city'] = city;
    map['province'] = province;
    map['country'] = country;
    map['contactInfo'] = contactInfo;
    map['nearbyLandmark'] = nearbyLandmark;
    map['masjidPic'] = masjidPic;
    map['jummahPrayer'] = jummahPrayer;
    map['eidPrayer'] = eidPrayer;
    map['parkingFacility'] = parkingFacility;
    map['magribPrayerDelay'] = magribPrayerDelay;
    map['womenFacility'] = womenFacility;
    map['prayerArea'] = prayerArea;
    map['wazuArea'] = wazuArea;
    map['status'] = status;
    map['role'] = role;
    if (prayerTimings != null) {
      map['prayerTimings'] = prayerTimings?.map((v) => v.toJson()).toList();
    }
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }

}

class PrayerTimings {
  PrayerTimings({
      this.id, 
      this.name, 
      this.time, 
      this.isOffered,});

  PrayerTimings.fromJson(dynamic json) {
    id = json['_id'];
    name = json['name'];
    time = json['time'];
    isOffered = json['isOffered'];
  }
  String? id;
  String? name;
  String? time;
  bool? isOffered;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['name'] = name;
    map['time'] = time;
    map['isOffered'] = isOffered;
    return map;
  }

}

class MasjidAddress {
  MasjidAddress({
      this.coordinates, 
      this.address,});

  MasjidAddress.fromJson(dynamic json) {
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