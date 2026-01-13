import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:driversense_app/core/router/routes.dart';
import 'package:driversense_app/core/theme/app_spacing.dart';
import 'package:driversense_app/core/utils/validators.dart';
import 'package:driversense_app/core/utils/extensions/context_extensions.dart';
import 'package:driversense_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:driversense_app/shared/widgets/buttons/primary_button.dart';
import 'package:driversense_app/shared/widgets/feedback/loading_overlay.dart';

/// Two-factor authentication page
class TwoFactorPage extends StatefulWidget {
  final String? sessionToken;

  const TwoFactorPage({super.key, this.sessionToken});

  @override
  State<TwoFactorPage> createState() => _TwoFactorPageState();
}

class _TwoFactorPageState extends State<TwoFactorPage> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _onVerify() {
    final code = _code;
    if (code.length == 6) {
      context.hideKeyboard();
      context.read<AuthBloc>().add(Auth2FARequested(code: code));
    }
  }

  void _onDigitChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      // Move to next field
      context.requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      // Move to previous field on backspace
      context.requestFocus(_focusNodes[index - 1]);
    }

    // Auto-submit when all digits entered
    if (_code.length == 6) {
      _onVerify();
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
          // Clear input on error
          for (final controller in _controllers) {
            controller.clear();
          }
          context.requestFocus(_focusNodes[0]);
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
            appBar: AppBar(
              title: const Text('Verificatie'),
            ),
            body: SafeArea(
              child: Padding(
                padding: AppSpacing.screenPadding,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: AppSpacing.xl),

                      // Icon
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: context.colorScheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.lock_outline,
                            size: 48,
                            color: context.colorScheme.primary,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Title
                      Text(
                        'Tweefactorauthenticatie',
                        style: context.textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: AppSpacing.sm),

                      // Description
                      Text(
                        'Voer de 6-cijferige code in van je authenticator app',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.outline,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // Code input
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(6, (index) {
                          return SizedBox(
                            width: 48,
                            child: TextFormField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style: context.textTheme.headlineMedium,
                              decoration: InputDecoration(
                                counterText: '',
                                border: OutlineInputBorder(
                                  borderRadius: AppSpacing.borderRadiusMd,
                                ),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (value) => _onDigitChanged(index, value),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // Verify button
                      PrimaryButton(
                        onPressed: _code.length == 6 ? _onVerify : null,
                        text: 'Verifiëren',
                      ),

                      const Spacer(),

                      // Back to login
                      TextButton(
                        onPressed: () {
                          context.go(Routes.login);
                        },
                        child: const Text('Terug naar inloggen'),
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
