import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namaz_bajamat/bloc/login/login_bloc.dart';
import 'package:namaz_bajamat/bloc/login/login_state.dart';
import 'package:namaz_bajamat/services/session_controller/session_controller.dart';
import 'package:namaz_bajamat/utils/extensions/flush_bar_extension.dart';
import '../../bloc/login/login_event.dart';
import '../../config/components/round_button.dart';
import '../../config/routes/routes_name.dart';
import '../../utils/enums.dart';
import '../shared_widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String phone = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Login',
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Phone number field
                        CustomTextField(
                          label: 'Phone Number',
                          hint: 'Enter your phone number',
                          onChanged: (value) => phone = value,
                          textInputType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                          textEditingController: phoneController,
                        ),
                        const SizedBox(height: 16),

                        // Password field
                        CustomTextField(
                          label: 'Password',
                          hint: 'Enter your password',
                          obscureText: true,
                          textInputType: TextInputType.visiblePassword,
                          onChanged: (value) => password = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          textEditingController: passwordController,
                        ),

                        // // Forgot Password link
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: TextButton(
                        //     onPressed: () {
                        //       // Navigate to forgot password screen
                        //     },
                        //     child: Text(
                        //       'Forgot Password?',
                        //       style: textTheme.bodySmall?.copyWith(
                        //         color: colorScheme.primary,
                        //         fontWeight: FontWeight.w500,
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        // in place of forget button
                        const SizedBox(height: 40),

                        const SizedBox(height: 8),

                        BlocConsumer<LoginBloc, LoginState>(
                          listener: (context, state) {
                            state.maybeWhen(
                              error: (message) {
                                context.flushBarErrorMessage(message: message);
                              },
                              success: (user) {
                                context.flushBarSuccessMessage(message: "Welcome ${user?.imam?.name ?? ""}!");
                                Future.delayed(const Duration(milliseconds: 1000)).then((onValue){
                                  Navigator.pushNamedAndRemoveUntil(context, RoutesName.dashboard, (_) => false);
                                });
                              },
                              orElse: () {},
                            );
                          },
                          builder: (context, state) {
                            return state.maybeMap(
                              loading: (_) => RoundButton(
                                title: 'Login',
                                onPress: () {},
                                loading: true,
                              ),
                              orElse: () => RoundButton(
                                title: 'Login',
                                onPress: () {
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    final phone = phoneController.text.trim();
                                    final password = passwordController.text.trim();

                                    context.read<LoginBloc>().add(
                                      LoginSubmitted(phone: phone, password: password),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        )


                        // Round login button
                        // BlocBuilder<LoginBloc, LoginState>(
                        //   builder: (context, state) {
                        //     return RoundButton(
                        //       title: 'Login',
                        //       onPress: () {
                        //         if (_formKey.currentState!.validate()) {
                        //           // Handle login
                        //           print('Logging in with: $phone, $password');
                        //         }
                        //       },
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ),
              ),

              // Sign up link at the bottom
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      if(SessionController.role == Role.visitor){
                        Navigator.pushNamed(context, RoutesName.visitorSignup);
                      }else if(SessionController.role == Role.imam){
                        Navigator.pushNamed(context, RoutesName.imamSignup);
                      }
                    },
                    child: Text(
                      "Don't have an account? Sign up",
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
      ),
    );
  }
}
