import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? authId;
  final String fullName;
  final String email;
  final String username;
  final String? password;
  final String? profilePicture;
  final String? phoneNumber;
  final String? address;

  const AuthEntity({
    this.authId,
    required this.fullName,
    required this.email,
    required this.username,
    this.password,
    this.profilePicture,
    this.phoneNumber,
    this.address,
  });

  @override
  List<Object?> get props => [
        authId,
        fullName,
        email,
        username,
        password,
        profilePicture,
        phoneNumber,
        address,
      ];
}