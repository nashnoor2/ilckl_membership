import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../shared/models/member_model.dart';

class MemberService {
  final SupabaseClient supabase =
      Supabase.instance.client;

  Future<MemberModel?> getCurrentMember() async {
    final user =
        supabase.auth.currentUser;

    if (user == null) {
      return null;
    }

    final data =
        await supabase
            .from('members')
            .select('''
              *,
              membership_types (
                name
              )
            ''')
            .eq('user_id', user.id)
            .single();

    return MemberModel.fromJson(data);
  }

  Future<void> updateProfile({
    required String phoneNumber,
    required String address,
    required String okuCategory,
  }) async {
    final user =
        supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'User not authenticated',
      );
    }

    await supabase
        .from('members')
        .update({
          'phone_number':
              phoneNumber.trim(),

          'address':
              address
                  .trim()
                  .toUpperCase(),

          'oku_category':
              okuCategory
                  .trim()
                  .toUpperCase(),

          'updated_at':
              DateTime.now()
                  .toIso8601String(),
        })
        .eq('user_id', user.id);
  }

  Future<void> updateProfilePhoto(
    String photoUrl,
  ) async {
    final user =
        supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'User not authenticated',
      );
    }

    await supabase
        .from('members')
        .update({
          'profile_photo': photoUrl,
          'updated_at':
              DateTime.now()
                  .toIso8601String(),
        })
        .eq('user_id', user.id);
  }

  Future<String?> uploadProfilePhoto() async {
    final user =
        supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'User not authenticated',
      );
    }

    final picker = ImagePicker();

    final XFile? image =
        await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) {
      return null;
    }

    final Uint8List bytes =
        await image.readAsBytes();

    final fileName =
        '${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    await supabase.storage
        .from('member-photos')
        .uploadBinary(
          fileName,
          bytes,
        );

    final photoUrl =
        supabase.storage
            .from('member-photos')
            .getPublicUrl(
              fileName,
            );

    await updateProfilePhoto(
      photoUrl,
    );

    return photoUrl;
  }

  Future<MemberModel?> refreshMember() async {
    return getCurrentMember();
  }

  Future<bool> memberExists() async {
    final user =
        supabase.auth.currentUser;

    if (user == null) {
      return false;
    }

    final result =
        await supabase
            .from('members')
            .select('id')
            .eq('user_id', user.id)
            .maybeSingle();

    return result != null;
  }
}