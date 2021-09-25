import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:master_thesis/core/error/failures.dart';
import 'package:master_thesis/service_locator.dart';

// It probably works fine only on Android,
// on iOS it uses Keychain, so uninstalling app doesn't remove session.
class UserSessionRepository {
  final FlutterSecureStorage _flutterSecureStorage = sl<FlutterSecureStorage>();

  Either<DefaultFailure, bool> writeSession({required String userId}) {
    try {
      _flutterSecureStorage.write(key: 'curretnUserId', value: userId);
      return const Right(true);
    } catch (_) {
      return const Left(DefaultFailure(
          message: "Can't write user session to local storage."));
    }
  }

  Future<Either<DefaultFailure, String>> readSession() async {
    try {
      final String? userSession =
          await _flutterSecureStorage.read(key: 'curretnUserId');
      if (userSession != null) {
        return Right(userSession);
      } else {
        return const Left(DefaultFailure(
            message: "Can't read user session from local storage."));
      }
    } catch (_) {
      return const Left(DefaultFailure(
          message: "Can't read user session from local storage."));
    }
  }

  Future<Either<DefaultFailure, bool>> deleteSession() async {
    try {
      await _flutterSecureStorage.delete(key: 'curretnUserId');
      return const Right(true);
    } catch (_) {
      return const Left(DefaultFailure(
          message: "Can't delete user session from local storage."));
    }
  }
}
