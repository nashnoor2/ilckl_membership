import 'package:flutter/material.dart';

import '../../../core/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  final fullNameController =
      TextEditingController();

  final icController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  final addressController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final confirmPasswordController =
      TextEditingController();

  bool loading = false;

  String? selectedOkuCategory;

  final List<String> okuCategories = [
    'Physical',
    'Vision',
    'Hearing',
    'Learning',
    'Multiple Disabilities',
    'Mental',
    'Speech',
  ];

  Future<void> register() async {

    if (fullNameController.text.trim().isEmpty) {
      showMessage('Please enter Full Name');
      return;
    }

    if (icController.text.trim().isEmpty) {
      showMessage('Please enter IC Number');
      return;
    }

    if (emailController.text.trim().isEmpty) {
      showMessage('Please enter Email');
      return;
    }

    if (phoneController.text.trim().isEmpty) {
      showMessage('Please enter Phone Number');
      return;
    }

    if (addressController.text.trim().isEmpty) {
      showMessage('Please enter Address');
      return;
    }

    if (selectedOkuCategory == null) {
      showMessage('Please select OKU Category');
      return;
    }

    if (passwordController.text.length < 8) {
      showMessage(
        'Password must be at least 8 characters',
      );
      return;
    }

    if (passwordController.text !=
        confirmPasswordController.text) {
      showMessage('Passwords do not match');
      return;
    }

    try {

      setState(() {
        loading = true;
      });

      await AuthService().registerMember(
        fullName:
            fullNameController.text.trim(),

        icNumber:
            icController.text.trim(),

        phoneNumber:
            phoneController.text.trim(),

        email:
            emailController.text.trim(),

        password:
            passwordController.text,

        address:
            addressController.text.trim(),

        okuCategory:
            selectedOkuCategory!,
      );

      if (mounted) {

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Registration submitted successfully',
            ),
          ),
        );

        Navigator.pop(context);
      }

    } catch (e) {

      showMessage(e.toString());

    } finally {

      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  void showMessage(String message) {

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register Membership',
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 600,

            child: Padding(
              padding:
                  const EdgeInsets.all(24),

              child: Column(
                children: [

                  TextField(
                    controller:
                        fullNameController,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Full Name',
                      border:
                          OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: icController,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'IC Number',
                      border:
                          OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller:
                        emailController,
                    decoration:
                        const InputDecoration(
                      labelText: 'Email',
                      border:
                          OutlineInputBorder(),
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
                      border:
                          OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller:
                        addressController,
                    maxLines: 3,
                    decoration:
                        const InputDecoration(
                      labelText: 'Address',
                      border:
                          OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    initialValue:
                        selectedOkuCategory,

                    decoration:
                        const InputDecoration(
                      labelText:
                          'OKU Category',
                      border:
                          OutlineInputBorder(),
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
                        selectedOkuCategory =
                            value;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller:
                        passwordController,
                    obscureText: true,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Password',
                      border:
                          OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller:
                        confirmPasswordController,
                    obscureText: true,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Confirm Password',
                      border:
                          OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(
                      onPressed:
                          loading
                              ? null
                              : register,

                      child: loading
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
                              'Register Membership',
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}