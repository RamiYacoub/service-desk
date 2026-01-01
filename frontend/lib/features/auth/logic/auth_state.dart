import 'package:equatable/equatable.dart';

enum AuthStatus { initial, loading, success, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? token;
  final List<String> roles;
  final String? error;

  const AuthState({
    required this.status,
    this.token,
    this.roles = const [],
    this.error,
  });

  const AuthState.initial()
    : status = AuthStatus.initial,
      token = null,
      roles = const [],
      error = null;

  AuthState copyWith({
    AuthStatus? status,
    String? token,
    List<String>? roles,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      token: token ?? this.token,
      roles: roles ?? this.roles,
      error: error,
    );
  }

  bool hasRole(String r) => roles.contains(r);

  @override
  List<Object?> get props => [status, token, roles, error];
}
