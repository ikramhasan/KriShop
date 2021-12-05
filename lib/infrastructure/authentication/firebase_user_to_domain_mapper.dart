import 'package:krishop/domain/authentication/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

extension FirebaseUserX on firebase.User {
  User toDomain() {
    return User(
      id: uid,
      emailAddress: email ?? '',
      name: displayName ?? '',
      imageUrl: photoURL,
    );
  }
}
