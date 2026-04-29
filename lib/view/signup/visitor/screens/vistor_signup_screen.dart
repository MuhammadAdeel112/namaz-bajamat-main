
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namaz_bajamat/bloc/visitor_signup/visitor_signup_bloc.dart';
import 'package:namaz_bajamat/bloc/visitor_signup/visitor_signup_state.dart';
import 'package:namaz_bajamat/bloc/visitor_signup/visitor_signup_event.dart';
import 'package:namaz_bajamat/config/components/round_button.dart';
import 'package:namaz_bajamat/utils/extensions/flush_bar_extension.dart';

import '../../../../config/routes/routes_name.dart';
import '../../../../cubit/address_field_cubit/address_field_cubit.dart';
import '../../../shared_widgets/address_field.dart';
import '../../../shared_widgets/custom_text_field.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class VistorSignupScreen extends StatefulWidget {
  const VistorSignupScreen({super.key});

  @override
  State<VistorSignupScreen> createState() => _VistorSignupScreenState();
}

class _VistorSignupScreenState extends State<VistorSignupScreen> {
  late final KeyboardVisibilityController _keyboardVisibilityController;
  late final Stream<bool> _keyboardStream;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _keyboardVisibilityController = KeyboardVisibilityController();
    _keyboardStream = _keyboardVisibilityController.onChange;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    context.read<AddressFieldCubit>().clear();
    super.dispose();
  }

  final screenSize = 0;

  final formKey = GlobalKey<FormState>();
  final _addressFieldKey = GlobalKey<FormFieldState>();


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => VisitorSignupBloc(),
      child: Scaffold(
        floatingActionButton: StreamBuilder<bool>(
            stream: _keyboardStream,
            initialData: _keyboardVisibilityController.isVisible,
            builder: (context, snapshot) {
              final isKeyboardVisible = snapshot.data ?? false;
              if (isKeyboardVisible) {
                return const SizedBox.shrink();
              } else {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.login);
                  },
                  child: Text(
                    "Already have an account? Login",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                  ),
                );
              }
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SafeArea(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height - 100,
            child: Center(
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextField(
                            label: 'Name',
                            hint: 'Enter your name',
                            textInputType: TextInputType.name,
                            onChanged: (value) {},
                            validator: (value) => value == null || value.isEmpty
                                ? 'Name is required'
                                : (value.length < 3
                                    ? 'Provide a full name'
                                    : null),
                            textEditingController: nameController,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            label: 'Phone No',
                            hint: '03xx-xxxxxxx',
                            textInputType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(11),
                            ],
                            onChanged: (value) {},
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                    ? 'Phone is required'
                                    : (value.length != 11
                                        ? 'Phone No must be exactly 11 digits'
                                        : null),
                            textEditingController: phoneController,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            label: 'Email',
                            hint: 'you@example.com',
                            textInputType: TextInputType.emailAddress,
                            onChanged: (value) {},
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final emailRegex =
                                    RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                                if (!emailRegex.hasMatch(value)) {
                                  return "Enter a valid email";
                                }
                              }
                              return null;
                            },
                            textEditingController: emailController,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            label: 'Password',
                            hint: '********',
                            obscureText: true,
                            textInputType: TextInputType.visiblePassword,
                            onChanged: (value) {},
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                    ? 'Password is required'
                                    : (value.length < 4
                                        ? 'Password too Short'
                                        : null),
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r"\s")),
                            ],
                            textEditingController: passwordController,
                          ),
                          const SizedBox(height: 12),
                          // CustomTextField(
                          //   label: 'Address',
                          //   hint: 'Enter your address',
                          //   textInputType: TextInputType.streetAddress,
                          //   onChanged: (value) {},
                          //   validator: (value) => value == null || value.isEmpty
                          //       ? 'Address is required'
                          //       : (value.length < 8
                          //           ? 'Provide a valid address'
                          //           : null),
                          //   textEditingController: addressController,
                          // ),
                          AddressField(showLabel: true,formKey: _addressFieldKey,),
                          const SizedBox(height: 24),
                          BlocConsumer<VisitorSignupBloc, VisitorSignupState>(
                            listener: (context, state) {
                              state.whenOrNull(
                                success: () {
                                  Future.delayed(const Duration(seconds: 1)).then((onValue){
                                    context.flushBarSuccessMessage(message: "Signup Successful\nYou can now login!");
                                  });
                                  Navigator.pushNamed(context, RoutesName.login);
                                },
                                error: (message) {
                                  context.flushBarErrorMessage(message: message);
                                },
                              );
                            },
                            builder: (context, state) {
                              final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);

                              return RoundButton(
                                title: 'Sign Up',
                                loading: isLoading,
                                onPress: () {
                                  if (formKey.currentState!.validate() && _addressFieldKey.currentState!.validate()) {
                                    final name = nameController.text.trim();
                                    final phone = phoneController.text.trim();
                                    final email = emailController.text.trim();
                                    final password = passwordController.text.trim();
                                    final addressFieldState =  context.read<AddressFieldCubit>().state;
                                    final address =  addressFieldState.selectedAddress;
                                    final lat =  addressFieldState.latitude;
                                    final lng =  addressFieldState.longitude;

                                    context.read<VisitorSignupBloc>().add(
                                      SignupSubmitted(
                                        name: name,
                                        phoneNo: phone,
                                        email: email,
                                        password: password,
                                        address: address,
                                        lat: lat ?? 0.0,
                                        lng: lng ?? 0.0,
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
