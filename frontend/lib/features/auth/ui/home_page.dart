import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/logic/auth_cubit.dart';
import '../../auth/logic/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () => context.read<AuthCubit>().logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (_, state) => Text(
            '✅ Logged in\nRoles: ${state.roles.join(', ')}',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
