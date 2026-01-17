class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - No /api/v1 suffix since routes already include it
  static const String baseUrl = "http://10.0.2.2:5000"; // Android Emulator

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ================= AUTH ENDPOINTS =================
  static const String userLogin = "/api/v1/auth/login";
  static const String userRegister = "/api/v1/auth/register";

  // ================= OTHER ENDPOINTS =================
  static const String genre = "/api/v1/genre";
  static String genreById(String id) => "/api/v1/genre/$id";
}

// class ApiEndpoints {
//   ApiEndpoints._();

//   //Info: Base URL
//   static const String baseUrl =
//       "http://10.0.2.2:5000/api/v1"; // info: for android
//   // static const String baseUrl =
//   //     "http://192.168.100.8:4000"; // info: for physical device use computers IP

//   // Note: For physical device use computer IP: "http:/102.168.x.x:5000/api/v1"

//   static const Duration connectionTimeout = Duration(seconds: 30);
//   static const Duration receiveTimeout = Duration(seconds: 30);

//   // Hack: ========== Batch Endpoints ===========
//   static const String genre = "/genre";
//   static String genreById(String id) => '/genre/$id';

//   // Hack: ========== User Endpoints ===========
//   // static const String users = "/users";
//   static const String userLogin = "/api/auth/login";
//   static const String userRegister = "/api/auth/register";
//   // static String userById(String id) => '/users/$id';
//   // static String userPhoto(String id) => "/users/$id/photo";
// }