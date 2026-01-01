import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/auth/logic/auth_cubit.dart';
import 'root_page.dart';

class App extends StatelessWidget {
  final AuthCubit authCubit;
  const App({super.key, required this.authCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: authCubit,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: RootPage(),
      ),
    );
  }
}
