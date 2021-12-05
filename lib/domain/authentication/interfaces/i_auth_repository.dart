import 'package:dartz/dartz.dart';
import 'package:krishop/domain/authentication/entities/user.dart';
import 'package:krishop/domain/authentication/failures/auth_failure.dart';

abstract class IAuthRepository {
  Future<Option<User>> getSignedInUser();

  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    required String emailAddress,
    required String password,
  });

  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    required String emailAddress,
    required String password,
  });

  Future<Either<AuthFailure, Unit>> signInWithGoogle();

  Future<void> signOut();
}
