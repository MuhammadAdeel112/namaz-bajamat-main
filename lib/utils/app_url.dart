class AppUrl {
  static const _baseUrl = 'http://18.138.130.255:4000';
  static const imamSignupEP = '$_baseUrl/api/imam/signup';
  static const visitorSignupEP = '$_baseUrl/api/visitor/signup';
  static const imamLoginEP = '$_baseUrl/api/imam/signin';
  static const visitorLoginEP = '$_baseUrl/api/visitor/signin';
  static const resetEP = '$_baseUrl/reset-password';
  static const updateProfileEP = '$_baseUrl/api/visitor/update';
  static const getImamOwnMasjidEP = '$_baseUrl/api/imam/my-masjid';
  static const updateImamOwnMasjidEP = '$_baseUrl/api/imam/update-my-masjid';
  static const getUpdateRequestsEP = '$_baseUrl/api/imam/requests';


  static hijriDateEP (String date) =>
      'https://api.aladhan.com/v1/gToH?date=$date&country=Pakistan';

  static String getAllMosques(double lat, double lng, int? filterInKm) {
    if (filterInKm != null) {
      return '$_baseUrl/api/visitor/nearby?lat=$lat&lng=$lng=$filterInKm';
    }
    return '$_baseUrl/api/visitor/nearby?lat=$lat&lng=$lng';
  }

  static String updateMosqueNamazTimings(String mosqueId) =>
      "$_baseUrl/api/visitor/masjid/$mosqueId/request-prayer-timings";

  static String approveRequests(String requestId) =>
      "$_baseUrl/api/imam/update-request/$requestId/decision";
}
