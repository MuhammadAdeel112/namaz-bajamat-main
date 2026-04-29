class GetImamMasjidOnlyModel {
  GetImamMasjidOnlyModel({
      this.success, 
      this.masjid,});

  GetImamMasjidOnlyModel.fromJson(dynamic json) {
    success = json['success'];
    masjid = json['masjid'] != null ? Masjid.fromJson(json['masjid']) : null;
  }
  bool? success;
  Masjid? masjid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    if (masjid != null) {
      map['masjid'] = masjid?.toJson();
    }
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
  String? masjidPic;
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
      this.name, 
      this.time, 
      this.isOffered, 
      this.id,});

  PrayerTimings.fromJson(dynamic json) {
    name = json['name'];
    time = json['time'];
    isOffered = json['isOffered'];
    id = json['_id'];
  }
  String? name;
  String? time;
  bool? isOffered;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['time'] = time;
    map['isOffered'] = isOffered;
    map['_id'] = id;
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