import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_form_state.dart';

class LoginFormCubit extends Cubit<LoginFormState> {
  LoginFormCubit() : super(const LoginFormState.initial());

  void emailChanged(String v) => emit(state.copyWith(email: v));
  void passwordChanged(String v) => emit(state.copyWith(password: v));
}
