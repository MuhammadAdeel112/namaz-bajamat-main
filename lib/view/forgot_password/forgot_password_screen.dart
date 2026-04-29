import 'package:flutter/material.dart';
import '../../config/components/round_button.dart';
import '../shared_widgets/custom_text_field.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController phoneEmailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String contact = '';

  @override
  void dispose() {
    // TODO: implement dispose
    phoneEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Centered content
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Forgot Password',
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Email or Phone field
                      CustomTextField(
                        label: 'Email or Phone',
                        hint: 'Enter your email or phone number',
                        onChanged: (value) => contact = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email or phone number';
                          }
                          return null;
                        },
                        textEditingController: phoneEmailController,
                      ),
                      const SizedBox(height: 24),

                      // Submit button
                      RoundButton(
                        title: 'Send Reset Request',
                        onPress: () {
                          if (_formKey.currentState!.validate()) {
                            // Handle forgot password logic
                            print('Send reset link to: $contact');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Back to login link at the bottom
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    // Navigate back to login screen
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Back to Login",
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
