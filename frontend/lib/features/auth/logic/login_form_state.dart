import 'package:equatable/equatable.dart';

class LoginFormState extends Equatable {
  final String email;
  final String password;

  const LoginFormState({required this.email, required this.password});

  const LoginFormState.initial() : email = '', password = '';

  bool get canSubmit => email.trim().isNotEmpty && password.isNotEmpty;

  String? get validationError {
    final e = email.trim();
    final p = password;

    if (e.isEmpty || p.isEmpty) return 'Email and password are required.';
    final ok = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(e);
    if (!ok) return 'Please enter a valid email.';
    if (p.length < 4) return 'Password is too short.';
    return null;
  }

  LoginFormState copyWith({String? email, String? password}) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [email, password];
}
