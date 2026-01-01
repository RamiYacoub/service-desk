import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/api/api_client.dart';
import 'core/storage/token_storage.dart';
import 'features/auth/data/auth_api.dart';
import 'features/auth/logic/auth_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dio = ApiClient.build();
  final authApi = AuthApi(dio);
  final storage = TokenStorage();
  final authCubit = AuthCubit(authApi, storage);

  await authCubit.bootstrap();

  runApp(App(authCubit: authCubit));
}
