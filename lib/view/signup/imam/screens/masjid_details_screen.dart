import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namaz_bajamat/config/components/round_button.dart';
import 'package:namaz_bajamat/utils/extensions/enum_extensions.dart';
import 'package:namaz_bajamat/utils/extensions/flush_bar_extension.dart';
import 'package:namaz_bajamat/view/shared_widgets/custom_dropdown.dart';
import 'package:namaz_bajamat/view/shared_widgets/google_maps_address_picker.dart';
import '../../../../bloc/signup/signup_bloc.dart';
import '../../../../config/routes/routes_name.dart';
import '../../../../utils/enums.dart';
import '../../../shared_widgets/custom_text_field.dart';
import '../widgets/masjid_image_picker.dart';
import '../widgets/province_dropdown.dart';

class MasjidDetailsScreen extends StatefulWidget {
  const MasjidDetailsScreen({super.key});

  @override
  State<MasjidDetailsScreen> createState() => _MasjidDetailsScreenState();
}

class _MasjidDetailsScreenState extends State<MasjidDetailsScreen> {
  final formKey = GlobalKey<FormState>();

  final ValueNotifier<bool?> jumma = ValueNotifier(false);
  final ValueNotifier<bool?> eid = ValueNotifier(false);
  final ValueNotifier<bool?> parking = ValueNotifier(false);
  final ValueNotifier<String?> maghribDelay = ValueNotifier('No delay');
  final ValueNotifier<bool?> womenPrayer = ValueNotifier(false);
  final ValueNotifier<bool?> wuzu = ValueNotifier(false);

  final ValueNotifier<String?> _selectedProvince = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _selectedMaslik = ValueNotifier<String?>(null);

  TextEditingController masjidNameController = TextEditingController();
  TextEditingController masjidAddressController = TextEditingController();
  TextEditingController masjidCityController = TextEditingController();
  TextEditingController masjidProvinceController = TextEditingController();
  TextEditingController masjidCountryController = TextEditingController();
  TextEditingController masjidContactInfoController = TextEditingController();
  TextEditingController masjidNearbyLandmarksController =
      TextEditingController();

  @override
  void dispose() {
    jumma.dispose();
    eid.dispose();
    parking.dispose();
    maghribDelay.dispose();
    womenPrayer.dispose();
    wuzu.dispose();
    masjidNameController.dispose();
    masjidAddressController.dispose();
    masjidCityController.dispose();
    masjidProvinceController.dispose();
    masjidCountryController.dispose();
    masjidContactInfoController.dispose();
    masjidNearbyLandmarksController.dispose();
    _selectedProvince.dispose();
    super.dispose();
  }

  var masjidAddress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    const spacer = SizedBox(height: 12);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Masjid Details', style: textTheme.titleLarge),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("General Details",
                  style: textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              spacer,
              CustomTextField(
                label: 'Masjid Name',
                hint: 'Enter name of Masjid',
                onChanged: (value) {},
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
                textEditingController: masjidNameController,
              ),
              spacer,
              CustomDropdown(
                label: "Maslik",
                selectedValue: _selectedMaslik,
                values: Fiqa.values.map((f) => f.label).toList(),
              ),
              spacer,
              CustomTextField(
                label: 'Address',
                hint: 'Street, Area, etc.',
                readOnly: true,
                onTap: () async {
                  masjidAddress = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GoogleMapAddressPicker()),
                  );

                  if (masjidAddress != null) {
                    print("Selected Masjid Address: $masjidAddress");
                    // You can now store it in your Bloc state or TextEditingController
                    final addressString = masjidAddress['address'] ?? '';
                    masjidAddressController.text = addressString;

                    // Optionally, store full JSON in your Bloc state for API
                    final json = jsonEncode(masjidAddress);
                    // context.read<SignupBloc>().add(UpdateMasjidAddressJson(json));
                  }

                },
                onChanged: (value) {},
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
                textEditingController: masjidAddressController,
              ),
              spacer,
              CustomTextField(
                label: 'City',
                hint: 'City name',
                onChanged: (value) {},
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
                textEditingController: masjidCityController,
              ),
              spacer,
              ProvinceDropdown(selectedProvince: _selectedProvince),
              spacer,
              CustomTextField(
                label: 'Country',
                hint: 'Country',
                onChanged: (value) {},
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
                textEditingController: masjidCountryController,
              ),
              spacer,
              CustomTextField(
                label: 'Contact Info',
                hint: 'Phone / Email',
                onChanged: (value) {},
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
                textEditingController: masjidContactInfoController,
              ),
              spacer,
              CustomTextField(
                label: 'Nearby Landmarks',
                hint: 'Any nearby landmarks',
                onChanged: (value) {},
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
                textEditingController: masjidNearbyLandmarksController,
              ),
              spacer,
              const MasjidImagePicker(),
              const SizedBox(height: 24),
              Text("Additional Details",
                  style: textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              spacer,
              buildYesNoRadio("Jumma Prayer", jumma, theme),
              buildYesNoRadio("Eid Prayer", eid, theme),
              buildYesNoRadio("Parking Facility", parking, theme),
              Text("Maghrib Prayer Delay:", style: textTheme.titleMedium),
              ValueListenableBuilder(
                valueListenable: maghribDelay,
                builder: (_, value, __) {
                  return Wrap(
                    spacing: 8,
                    children: [
                      "2 minutes",
                      "3 minutes",
                      "5 minutes",
                      "No delay"
                    ].map((label) {
                      return ChoiceChip(
                        label: Text(label, style: textTheme.bodyMedium),
                        selected: value == label,
                        selectedColor:
                            theme.colorScheme.primary.withOpacity(0.2),
                        onSelected: (_) => maghribDelay.value = label,
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text("Women Facilities",
                  style: textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              spacer,
              buildYesNoRadio("Prayer Area", womenPrayer, theme),
              buildYesNoRadio("Wuzu Area", wuzu, theme),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: BlocConsumer<SignupBloc, SignupState>(
                  buildWhen: (previous, current) => previous != current,
                  listenWhen: (previous, current) =>
                      previous.errorMessage != current.errorMessage ||
                      previous.isSuccess != current.isSuccess,
                  listener: (context, state) {
                    if (state.isSuccess) {
                      Future.delayed(Duration(seconds: 1)).then((_){
                        context.flushBarSuccessMessage(
                            message: "Success Signing up");
                      });
                      Navigator.pushNamed(context, RoutesName.login);
                    }else if (state.errorMessage != null &&
                        state.isSubmitting == false) {
                      context.flushBarErrorMessage(
                          message: state.errorMessage!);
                    }
                  },
                  builder: (context, state) {
                    return RoundButton(
                      loading: state.isSubmitting,
                      onPress: () {
                        if (formKey.currentState!.validate()) {
                          final signupState = context.read<SignupBloc>().state;

                          if (jumma.value == null ||
                              eid.value == null ||
                              parking.value == null ||
                              maghribDelay.value == null ||
                              womenPrayer.value == null ||
                              wuzu.value == null) {
                            context.flushBarErrorMessage(
                                message: "Missing Required Fields");
                          } else if (signupState.masjidPic == null) {
                            context.flushBarErrorMessage(
                                message: "Please Add Masjid Picture");
                          } else {
                            // Save masjid details in state
                            context.read<SignupBloc>().add(
                                  MasjidDetailsSubmitted(
                                    masjidName: masjidNameController.text,
                                    maslik: _selectedMaslik.value ?? "",
                                    masjidAddress: masjidAddress,
                                    masjidCity: masjidCityController.text,
                                    masjidProvince:
                                    _selectedProvince.value ?? "",
                                    masjidCountry: masjidCountryController.text,
                                    masjidContactInfo:
                                        masjidContactInfoController.text,
                                    masjidNearbyLandmarks:
                                        masjidNearbyLandmarksController.text,
                                    jumma: jumma.value ?? false,
                                    eid: eid.value ?? false,
                                    parking: parking.value ?? false,
                                    maghribDelay:
                                        maghribDelay.value ?? "No delay",
                                    womenPrayerArea: womenPrayer.value ?? false,
                                    womenWuzuArea: wuzu.value ?? false,
                                  ),
                                );

                            context.read<SignupBloc>().add(SignupSubmitted());
                          }
                        }
                      },
                      title: 'Submit',
                    );
                  },
                ),
              ),
              // SizedBox(
              //   width: double.infinity,
              //   child: BlocConsumer<SignupBloc, SignupState>(
              //     listener: (context, state) {
              //       if(state.isSuccess == false){
              //         context.flushBarErrorMessage(
              //             message: "Missing Required Fields");
              //       }
              //     },
              //     builder: (context, state) {
              //       return RoundButton(
              //         loading: state.isSubmitting,
              //         onPress: () {
              //           if (formKey.currentState!.validate()) {
              //             final signupState = context
              //                 .read<SignupBloc>()
              //                 .state;
              //             if (jumma.value == null ||
              //                 eid.value == null ||
              //                 parking.value == null ||
              //                 maghribDelay.value == null ||
              //                 womenPrayer == null ||
              //                 wuzu.value == null) {
              //               context.flushBarErrorMessage(
              //                   message: "Missing Required Fields");
              //             } else if (signupState.masjidPic == null) {
              //               context.flushBarErrorMessage(
              //                   message: "Please Add Majid Picture");
              //             } else {
              //               context.read<SignupBloc>().add(
              //                 MasjidDetailsSubmitted(
              //                   masjidName: masjidNameController.text,
              //                   masjidAddress: masjidAddressController.text,
              //                   masjidCity: masjidCityController.text,
              //                   masjidProvince: masjidProvinceController.text,
              //                   masjidCountry: masjidCountryController.text,
              //                   masjidContactInfo:
              //                   masjidContactInfoController.text,
              //                   masjidNearbyLandmarks:
              //                   masjidNearbyLandmarksController.text,
              //                   jumma: jumma.value ?? false,
              //                   eid: eid.value ?? false,
              //                   parking: parking.value ?? false,
              //                   maghribDelay: maghribDelay.value ?? "No delay",
              //                   womenPrayerArea: womenPrayer.value ?? false,
              //                   womenWuzuArea: wuzu.value ?? false,
              //                 ),
              //               );
              //             }
              //           }
              //         },
              //         title: 'Submit',
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildYesNoRadio(
      String title, ValueNotifier<bool?> controller, ThemeData theme) {
    final textTheme = theme.textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(title, style: textTheme.titleMedium)),
        ValueListenableBuilder(
          valueListenable: controller,
          builder: (_, value, __) {
            return Row(
              children: [
                Radio<bool>(
                  value: true,
                  groupValue: value,
                  onChanged: (val) => controller.value = val,
                ),
                Text('Yes', style: textTheme.bodyMedium),
                Radio<bool>(
                  value: false,
                  groupValue: value,
                  onChanged: (val) => controller.value = val,
                ),
                Text('No', style: textTheme.bodyMedium),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
