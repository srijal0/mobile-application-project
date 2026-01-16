// abstract class Failure {
//   final String? message;
//   const Failure({this.message});
// }

// class LocalDataBaseFailure extends Failure {
//   const LocalDataBaseFailure({String? message}) : super(message: message);
// }

// class NetworkFailure extends Failure {
//   const NetworkFailure({String? message}) : super(message: message);
// }
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

// Note: Local Database failure handling
class LocalDataBaseFailure extends Failure {
  const LocalDataBaseFailure({
    String message = "Local Database operation Failed",
  }) : super(message);
}

class ApiFailure extends Failure {
  final int? statusCode;

  const ApiFailure({required String message, this.statusCode}) : super(message);

  @override
  List<Object?> get props => [message, statusCode];
}