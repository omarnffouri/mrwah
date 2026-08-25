class ApiConstants {
  ApiConstants._();

  static const String host = 'mrwah.org/api/';
  // server base url
  static const String kServerURL = 'https://$host/';

  // Endpoints
  static const String getMostPopularArticles = 'mostviewed/all-sections/';
  static const String login = 'login';
  static const String logout = 'logout';
  static const String delete = 'users';
  static const String register = 'register';
  static const String addToken = 'add-device-token';
  static const String sendResetPasswordEmail = 'password/email';
  static const String verifyResetPasswordCode = 'password/verify-code';
  static const String resetPassword = 'password/reset';

  //
  static const String homeData = 'home';
  static const String bookings = 'bookings';
  static const String bookCar = 'booking';

  ///
  static const String getvehicles = 'vehicles';

  ///car-wash
  static const String carWashBooking = 'plan/booking';
  static const String carWashShops = 'partners/car_wash';

  // API key
  static const String apiKey = "WAXOeyxgMcSY2Q4s6dfdUEPG7Hu35I5u";
}
