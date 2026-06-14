import 'package:flutter/material.dart';

import '../../../core/services/member_service.dart';
import '../../../shared/models/member_model.dart';

class ProfileScreen extends StatefulWidget {
  final MemberModel member;

  const ProfileScreen({
    super.key,
    required this.member,
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

  late TextEditingController phoneController;
  late TextEditingController addressController;

  bool loading = false;

  String? selectedOku;

  String? profilePhotoUrl;

final List<String> okuCategories = [
  'PHYSICAL',
  'VISION',
  'HEARING',
  'LEARNING',
  'MULTIPLE DISABILITIES',
  'MENTAL',
  'SPEECH',
];

  @override
  void initState() {
    super.initState();

    phoneController =
        TextEditingController(
      text:
          widget.member.phoneNumber ?? '',
    );

    addressController =
        TextEditingController(
      text:
          widget.member.address ?? '',
    );

    selectedOku =
        widget.member.okuCategory;

    profilePhotoUrl =
        widget.member.profilePhoto;
  }

  Future<void> saveProfile() async {
    try {
      setState(() {
        loading = true;
      });

      await MemberService()
          .updateProfile(
        phoneNumber:
            phoneController.text.trim(),
        address:
            addressController.text.trim(),
        okuCategory:
            selectedOku ?? '',
      );

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Profile updated successfully',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> uploadPhoto() async {
    try {
      final url =
          await MemberService()
              .uploadProfilePhoto();

      if (url == null) {
        return;
      }

      setState(() {
        profilePhotoUrl = url;
      });

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Photo uploaded successfully',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
        ),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 10),

            Center(
              child: Column(
                children: [

                  CircleAvatar(
                    radius: 55,

                    backgroundImage:
                        profilePhotoUrl !=
                                null
                            ? NetworkImage(
                                profilePhotoUrl!,
                              )
                            : null,

                    child:
                        profilePhotoUrl ==
                                null
                            ? const Icon(
                                Icons.person,
                                size: 50,
                              )
                            : null,
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  OutlinedButton.icon(
                    onPressed:
                        uploadPhoto,

                    icon: const Icon(
                      Icons.upload,
                    ),

                    label: const Text(
                      'Upload Photo',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            TextFormField(
              initialValue:
                  widget.member.fullName,
              enabled: false,
              decoration:
                  const InputDecoration(
                labelText:
                    'Full Name',
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              initialValue:
                  widget.member.email,
              enabled: false,
              decoration:
                  const InputDecoration(
                labelText:
                    'Email',
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              initialValue:
                  widget.member.membershipNo ??
                  'Pending Approval',
              enabled: false,
              decoration:
                  const InputDecoration(
                labelText:
                    'Membership Number',
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              initialValue:
                  widget.member
                      .membershipStatus,
              enabled: false,
              decoration:
                  const InputDecoration(
                labelText:
                    'Membership Status',
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller:
                  phoneController,
              decoration:
                  const InputDecoration(
                labelText:
                    'Phone Number',
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller:
                  addressController,
              maxLines: 3,
              decoration:
                  const InputDecoration(
                labelText:
                    'Address',
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedOku,
              decoration:
                  const InputDecoration(
                labelText:
                    'OKU Category',
              ),
              items:
                  okuCategories.map(
                (category) {
                  return DropdownMenuItem(
                    value: category,
                    child:
                        Text(category),
                  );
                },
              ).toList(),
              onChanged: (value) {
                setState(() {
                  selectedOku =
                      value;
                });
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    loading
                        ? null
                        : saveProfile,
                child:
                    loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child:
                                CircularProgressIndicator(
                              strokeWidth:
                                  2,
                            ),
                          )
                        : const Text(
                            'Save Profile',
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}