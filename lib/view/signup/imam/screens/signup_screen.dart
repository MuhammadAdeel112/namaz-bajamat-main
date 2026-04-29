import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:namaz_bajamat/config/components/round_button.dart';
import 'package:namaz_bajamat/utils/extensions/flush_bar_extension.dart';

import '../../../../bloc/signup/signup_bloc.dart';
import '../../../../config/routes/routes_name.dart';
import '../../../../utils/image_utils.dart';
import '../../../shared_widgets/custom_text_field.dart';
import '../../../shared_widgets/image_source_bottom_sheet.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class ImamSignupScreen extends StatefulWidget {
  const ImamSignupScreen({super.key});

  @override
  State<ImamSignupScreen> createState() => _ImamSignupScreenState();
}

class _ImamSignupScreenState extends State<ImamSignupScreen> {
  late final KeyboardVisibilityController _keyboardVisibilityController;
  late final Stream<bool> _keyboardStream;
  File? _image;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController designationController = TextEditingController();

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
    addressController.dispose();
    cnicController.dispose();
    designationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final img = await ImageUtils.pickImage(source);
    if (img != null) {
      context.read<SignupBloc>().add(ProfilePicChanged(img));
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ImageSourceBottomSheet(
        onImageSelected: _pickImage,
      ),
    );
  }

  final screenSize = 0;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final theme = Theme.of(context);

    return Scaffold(
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
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(context);
                          },
                          child: BlocBuilder<SignupBloc, SignupState>(
                            builder: (context, state) {
                              return CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey,
                                foregroundColor: theme.colorScheme.primary,
                                foregroundImage: state.profilePic != null
                                    ? FileImage(state.profilePic!)
                                    : null,
                                child: Stack(
                                  children: [
                                    const Icon(Icons.person, size: 40),
                                    Positioned(
                                      right: -5,
                                      top: 0,
                                      child: Icon(
                                        Icons.add,
                                        color: theme.colorScheme.primary,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: 'Name',
                          hint: 'Enter your name',
                          textInputType: TextInputType.name,
                          onChanged: (value) {},
                          validator: (value) => value == null || value.isEmpty
                              ? 'Name is required'
                              : ( value.length < 3 ? 'Provide a full name' : null),
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
                          validator: (value) => (value == null || value.isEmpty)
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
                              final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
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
                          validator: (value) => (value == null || value.isEmpty)
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
                        CustomTextField(
                          label: 'Address',
                          hint: 'Enter your address',
                          textInputType: TextInputType.streetAddress,
                          onChanged: (value) {},
                          validator: (value) => value == null || value.isEmpty
                              ? 'Address is required'
                              : (value.length < 8
                              ? 'Provide a valid address'
                              : null),
                          textEditingController: addressController,
                        ),
                        // const SizedBox(height: 12),
                        // CustomTextField(
                        //   label: 'CNIC',
                        //   hint: 'xxxxx-xxxxxxx-x',
                        //   textInputType: TextInputType.number,
                        //   inputFormatters: [
                        //     FilteringTextInputFormatter.digitsOnly,
                        //     LengthLimitingTextInputFormatter(13),
                        //   ],
                        //   onChanged: (value) {},
                        //   validator: (value) => (value == null || value.isEmpty)
                        //       ? 'CNIC is required'
                        //       : (value.length != 13
                        //           ? 'CNIC must be exactly 13 digits'
                        //           : null),
                        //   textEditingController: cnicController,
                        // ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          label: 'Designation',
                          hint: 'Enter your role/designation',
                          textInputType: TextInputType.text,
                          onChanged: (value) {},
                          validator: (value) => value == null || value.isEmpty
                              ? 'Designation is required'
                              : null,
                          textEditingController: designationController,
                        ),
                        const SizedBox(height: 24),
                        RoundButton(
                          onPress: () {
                            if (formKey.currentState!.validate()) {
                              final signupState =
                                  context.read<SignupBloc>().state;
                              if (signupState.profilePic != null) {
                                context.read<SignupBloc>().add(
                                      ImamDetailsSubmitted(
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        address: addressController.text,
                                        cnic: cnicController.text,
                                        designation: designationController.text,
                                      ),
                                    );
                                Navigator.pushNamed(
                                    context, RoutesName.masjidDetails);
                              } else {
                                context.flushBarErrorMessage(
                                    message: "Provide a Profile Picture");
                              }
                            }
                          },
                          title: 'Sign Up',
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
    );
  }
}
