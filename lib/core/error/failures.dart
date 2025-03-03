abstract class Failure {}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {
  final String message;

  CacheFailure({required this.message});
}
