part of 'signup_bloc.dart';

sealed class SignupEvent {}

class ProfilePicChanged extends SignupEvent {
  final File image;
  ProfilePicChanged(this.image);
}

class ImamDetailsSubmitted extends SignupEvent {
  final String name;
  final String phone;
  final String email;
  final String password;
  final String address;
  final String cnic;
  final String designation;

  ImamDetailsSubmitted({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.address,
    required this.cnic,
    required this.designation,
  });
}

class MasjidPicChanged extends SignupEvent {
  final File image;
  MasjidPicChanged(this.image);
}

class MasjidDetailsSubmitted extends SignupEvent {
  final String masjidName;
  final String maslik;
  final Map<String,Object> masjidAddress;
  final String masjidCity;
  final String masjidProvince;
  final String masjidCountry;
  final String masjidContactInfo;
  final String masjidNearbyLandmarks;
  final bool jumma;
  final bool eid;
  final bool parking;
  final String maghribDelay;
  final bool womenPrayerArea;
  final bool womenWuzuArea;

  MasjidDetailsSubmitted({
    required this.masjidName,
    required this.maslik,
    required this.masjidAddress,
    required this.masjidCity,
    required this.masjidProvince,
    required this.masjidCountry,
    required this.masjidContactInfo,
    required this.masjidNearbyLandmarks,
    required this.jumma,
    required this.eid,
    required this.parking,
    required this.maghribDelay,
    required this.womenPrayerArea,
    required this.womenWuzuArea,
  });
}

class SignupSubmitted extends SignupEvent {}

