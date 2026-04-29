class ApproveRequestResponseModel {
  ApproveRequestResponseModel({
      this.success, 
      this.count, 
      this.requests,});

  ApproveRequestResponseModel.fromJson(dynamic json) {
    success = json['success'];
    count = json['count'];
    if (json['requests'] != null) {
      requests = [];
      json['requests'].forEach((v) {
        requests?.add(Requests.fromJson(v));
      });
    }
  }
  bool? success;
  num? count;
  List<Requests>? requests;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['count'] = count;
    if (requests != null) {
      map['requests'] = requests?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Requests {
  Requests({
      this.id, 
      this.masjidId, 
      this.requestedBy, 
      this.updatedFields, 
      this.status, 
      this.createdAt, 
      this.updatedAt, 
      this.v,});

  Requests.fromJson(dynamic json) {
    id = json['_id'];
    masjidId = json['masjidId'];
    requestedBy = json['requestedBy'] != null ? RequestedBy.fromJson(json['requestedBy']) : null;
    updatedFields = json['updatedFields'] != null ? UpdatedFields.fromJson(json['updatedFields']) : null;
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
  String? id;
  String? masjidId;
  RequestedBy? requestedBy;
  UpdatedFields? updatedFields;
  String? status;
  String? createdAt;
  String? updatedAt;
  num? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['masjidId'] = masjidId;
    if (requestedBy != null) {
      map['requestedBy'] = requestedBy?.toJson();
    }
    if (updatedFields != null) {
      map['updatedFields'] = updatedFields?.toJson();
    }
    map['status'] = status;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }

}

// approve_request_response_model.dart
// (only the UpdatedFields + PrayerTimingEntry parts shown)

class UpdatedFields {
  UpdatedFields({this.prayerTimings});

  UpdatedFields.fromJson(dynamic json) {
    final raw = (json is Map<String, dynamic>) ? json['prayerTimings'] : null;
    if (raw is List) {
      final list = <PrayerTimingEntry>[];
      for (final item in raw) {
        if (item is Map) {
          final entry = PrayerTimingEntry.tryParse(
            Map<String, dynamic>.from(item as Map),
          );
          if (entry != null) list.add(entry); // skip unknown items
        }
      }
      prayerTimings = list;
    }
  }

  List<PrayerTimingEntry>? prayerTimings;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (prayerTimings != null) {
      map['prayerTimings'] = prayerTimings!.map((e) => e.toJson()).toList();
    }
    return map;
  }
}

/// One item like {"fajr":"05:10 AM"} or {"jumma":"01:15 PM"} / {"jummah":"01:15 PM"}.
class PrayerTimingEntry {
  PrayerTimingEntry({
    required this.name,   // canonical lowercase: fajr/zuhr/asr/maghrib/isha/jummah
    required this.time,
    this.originalKey,     // preserves incoming key spelling (e.g., "jumma")
  });

  String name;
  String time;
  String? originalKey;

  /// Safe parse: returns null if the map doesn't contain a known key.
  static PrayerTimingEntry? tryParse(Map<String, dynamic> json) {
    const keys = ['fajr', 'zuhr', 'asr', 'maghrib', 'isha', 'jumma', 'jummah'];
    for (final k in keys) {
      if (json.containsKey(k)) {
        final val = json[k];
        final canonical = (k == 'jumma') ? 'jummah' : k; // normalize
        final time = (val ?? '').toString().trim();
        if (time.isEmpty) return null; // skip empty times
        return PrayerTimingEntry(
          name: canonical,
          time: time,
          originalKey: k,
        );
      }
    }
    return null; // unknown item -> skip
  }

  Map<String, dynamic> toJson() => {originalKey ?? name: time};

  String get displayName =>
      name.isEmpty ? '' : name[0].toUpperCase() + name.substring(1);
}

/// Convenience helpers
extension UpdatedFieldsHelpers on UpdatedFields {
  /// {"fajr":"05:10 AM", ..., "jummah":"01:15 PM"} — 'jummah' only if present.
  Map<String, String> asMap() {
    final map = <String, String>{};
    for (final e in (prayerTimings ?? const [])) {
      map[e.name] = e.time;
    }
    return map;
  }

  /// Fajr → Zuhr → Asr → Maghrib → Isha → (optional) Jummah
  List<PrayerTimingEntry> ordered() {
    const order = ['fajr', 'zuhr', 'asr', 'maghrib', 'isha', 'jummah'];
    final byName = {for (final e in (prayerTimings ?? const [])) e.name: e};
    return [for (final n in order) if (byName[n] != null) byName[n]!];
  }
}




class RequestedBy {
  RequestedBy({
      this.id, 
      this.name, 
      this.email,});

  RequestedBy.fromJson(dynamic json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
  }
  String? id;
  String? name;
  String? email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['name'] = name;
    map['email'] = email;
    return map;
  }

}