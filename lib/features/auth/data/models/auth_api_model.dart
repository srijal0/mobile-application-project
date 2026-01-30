import 'package:fashion_store_trendora/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? authId;
  final String fullName;
  final String email;
  final String username;
  final String? password;
  final String? confirmPassword;
  final String? phoneNumber;
  final String? address;
  final String? profilePicture;

  AuthApiModel({
    this.authId,
    required this.fullName,
    required this.email,
    required this.username,
    this.password,
    this.confirmPassword,
    this.phoneNumber,
    this.address,
    this.profilePicture,
  });

  // info: To JSON
  Map<String, dynamic> toJson() {
    return {
      "name": fullName,
      "email": email,
      "username": username,
      "password": password,
      // Use password as confirmPassword if confirmPassword is null
      "confirmPassword": confirmPassword ?? password,
      "phoneNumber": phoneNumber,
      "address": address,
      "profilePicture": profilePicture,
    };
  }

  // info: from JSON
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      authId: json["_id"] as String,
      fullName: json["name"] as String? ?? json["username"] as String,
      email: json["email"] as String,
      username: json["username"] as String,
      phoneNumber: json["phoneNumber"] as String?,
      address: json["address"] as String?,
      profilePicture: json["profilePicture"] as String?,
    );
  }

  // info: to entity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: authId,
      fullName: fullName,
      email: email,
      username: username,
      password: password,
      confirmPassword: confirmPassword,
      phoneNumber: phoneNumber,
      address: address,
      profilePicture: profilePicture,
    );
  }

  // info: from entity
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      authId: entity.authId,
      fullName: entity.fullName,
      email: entity.email,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
      username: entity.username,
      phoneNumber: entity.phoneNumber,
      address: entity.address,
      profilePicture: entity.profilePicture,
    );
  }

  // info: to entity list
  static List<AuthEntity> toEntityList(List<AuthApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}