// lib/core/error/failures.dart

abstract class Failure {
  final String? message;
  const Failure({this.message});
}

class LocalDataBaseFailure extends Failure {
  const LocalDataBaseFailure({String? message}) : super(message: message);
}

class NetworkFailure extends Failure {
  const NetworkFailure({String? message}) : super(message: message);
}
