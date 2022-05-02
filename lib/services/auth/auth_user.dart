import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String? email;
  final bool isEmailVerified;
  const AuthUser({required this.isEmailVerified, required this.email});

  factory AuthUser.fromFireBase(User user) => AuthUser(
        isEmailVerified: user.emailVerified,
        email: user.email,
      );
}
