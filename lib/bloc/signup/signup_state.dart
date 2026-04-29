part of 'signup_bloc.dart';

class SignupState {
  // Imam details
  final File? profilePic;
  final String? name;
  final String? phone;
  final String? email;
  final String? password;
  final String? address;
  final String? cnic;
  final String? designation;

  // Masjid details
  final File? masjidPic;
  final String? masjidName;
  final String? maslik;
  final Map<String,Object>? masjidAddress;
  final String? masjidCity;
  final String? masjidProvince;
  final String? masjidCountry;
  final String? masjidContactInfo;
  final String? masjidNearbyLandmarks;
  final bool? jumma;
  final bool? eid;
  final bool? parking;
  final String? maghribDelay;
  final bool? womenPrayerArea;
  final bool? womenWuzuArea;

  // API submission state
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  SignupState({
    this.profilePic,
    this.name,
    this.phone,
    this.email,
    this.password,
    this.address,
    this.cnic,
    this.designation,
    this.masjidPic,
    this.masjidName,
    this.maslik,
    this.masjidAddress,
    this.masjidCity,
    this.masjidProvince,
    this.masjidCountry,
    this.masjidContactInfo,
    this.masjidNearbyLandmarks,
    this.jumma,
    this.eid,
    this.parking,
    this.maghribDelay,
    this.womenPrayerArea,
    this.womenWuzuArea,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  SignupState copyWith({
    File? profilePic,
    String? name,
    String? phone,
    String? email,
    String? password,
    String? address,
    String? cnic,
    String? designation,
    File? masjidPic,
    String? masjidName,
    String? maslik,
    Map<String,Object>? masjidAddress,
    String? masjidCity,
    String? masjidProvince,
    String? masjidCountry,
    String? masjidContactInfo,
    String? masjidNearbyLandmarks,
    bool? jumma,
    bool? eid,
    bool? parking,
    String? maghribDelay,
    bool? womenPrayerArea,
    bool? womenWuzuArea,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return SignupState(
      profilePic: profilePic ?? this.profilePic,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      address: address ?? this.address,
      cnic: cnic ?? this.cnic,
      designation: designation ?? this.designation,
      masjidPic: masjidPic ?? this.masjidPic,
      masjidName: masjidName ?? this.masjidName,
      maslik: maslik ?? this.maslik,
      masjidAddress: masjidAddress ?? this.masjidAddress,
      masjidCity: masjidCity ?? this.masjidCity,
      masjidProvince: masjidProvince ?? this.masjidProvince,
      masjidCountry: masjidCountry ?? this.masjidCountry,
      masjidContactInfo: masjidContactInfo ?? this.masjidContactInfo,
      masjidNearbyLandmarks: masjidNearbyLandmarks ?? this.masjidNearbyLandmarks,
      jumma: jumma ?? this.jumma,
      eid: eid ?? this.eid,
      parking: parking ?? this.parking,
      maghribDelay: maghribDelay ?? this.maghribDelay,
      womenPrayerArea: womenPrayerArea ?? this.womenPrayerArea,
      womenWuzuArea: womenWuzuArea ?? this.womenWuzuArea,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory SignupState.initial() => SignupState();
}




// class SignupState {
//   // Imam details
//   final File? profilePic;
//   final String? name;
//   final String? phone;
//   final String? email;
//   final String? address;
//   final String? cnic;
//   final String? designation;
//
//   // Masjid details
//   final File? masjidPic;
//   final String? masjidName;
//   final String? masjidAddress;
//   final String? masjidCity;
//   final String? masjidProvince;
//   final String? masjidCountry;
//   final String? masjidContactInfo;
//   final String? masjidNearbyLandmarks;
//   final bool? jumma;
//   final bool? eid;
//   final bool? parking;
//   final String? maghribDelay;
//   final bool? womenPrayer;
//   final bool? wuzu;
//
//   SignupState({
//     this.profilePic,
//     this.name,
//     this.phone,
//     this.email,
//     this.address,
//     this.cnic,
//     this.designation,
//     this.masjidPic,
//     this.masjidName,
//     this.masjidAddress,
//     this.masjidCity,
//     this.masjidProvince,
//     this.masjidCountry,
//     this.masjidContactInfo,
//     this.masjidNearbyLandmarks,
//     this.jumma,
//     this.eid,
//     this.parking,
//     this.maghribDelay,
//     this.womenPrayer,
//     this.wuzu,
//   });
//
//   SignupState copyWith({
//     File? profilePic,
//     String? name,
//     String? phone,
//     String? email,
//     String? address,
//     String? cnic,
//     String? designation,
//     File? masjidPic,
//     String? masjidName,
//     String? masjidAddress,
//     String? masjidCity,
//     String? masjidProvince,
//     String? masjidCountry,
//     String? masjidContactInfo,
//     String? masjidNearbyLandmarks,
//     bool? jumma,
//     bool? eid,
//     bool? parking,
//     String? maghribDelay,
//     bool? womenPrayer,
//     bool? wuzu,
//   }) {
//     return SignupState(
//       profilePic: profilePic ?? this.profilePic,
//       name: name ?? this.name,
//       phone: phone ?? this.phone,
//       email: email ?? this.email,
//       address: address ?? this.address,
//       cnic: cnic ?? this.cnic,
//       designation: designation ?? this.designation,
//       masjidPic: masjidPic ?? this.masjidPic,
//       masjidName: masjidName ?? this.masjidName,
//       masjidAddress: masjidAddress ?? this.masjidAddress,
//       masjidCity: masjidCity ?? this.masjidCity,
//       masjidProvince: masjidProvince ?? this.masjidProvince,
//       masjidCountry: masjidCountry ?? this.masjidCountry,
//       masjidContactInfo: masjidContactInfo ?? this.masjidContactInfo,
//       masjidNearbyLandmarks: masjidNearbyLandmarks ?? this.masjidNearbyLandmarks,
//       jumma: jumma ?? this.jumma,
//       eid: eid ?? this.eid,
//       parking: parking ?? this.parking,
//       maghribDelay: maghribDelay ?? this.maghribDelay,
//       womenPrayer: womenPrayer ?? this.womenPrayer,
//       wuzu: wuzu ?? this.wuzu,
//     );
//   }
//
//   factory SignupState.initial() => SignupState();
// }

