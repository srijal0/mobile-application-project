class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = "http://10.0.2.2:5000";
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ================= AUTH ENDPOINTS =================
  static const String userLogin = "/api/v1/auth/login";
  static const String userRegister = "/api/v1/auth/register";

  // ================= OTHER ENDPOINTS =================
  static const String genre = "/api/v1/genre";
  static String genreById(String id) => "/api/v1/genre/$id";
  
  // ✅ FIX: Add /api/v1 prefix to match your backend pattern
  static const String uploadProfileImage = "/api/v1/upload/profile-image";
  static String getProfileImage(String userId) => "/api/v1/upload/profile-image/$userId";
}

// class ApiEndpoints {
//   ApiEndpoints._();

//   // Info: Base URL - CORRECTED FOR YOUR BACKEND
//   static const String baseUrl = "http://10.0.2.2:5000/api"; // Changed: port 5001->8000, removed /v1
//   // For physical device (uncomment and use your computer's IP):
//   // static const String baseUrl = "http://192.168.100.8:8000/api";

//   static const Duration connectionTimeout = Duration(seconds: 30);
//   static const Duration receiveTimeout = Duration(seconds: 30);

//   // Hack: ========== Batch Endpoints ===========
//   static const String genre = "/genre";
//   static String genreById(String id) => '/genre/$id';

//   // Hack: ========== User Endpoints ===========
//   static const String userLogin = "/auth/login";
//   static const String userRegister = "/auth/register";
//   static const String uploadProfileImage = "/upload/profile-image";
//   static String getProfileImage(String userId) => "/upload/profile-image/$userId";
  
//   // static const String users = "/users";
//   // static String userById(String id) => '/users/$id';
//   // static String userPhoto(String id) => "/users/$id/photo";
