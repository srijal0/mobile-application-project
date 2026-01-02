// lib/core/services/hive_service.dart
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fashion_store_trendora/core/constants/hive_table_constant.dart';
import 'package:fashion_store_trendora/features/auth/data/models/auth_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/${HiveTableConstant.dbName}";

    Hive.init(path);
    _registerAdapters();
    await _openBoxes();
  }

  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
    // Later: register adapters for cart, product, etc.
  }

  Future<void> _openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
    // Later: open cart/product boxes
  }

  Future<void> closeBoxes() async {
    await Hive.close();
  }

  // =================== Auth CRUD Operations ===========================

  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstant.authTable);

  /// Register a new user
  Future<AuthHiveModel> registerUser(AuthHiveModel model) async {
    await _authBox.put(model.authId, model);
    return model;
  }

  /// Login user by email + password
  Future<AuthHiveModel?> loginUser(String email, String password) async {
    final user = _authBox.values.where(
      (user) => user.email == email && user.password == password,
    );

    if (user.isNotEmpty) return user.first;
    return null;
  }

  /// Get current user by authId
  Future<AuthHiveModel?> getCurrentUser(String authId) async {
    return _authBox.get(authId);
  }

  /// Check if email already exists
  Future<bool> isEmailExists(String email) async {
    final users = _authBox.values.where((user) => user.email == email);
    return users.isNotEmpty;
  }

  /// Logout user (clear session, etc.)
  Future<void> logoutUser() async {
    // For now, just clear the box or session key
    await _authBox.clear();
  }
}
