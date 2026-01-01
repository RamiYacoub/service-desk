import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:service_desk_app/app/app.dart';
import 'package:service_desk_app/core/api/api_client.dart';
import 'package:service_desk_app/core/storage/token_storage.dart';
import 'package:service_desk_app/features/auth/data/auth_api.dart';
import 'package:service_desk_app/features/auth/logic/auth_cubit.dart';

void main() {
  testWidgets('App builds', (WidgetTester tester) async {
    final dio = ApiClient.build();
    final authApi = AuthApi(dio);
    final storage = TokenStorage();
    final authCubit = AuthCubit(authApi, storage);

    await tester.pumpWidget(App(authCubit: authCubit));
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
