import 'package:flutter/material.dart';

import '../../../core/services/auth_error_store.dart';
import '../../../core/services/auth_service.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool loading = false;

  bool obscurePassword = true;

  String? errorMessage;

  @override
  void initState() {

    super.initState();

    if (AuthErrorStore.message !=
        null) {

      errorMessage =
          AuthErrorStore.message;

      AuthErrorStore.message =
          null;
    }
  }

  Future<void> login() async {

    setState(() {
      loading = true;
      errorMessage = null;
    });

    final result =
        await AuthService().signIn(
      email:
          emailController.text.trim(),
      password:
          passwordController.text,
    );

    if (!mounted) {
      return;
    }

    if (!result.success) {

      setState(() {
        errorMessage =
            result.message;
        loading = false;
      });

      return;
    }

    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {

    emailController.dispose();

    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.all(
              24,
            ),
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth: 450,
              ),
              child: Column(
                children: [

                  const Icon(
                    Icons.badge,
                    size: 90,
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  const Text(
                    'ILCKL Membership',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  const Text(
                    'Member Login',
                  ),

                  const SizedBox(
                    height: 40,
                  ),

                  TextField(
                    controller:
                        emailController,
                    keyboardType:
                        TextInputType
                            .emailAddress,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Email',
                      border:
                          OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  TextField(
                    controller:
                        passwordController,
                    obscureText:
                        obscurePassword,
                    decoration:
                        InputDecoration(
                      labelText:
                          'Password',
                      border:
                          const OutlineInputBorder(),
                      suffixIcon:
                          IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword =
                                !obscurePassword;
                          });
                        },
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  if (errorMessage != null)

                    Container(
                      width:
                          double.infinity,
                      padding:
                          const EdgeInsets.all(
                        12,
                      ),
                      margin:
                          const EdgeInsets.only(
                        bottom: 16,
                      ),
                      decoration:
                          BoxDecoration(
                        color:
                            Colors.red.shade50,
                        border:
                            Border.all(
                          color:
                              Colors.red,
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          8,
                        ),
                      ),
                      child: Text(
                        errorMessage!,
                        textAlign:
                            TextAlign.center,
                        style:
                            const TextStyle(
                          color:
                              Colors.red,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),

                  SizedBox(
                    width:
                        double.infinity,
                    height: 50,
                    child:
                        ElevatedButton(
                      onPressed:
                          loading
                              ? null
                              : login,
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
                                  'Login',
                                ),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [

                      const Text(
                        'No account yet?',
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Register',
                        ),
                      ),
                    ],
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