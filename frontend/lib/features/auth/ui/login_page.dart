import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/login_form_cubit.dart';
import '../logic/login_form_state.dart';

import '../logic/auth_cubit.dart';
import '../logic/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final pass = TextEditingController();

  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();

  @override
  void dispose() {
    _emailFocus.dispose();
    _passFocus.dispose();
    email.dispose();
    pass.dispose();
    _obscure.dispose();
    super.dispose();
  }

  final ValueNotifier<bool> _obscure = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginFormCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: const Text('Login')),
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, authState) {
                            final loading =
                                authState.status == AuthStatus.loading;

                            return BlocBuilder<LoginFormCubit, LoginFormState>(
                              builder: (context, formState) {
                                void submit() {
                                  final msg = formState.validationError;
                                  if (msg != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(msg)),
                                    );
                                    return;
                                  }
                                  context.read<AuthCubit>().login(
                                    formState.email.trim(),
                                    formState.password,
                                  );
                                }

                                return Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const Text(
                                          'Service Desk',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 6),
                                        const Text(
                                          'Sign in to continue',
                                          style: TextStyle(
                                            color: Colors.black54,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 16),

                                        TextField(
                                          controller: email,
                                          focusNode: _emailFocus,
                                          textInputAction: TextInputAction.next,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          autofillHints: const [
                                            AutofillHints.username,
                                            AutofillHints.email,
                                          ],
                                          onChanged: context
                                              .read<LoginFormCubit>()
                                              .emailChanged,
                                          onSubmitted: (_) =>
                                              _passFocus.requestFocus(),
                                          decoration: const InputDecoration(
                                            labelText: 'Email',
                                            hintText: 'name@company.com',
                                            prefixIcon: Icon(
                                              Icons.email_outlined,
                                            ),
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        const SizedBox(height: 12),

                                        ValueListenableBuilder<bool>(
                                          valueListenable: _obscure,
                                          builder: (context, obscure, _) {
                                            return TextField(
                                              controller: pass,
                                              focusNode: _passFocus,
                                              obscureText: obscure,
                                              textInputAction:
                                                  TextInputAction.done,
                                              autofillHints: const [
                                                AutofillHints.password,
                                              ],
                                              onChanged: context
                                                  .read<LoginFormCubit>()
                                                  .passwordChanged,
                                              onSubmitted: (_) => submit(),
                                              decoration: InputDecoration(
                                                labelText: 'Password',
                                                prefixIcon: const Icon(
                                                  Icons.lock_outline,
                                                ),
                                                border:
                                                    const OutlineInputBorder(),
                                                suffixIcon: IconButton(
                                                  onPressed: () =>
                                                      _obscure.value =
                                                          !_obscure.value,
                                                  icon: Icon(
                                                    obscure
                                                        ? Icons
                                                              .visibility_outlined
                                                        : Icons
                                                              .visibility_off_outlined,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 16),

                                        if (authState.status ==
                                            AuthStatus.failure)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 8,
                                            ),
                                            child: Text(
                                              authState.error ??
                                                  'Login failed.',
                                              style: const TextStyle(
                                                color: Colors.red,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),

                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed:
                                                (loading ||
                                                    !formState.canSubmit)
                                                ? null
                                                : submit,
                                            child: const Text('Login'),
                                          ),
                                        ),
                                      ],
                                    ),

                                    if (loading)
                                      Positioned.fill(
                                        child: AbsorbPointer(
                                          absorbing: true,
                                          child: Container(
                                            color: Colors.black.withValues(
                                              alpha: 0.3,
                                            ),
                                            child: const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
