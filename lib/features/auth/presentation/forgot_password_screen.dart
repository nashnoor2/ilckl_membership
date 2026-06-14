import 'package:flutter/material.dart';

import '../../../core/services/auth_service.dart';

class ForgotPasswordScreen
    extends StatefulWidget {
  const ForgotPasswordScreen({
    super.key,
  });

  @override
  State<ForgotPasswordScreen>
      createState() =>
          _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<
        ForgotPasswordScreen> {

  final emailController =
      TextEditingController();

  bool loading = false;

  Future<void> submit() async {
    try {

      setState(() {
        loading = true;
      });

      await AuthService()
          .resetPassword(
        emailController.text.trim(),
      );

      if (mounted) {

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Password reset email sent',
            ),
          ),
        );

        Navigator.pop(context);
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

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(20),

        child: Column(
          children: [

            const SizedBox(
              height: 20,
            ),

            TextField(
              controller:
                  emailController,

              decoration:
                  const InputDecoration(
                labelText: 'Email',
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            SizedBox(
              width:
                  double.infinity,

              child:
                  ElevatedButton(
                onPressed:
                    loading
                        ? null
                        : submit,

                child:
                    loading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Send Reset Link',
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}