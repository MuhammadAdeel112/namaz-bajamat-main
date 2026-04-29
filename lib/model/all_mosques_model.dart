class AllMosquesModel {
  AllMosquesModel({
      this.success, 
      this.count, 
      this.masjids,});

  AllMosquesModel.fromJson(dynamic json) {
    success = json['success'];
    count = json['count'];
    if (json['masjids'] != null) {
      masjids = [];
      json['masjids'].forEach((v) {
        masjids?.add(Masjids.fromJson(v));
      });
    }
  }
  bool? success;
  num? count;
  List<Masjids>? masjids;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['count'] = count;
    if (masjids != null) {
      map['masjids'] = masjids?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Masjids {
  Masjids({
      this.masjidAddress, 
      this.jummahPrayer, 
      this.id, 
      this.name, 
      this.maslik, 
      this.city, 
      this.province, 
      this.country, 
      this.contactInfo, 
      this.nearbyLandmark, 
      this.masjidPic, 
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
      this.v, 
      this.distance,});

  Masjids.fromJson(dynamic json) {
    masjidAddress = json['masjidAddress'] != null ? MasjidAddress.fromJson(json['masjidAddress']) : null;
    jummahPrayer = json['jummahPrayer'];
    id = json['_id'];
    name = json['name'];
    maslik = json['maslik'];
    city = json['city'];
    province = json['province'];
    country = json['country'];
    contactInfo = json['contactInfo'];
    nearbyLandmark = json['nearbyLandmark'];
    masjidPic = json['masjidPic'];
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
    distance = json['distance'];
  }
  MasjidAddress? masjidAddress;
  String? jummahPrayer;
  String? id;
  String? name;
  String? maslik;
  String? city;
  String? province;
  String? country;
  String? contactInfo;
  String? nearbyLandmark;
  String? masjidPic;
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
  num? distance;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (masjidAddress != null) {
      map['masjidAddress'] = masjidAddress?.toJson();
    }
    map['jummahPrayer'] = jummahPrayer;
    map['_id'] = id;
    map['name'] = name;
    map['maslik'] = maslik;
    map['city'] = city;
    map['province'] = province;
    map['country'] = country;
    map['contactInfo'] = contactInfo;
    map['nearbyLandmark'] = nearbyLandmark;
    map['masjidPic'] = masjidPic;
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
    map['distance'] = distance;
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