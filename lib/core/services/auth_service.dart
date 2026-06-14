import 'package:supabase_flutter/supabase_flutter.dart';

class LoginResult {
  final bool success;
  final String? message;

  const LoginResult({
    required this.success,
    this.message,
  });
}

class AuthService {
  final SupabaseClient supabase =
      Supabase.instance.client;

  User? get currentUser =>
      supabase.auth.currentUser;

  Session? get currentSession =>
      supabase.auth.currentSession;

  Future<LoginResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response =
          await supabase.auth
              .signInWithPassword(
        email:
            email.trim().toLowerCase(),
        password: password,
      );

      if (response.user == null) {
        return const LoginResult(
          success: false,
          message:
              'Invalid email or password.',
        );
      }

      return const LoginResult(
        success: true,
      );
    } catch (_) {
      return const LoginResult(
        success: false,
        message:
            'Invalid email or password.',
      );
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  Future<void> resetPassword(
    String email,
  ) async {
    await supabase.auth
        .resetPasswordForEmail(
      email.trim().toLowerCase(),
    );
  }

  Future<void> registerMember({
    required String fullName,
    required String icNumber,
    required String phoneNumber,
    required String email,
    required String password,
    required String address,
    required String okuCategory,
  }) async {
    final normalizedName =
        fullName.trim().toUpperCase();

    final normalizedAddress =
        address.trim().toUpperCase();

    final normalizedOku =
        okuCategory.trim().toUpperCase();

    final normalizedEmail =
        email.trim().toLowerCase();

    final existingMember =
        await supabase
            .from('members')
            .select('id')
            .eq(
              'ic_number',
              icNumber.trim(),
            )
            .maybeSingle();

    if (existingMember != null) {
      throw Exception(
        'IC Number already registered',
      );
    }

    final response =
        await supabase.auth.signUp(
      email: normalizedEmail,
      password: password,
    );

    final user = response.user;

    if (user == null) {
      throw Exception(
        'Unable to create user account',
      );
    }

    await supabase
        .from('profiles')
        .insert({
      'id': user.id,
      'full_name':
          normalizedName,
      'role': 'member',
    });

    await supabase
        .from('members')
        .insert({
      'user_id':
          user.id,
      'full_name':
          normalizedName,
      'ic_number':
          icNumber.trim(),
      'email':
          normalizedEmail,
      'phone_number':
          phoneNumber.trim(),
      'address':
          normalizedAddress,
      'oku_category':
          normalizedOku,
      'membership_type_id': 1,
      'membership_status':
          'Pending',
    });

    await supabase.auth.signOut();
  }
}