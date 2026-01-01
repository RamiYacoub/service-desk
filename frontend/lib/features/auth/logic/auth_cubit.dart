import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../core/storage/token_storage.dart';
import '../data/auth_api.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthApi api;
  final TokenStorage storage;

  AuthCubit(this.api, this.storage) : super(const AuthState.initial());

  Future<void> bootstrap() async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));

    final token = await storage.read();
    if (token == null || token.isEmpty) {
      emit(const AuthState.initial());
      return;
    }

    if (JwtDecoder.isExpired(token)) {
      await storage.clear();
      emit(const AuthState.initial());
      return;
    }

    final roles = _extractRoles(token);
    emit(
      state.copyWith(
        status: AuthStatus.success,
        token: token,
        roles: roles,
        error: null,
      ),
    );
  }

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));
    try {
      final token = await api.login(email, password);
      await storage.save(token);

      final roles = _extractRoles(token);

      emit(
        state.copyWith(
          status: AuthStatus.success,
          token: token,
          roles: roles,
          error: null,
        ),
      );
    } catch (e) {
      String msg = 'Login failed. Please try again.';

      if (e is DioException) {
        final code = e.response?.statusCode;

        if (code == 401) {
          msg = 'Invalid email or password.';
        } else if (code == 400) {
          msg = 'Invalid login data.';
        } else if (code == null) {
          msg = 'Unable to connect to the server.';
        } else {
          msg = 'Request failed (HTTP $code).';
        }
      }

      emit(state.copyWith(status: AuthStatus.failure, error: msg));
    }
  }

  Future<void> logout() async {
    await storage.clear();
    emit(const AuthState.initial());
  }

  List<String> _extractRoles(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) return const ['EMPLOYEE'];

      final payloadJson = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final data = json.decode(payloadJson);

      final raw = data['roles'];

      if (raw is List) {
        final list = raw.map((e) => e.toString()).toList();
        return list.isEmpty ? const ['EMPLOYEE'] : list;
      }

      final single = data['role'];
      if (single != null) return [single.toString()];

      return const ['EMPLOYEE'];
    } catch (_) {
      return const ['EMPLOYEE'];
    }
  }
}
