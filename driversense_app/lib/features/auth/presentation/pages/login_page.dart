import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:driversense_app/core/router/routes.dart';
import 'package:driversense_app/core/theme/app_spacing.dart';
import 'package:driversense_app/core/utils/validators.dart';
import 'package:driversense_app/core/utils/extensions/context_extensions.dart';
import 'package:driversense_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:driversense_app/shared/widgets/buttons/primary_button.dart';
import 'package:driversense_app/shared/widgets/inputs/app_text_field.dart';
import 'package:driversense_app/shared/widgets/feedback/loading_overlay.dart';

/// Login page for user authentication
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.hideKeyboard();
      context.read<AuthBloc>().add(AuthLoginRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.status != current.status,
      listener: (context, state) {
        if (state.hasError && state.error != null) {
          context.showErrorSnackBar(state.error!);
        }
        if (state.needs2FA) {
          context.go(Routes.twoFactor, extra: state.sessionToken);
        }
        if (state.needsConsent) {
          context.go(Routes.consent);
        }
        if (state.isAuthenticated) {
          context.go(Routes.home);
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state.isLoading,
          child: Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: AppSpacing.screenPadding,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: AppSpacing.xxl),

                      // Logo
                      Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.drive_eta,
                              size: 80,
                              color: context.colorScheme.primary,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'DriverSense',
                              style: context.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xxl),

                      // Welcome text
                      Text(
                        context.l10n.login,
                        style: context.textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // Email field
                      AppTextField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        label: context.l10n.email,
                        hint: 'naam@bedrijf.nl',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: Validators.email,
                        onFieldSubmitted: (_) {
                          context.requestFocus(_passwordFocusNode);
                        },
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // Password field
                      AppTextField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        label: context.l10n.password,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        validator: Validators.password,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        onFieldSubmitted: (_) => _onLogin(),
                      ),

                      const SizedBox(height: AppSpacing.sm),

                      // Forgot password link
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: Navigate to forgot password
                          },
                          child: Text(context.l10n.forgotPassword),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Login button
                      PrimaryButton(
                        onPressed: _onLogin,
                        text: context.l10n.login,
                      ),

                      const SizedBox(height: AppSpacing.xxl),

                      // Version info
                      Center(
                        child: Text(
                          'Versie 1.0.0',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.outline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
