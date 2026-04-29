import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namaz_bajamat/bloc/visitor_profile/visitor_profile_bloc.dart';
import 'package:namaz_bajamat/config/components/round_button.dart';
import 'package:namaz_bajamat/config/routes/routes_name.dart';
import 'package:namaz_bajamat/cubit/address_field_cubit/address_field_cubit.dart';
import 'package:namaz_bajamat/services/session_controller/session_controller.dart';
import 'package:namaz_bajamat/utils/extensions/flush_bar_extension.dart';
import 'package:namaz_bajamat/view/shared_widgets/address_field.dart';

import '../../shared_widgets/custom_text_field.dart';

class UpdateVisitorProfileScreen extends StatefulWidget {
  const UpdateVisitorProfileScreen({super.key});

  @override
  State<UpdateVisitorProfileScreen> createState() =>
      _UpdateVisitorProfileScreenState();
}

class _UpdateVisitorProfileScreenState
    extends State<UpdateVisitorProfileScreen> {

  late final AddressFieldCubit _addressCubit;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    final visitor = SessionController.visitor;
    super.initState();

    _addressCubit = context.read<AddressFieldCubit>();

    nameController.text = visitor?.name ?? "";
    phoneController.text = visitor?.phone ?? "";
    emailController.text = visitor?.email ?? "";
    final address = SessionController.visitor?.location?.address ?? "";
    final lat = SessionController.visitor?.location?.coordinates?.lat ?? 0;
    final lng = SessionController.visitor?.location?.coordinates?.lng ?? 0;
    _addressCubit.setLocation(address, lat.toDouble(), lng.toDouble());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    _addressCubit.clear();
    super.dispose();
  }

  final screenSize = 0;

  final _formKey = GlobalKey<FormState>();
  final _addressFieldKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => VisitorProfileBloc(),
      child: Scaffold(
        body: SafeArea(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height - 100,
            child: Center(
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Update Profile",
                              style: theme.textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
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
                          // CustomTextField(
                          //   label: 'Password',
                          //   hint: '********',
                          //   obscureText: true,
                          //   textInputType: TextInputType.visiblePassword,
                          //   onChanged: (value) {},
                          //   validator: (value) =>
                          //       (value == null || value.isEmpty)
                          //           ? 'Password is required'
                          //           : (value.length < 4
                          //               ? 'Password too Short'
                          //               : null),
                          //   inputFormatters: [
                          //     FilteringTextInputFormatter.deny(RegExp(r"\s")),
                          //   ],
                          //   textEditingController: passwordController,
                          // ),
                          // const SizedBox(height: 12),
                          AddressField(showLabel: true,formKey: _addressFieldKey,),
                          const SizedBox(height: 24),
                          BlocConsumer<VisitorProfileBloc, VisitorProfileState>(
                            listener: (context, state) {
                              state.whenOrNull(
                                success: (visitor) {
                                  context.flushBarSuccessMessage(
                                      message: "Profile Update Successfully");
                                  Future.delayed(const Duration(seconds: 1))
                                      .then((onValue) {
                                    bool found = false;
                                    Navigator.popUntil(context, (route) {
                                      if (route.settings.name == RoutesName.dashboard) {
                                        found = true;
                                        return true;
                                      }
                                      return false;
                                    });
                                    if(kDebugMode) print("Route found: $found");
                                    if (!found) {
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        RoutesName.dashboard,
                                            (route) => false,
                                      );
                                    }
                                  });
                                },
                                error: (message) {
                                  context.flushBarErrorMessage(
                                      message: message);
                                },
                              );
                            },
                            builder: (context, state) {
                              final isLoading = state.maybeWhen(
                                  loading: () => true, orElse: () => false);

                              return RoundButton(
                                title: 'Update',
                                loading: isLoading,
                                onPress: () {
                                  if (_formKey.currentState!.validate() && _addressFieldKey.currentState!.validate()) {
                                    FocusScope.of(context).unfocus();
                                    final name = nameController.text.trim();
                                    final phone = phoneController.text.trim();
                                    final email = emailController.text.trim();
                                    final password =
                                        passwordController.text.trim();

                                    final addressState =
                                        context.read<AddressFieldCubit>().state;

                                    final selectedAddress =
                                        addressState.selectedAddress;
                                    final lat = addressState.latitude;
                                    final lng = addressState.longitude;

                                    context.read<VisitorProfileBloc>().add(
                                          UpdateProfile(
                                            name: name,
                                            phoneNo: phone,
                                            email: email,
                                            password: password,
                                            address: selectedAddress,
                                            latitude: lat ?? 0.0,
                                            longitude: lng ?? 0.0,
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
