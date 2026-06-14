import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState
    extends State<ResetPasswordScreen> {

  final passwordController =
      TextEditingController();

  final confirmPasswordController =
      TextEditingController();

  bool loading = false;

  Future<void> updatePassword() async {

    if (passwordController.text.isEmpty) {

      showMessage(
        'Please enter a new password',
      );

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

      showMessage(
        'Passwords do not match',
      );

      return;
    }

    try {

      setState(() {
        loading = true;
      });

      await Supabase
          .instance
          .client
          .auth
          .updateUser(
        UserAttributes(
          password:
              passwordController.text,
        ),
      );

      if (mounted) {

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Password updated successfully',
            ),
          ),
        );

        await Supabase
            .instance
            .client
            .auth
            .signOut();

        if (mounted) {
          Navigator.pop(context);
        }
      }

    } catch (e) {

      showMessage(
        e.toString(),
      );

    } finally {

      if (mounted) {

        setState(() {
          loading = false;
        });
      }
    }
  }

  void showMessage(
    String message,
  ) {

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {

    passwordController.dispose();

    confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Reset Password',
        ),
      ),

      body: Center(

        child: SingleChildScrollView(

          child: SizedBox(

            width: 500,

            child: Padding(

              padding:
                  const EdgeInsets.all(24),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.stretch,

                children: [

                  const Text(
                    'Create a New Password',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  const Text(
                    'Please enter your new password.',
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  TextField(
                    controller:
                        passwordController,
                    obscureText: true,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'New Password',
                      border:
                          OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

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

                  const SizedBox(
                    height: 24,
                  ),

                  ElevatedButton(

                    onPressed:
                        loading
                            ? null
                            : updatePassword,

                    child:
                        loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Update Password',
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