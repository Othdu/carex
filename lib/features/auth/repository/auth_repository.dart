import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  Future<void> signInWithEmail(String email, String password);
  Future<void> signUpWithEmail(
    String name,
    String email,
    String password, {
    String role = 'patient',
    String? phone,
    String? dateOfBirth,
    String? gender,
    String? medicalConditions,
  });
  Future<void> signInWithGoogle();
  Future<void> signInWithFacebook();
  Future<void> signInWithApple();
  Future<void> signOut();
}

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<void> signInWithEmail(String email, String password) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> signUpWithEmail(
    String name,
    String email,
    String password, {
    String role = 'patient',
    String? phone,
    String? dateOfBirth,
    String? gender,
    String? medicalConditions,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: 'carex://confirm',
      data: {
        'full_name': name,
        'role': role,
        if (phone != null) 'phone': phone,
        if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
        if (gender != null) 'gender': gender,
        if (medicalConditions != null) 'medical_conditions': medicalConditions,
      },
    );
    // When email confirmation is enabled Supabase returns session == null.
    // Sign in immediately so a persisted session exists for future app launches.
    if (response.session == null) {
      await _client.auth.signInWithPassword(email: email, password: password);
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(OAuthProvider.google);
  }

  @override
  Future<void> signInWithFacebook() async {
    await _client.auth.signInWithOAuth(OAuthProvider.facebook);
  }

  @override
  Future<void> signInWithApple() async {
    await _client.auth.signInWithOAuth(OAuthProvider.apple);
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
