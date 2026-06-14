import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/auth_error_store.dart';
import '../../dashboard/presentation/dashboard_screen.dart';
import 'login_screen.dart';
import 'reset_password_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<bool> canAccess() async {

    final supabase =
        Supabase.instance.client;

    final user =
        supabase.auth.currentUser;

    if (user == null) {
      return false;
    }

    try {

      final member =
          await supabase
              .from('members')
              .select(
                'membership_status, expiry_date',
              )
              .eq(
                'user_id',
                user.id,
              )
              .single();

      final status =
          member['membership_status'];

      if (status == 'Pending') {

        AuthErrorStore.message =
            'Your membership application is still pending approval.';

        await supabase.auth.signOut();

        return false;
      }

      if (status == 'Rejected') {

        AuthErrorStore.message =
            'Your membership application has been rejected.';

        await supabase.auth.signOut();

        return false;
      }

      if (status == 'Deactivated') {

        AuthErrorStore.message =
            'Your account has been deactivated.';

        await supabase.auth.signOut();

        return false;
      }

      if (status == 'Expired') {

        AuthErrorStore.message =
            'Your membership has expired.';

        await supabase.auth.signOut();

        return false;
      }

      final expiryDate =
          member['expiry_date'];

      if (expiryDate != null) {

        final expiry =
            DateTime.parse(
              expiryDate,
            );

        if (
            expiry.isBefore(
              DateTime.now(),
            )) {

          AuthErrorStore.message =
              'Your membership has expired. Please renew your membership.';

          await supabase.auth.signOut();

          return false;
        }
      }

      return true;

    } catch (_) {

      AuthErrorStore.message =
          'Unable to verify membership.';

      await supabase.auth.signOut();

      return false;
    }
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<AuthState>(
      stream:
          Supabase.instance.client.auth
              .onAuthStateChange,

      builder: (
        context,
        snapshot,
      ) {

        if (snapshot.hasData) {

          final event =
              snapshot.data!.event;

          if (
              event ==
              AuthChangeEvent
                  .passwordRecovery) {

            return const ResetPasswordScreen();
          }
        }

        final session =
            Supabase.instance.client.auth
                .currentSession;

        if (session == null) {
          return const LoginScreen();
        }

        return FutureBuilder<bool>(
          future: canAccess(),

          builder: (
            context,
            accessSnapshot,
          ) {

            if (
                accessSnapshot
                        .connectionState ==
                    ConnectionState
                        .waiting) {

              return const Scaffold(
                body: Center(
                  child:
                      CircularProgressIndicator(),
                ),
              );
            }

            if (
                accessSnapshot.data ==
                true) {

              return const DashboardScreen();
            }

            return const LoginScreen();
          },
        );
      },
    );
  }
}