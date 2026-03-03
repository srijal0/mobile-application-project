class ApiEndpoints {
  ApiEndpoints._(); // Private constructor

  // ================= BASE URL =================
  // Emulator (Android Studio/AVD)
  static const String baseUrlEmulator = "http://10.0.2.2:5000";
  // Physical device (your LAN IP, same Wi-Fi)
  static const String baseUrlDevice = "http://192.168.1.7:5000";

  // ⚡ Use this depending on testing
  static String get baseUrl => baseUrlDevice; // Using device IP for physical device

  // ================= TIMEOUTS =================
  static const Duration connectionTimeout = Duration(seconds: 60);
  static const Duration receiveTimeout = Duration(seconds: 60);

  // ================= AUTH =================
  static const String userLogin = "/api/v1/auth/login";
  static const String userRegister = "/api/v1/auth/register";
  static const String userLogout = "/api/v1/auth/logout";
  static const String getCurrentUser = "/api/v1/auth/user";

  // ================= GENRE =================
  static const String genre = "/api/v1/genre";
  static String genreById(String id) => "/api/v1/genre/$id";

  // ================= PROFILE IMAGE =================
  static const String uploadProfileImage = "/api/v1/upload/profile-image";
  static String getProfileImage(String userId) => "/api/v1/upload/profile-image/$userId";

  // ================= HELPER =================
  static String fullUrl(String endpoint) => "$baseUrl$endpoint";
}