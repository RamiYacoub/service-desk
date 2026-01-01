import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/auth/logic/auth_cubit.dart';
import '../features/auth/logic/auth_state.dart';
import '../features/auth/ui/login_page.dart';
import '../features/auth/ui/home_page.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == AuthStatus.success) {
          return const HomePage();
        }

        return const LoginPage();
      },
    );
  }
}
