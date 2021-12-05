import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:krishop/domain/authentication/entities/user.dart';
import 'package:krishop/domain/authentication/failures/auth_failure.dart';
import 'package:krishop/domain/authentication/interfaces/i_auth_repository.dart';
import 'package:krishop/infrastructure/authentication/firebase_user_to_domain_mapper.dart';

@LazySingleton(as: IAuthRepository)
class FirebaseAuthRepository implements IAuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthRepository(this._firebaseAuth, this._googleSignIn);

  @override
  Future<Option<User>> getSignedInUser() async => optionOf(
        _firebaseAuth.currentUser?.toDomain(),
      );

  @override
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    required String userName,
    required String emailAddress,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      if (_firebaseAuth.currentUser != null) {
        await _firebaseAuth.currentUser!.updateDisplayName(userName);
      }

      return right(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return left(const AuthFailure.emailAlreadyInUse());
      } else {
        return left(const AuthFailure.serverError());
      }
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    required String emailAddress,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      return right(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'user-not-found') {
        return left(const AuthFailure.invalidEmailAndPasswordCombination());
      } else {
        return left(const AuthFailure.serverError());
      }
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return left(const AuthFailure.cancelledByUser());
      }

      final googleAuthentication = await googleUser.authentication;

      final authCredential = GoogleAuthProvider.credential(
        idToken: googleAuthentication.idToken,
        accessToken: googleAuthentication.accessToken,
      );

      await _firebaseAuth.signInWithCredential(authCredential);

      return right(unit);
    } on FirebaseAuthException catch (_) {
      return left(const AuthFailure.serverError());
    }
  }

  @override
  Future<void> signOut() => Future.wait([
        _googleSignIn.signOut(),
        _firebaseAuth.signOut(),
      ]);
}
