part of 'visitor_profile_bloc.dart';

abstract class VisitorProfileEvent {}

class UpdateProfile extends VisitorProfileEvent {
  final String name;
  final String phoneNo;
  final String email;
  final String password;
  final String address;
  final double latitude;
  final double longitude;

  UpdateProfile({
    required this.name,
    required this.phoneNo,
    required this.email,
    required this.password,
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}
