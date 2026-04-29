abstract class VisitorSignupEvent {}

class SignupSubmitted extends VisitorSignupEvent {
  final String name;
  final String phoneNo;
  final String email;
  final String password;
  final String address;
  final double lat;
  final double lng;

  SignupSubmitted({
    required this.name,
    required this.phoneNo,
    required this.email,
    required this.password,
    required this.address,
    required this.lat,
    required this.lng,
  });
}

