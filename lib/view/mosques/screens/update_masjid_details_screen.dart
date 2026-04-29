import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:namaz_bajamat/config/components/round_button.dart';
import 'package:namaz_bajamat/utils/extensions/enum_extensions.dart';
import 'package:namaz_bajamat/utils/extensions/flush_bar_extension.dart';
import 'package:namaz_bajamat/view/shared_widgets/custom_dropdown.dart';
import 'package:namaz_bajamat/view/shared_widgets/google_maps_address_picker.dart';
import 'package:http/http.dart' as http;

import '../../../model/all_mosques_model.dart';
import '../../../../utils/enums.dart';
import '../../../services/session_controller/session_controller.dart';
import '../../../utils/app_url.dart';
import '../../shared_widgets/custom_text_field.dart';
import '../../signup/imam/widgets/masjid_image_picker.dart';
import '../../signup/imam/widgets/province_dropdown.dart';

class UpdateMasjidDetailsScreen extends StatefulWidget {
  const UpdateMasjidDetailsScreen({super.key, required this.model});

  final Masjids model;

  @override
  State<UpdateMasjidDetailsScreen> createState() => _UpdateMasjidDetailsScreenState();
}

class _UpdateMasjidDetailsScreenState extends State<UpdateMasjidDetailsScreen> {
  final formKey = GlobalKey<FormState>();

  final ValueNotifier<bool?> jumma = ValueNotifier(false);
  final ValueNotifier<bool?> eid = ValueNotifier(false);
  final ValueNotifier<bool?> parking = ValueNotifier(false);
  final ValueNotifier<String?> maghribDelay = ValueNotifier('No delay');
  final ValueNotifier<bool?> womenPrayer = ValueNotifier(false);
  final ValueNotifier<bool?> wuzu = ValueNotifier(false);

  final ValueNotifier<String?> _selectedProvince = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _selectedMaslik = ValueNotifier<String?>(null);

  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  TextEditingController masjidNameController = TextEditingController();
  TextEditingController masjidAddressController = TextEditingController();
  TextEditingController masjidCityController = TextEditingController();
  TextEditingController masjidProvinceController = TextEditingController();
  TextEditingController masjidCountryController = TextEditingController();
  TextEditingController masjidContactInfoController = TextEditingController();
  TextEditingController masjidNearbyLandmarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _prefillFromModel(widget.model);
  }

  void _prefillFromModel(Masjids m) {
    masjidNameController.text = m.name ?? '';
    masjidAddressController.text = m.masjidAddress?.address ?? '';
    masjidCityController.text = m.city ?? '';
    masjidProvinceController.text = m.province ?? '';
    masjidCountryController.text = m.country ?? '';
    masjidContactInfoController.text = m.contactInfo ?? '';
    masjidNearbyLandmarksController.text = m.nearbyLandmark ?? '';

    _selectedProvince.value = m.province;
    _selectedMaslik.value = m.maslik;

    bool? _yn(String? s) {
      if (s == null) return null;
      final v = s.toLowerCase();
      if (v == 'yes' || v == 'true') return true;
      if (v == 'no' || v == 'false') return false;
      return null;
    }

    jumma.value = _yn(m.jummahPrayer) ?? false;
    eid.value = _yn(m.eidPrayer) ?? false;
    parking.value = _yn(m.parkingFacility) ?? false;
    womenPrayer.value = _yn(m.prayerArea) ?? false;
    wuzu.value = _yn(m.wazuArea) ?? false;
    maghribDelay.value = m.magribPrayerDelay ?? 'No delay';

    masjidAddress = m.masjidAddress == null
        ? null
        : {
      'address': m.masjidAddress!.address ?? '',
      'coordinates': {
        'lat': m.masjidAddress!.coordinates?.lat,
        'lng': m.masjidAddress!.coordinates?.lng,
      },
    };
  }

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
    _selectedMaslik.dispose();
    _isLoading.dispose();
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
                  style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              spacer,
              CustomTextField(
                label: 'Masjid Name',
                hint: 'Enter name of Masjid',
                onChanged: (value) {},
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
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
                    // You can now store it in your local state or TextEditingController
                    final addressString = masjidAddress['address'] ?? '';
                    masjidAddressController.text = addressString;

                    // Optionally, keep the full JSON for API
                    final json = jsonEncode(masjidAddress);
                    // ignore: unused_local_variable
                    final _ = json;
                  }
                },
                onChanged: (value) {},
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                textEditingController: masjidAddressController,
              ),
              spacer,
              CustomTextField(
                label: 'City',
                hint: 'City name',
                onChanged: (value) {},
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                textEditingController: masjidCityController,
              ),
              spacer,
              ProvinceDropdown(selectedProvince: _selectedProvince),
              spacer,
              CustomTextField(
                label: 'Country',
                hint: 'Country',
                onChanged: (value) {},
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                textEditingController: masjidCountryController,
              ),
              spacer,
              CustomTextField(
                label: 'Contact Info',
                hint: 'Phone / Email',
                onChanged: (value) {},
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                textEditingController: masjidContactInfoController,
              ),
              spacer,
              CustomTextField(
                label: 'Nearby Landmarks',
                hint: 'Any nearby landmarks',
                onChanged: (value) {},
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                textEditingController: masjidNearbyLandmarksController,
              ),
              spacer,
              const MasjidImagePicker(),
              const SizedBox(height: 24),
              Text("Additional Details",
                  style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
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
                    children: ["2 minutes", "3 minutes", "5 minutes", "No delay"].map((label) {
                      return ChoiceChip(
                        label: Text(label, style: textTheme.bodyMedium),
                        selected: value == label,
                        selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                        onSelected: (_) => maghribDelay.value = label,
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text("Women Facilities",
                  style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              spacer,
              buildYesNoRadio("Prayer Area", womenPrayer, theme),
              buildYesNoRadio("Wuzu Area", wuzu, theme),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ValueListenableBuilder<bool>(
                  valueListenable: _isLoading,
                  builder: (context, loading, _) {
                    return RoundButton(
                      loading: loading,
                      onPress: () async {
                        if (_isLoading.value) return;
                        if (formKey.currentState!.validate()) {
                          if (jumma.value == null ||
                              eid.value == null ||
                              parking.value == null ||
                              maghribDelay.value == null ||
                              womenPrayer.value == null ||
                              wuzu.value == null) {
                            context.flushBarErrorMessage(message: "Missing Required Fields");
                          } else {
                            _isLoading.value = true;
                            final ok = await _updateMasjidDetailsApi(
                              id: widget.model.id ?? '',
                              masjidName: masjidNameController.text,
                              maslik: _selectedMaslik.value ?? "",
                              masjidAddressJson: masjidAddress,
                              masjidCity: masjidCityController.text,
                              masjidProvince: _selectedProvince.value ?? "",
                              masjidCountry: masjidCountryController.text,
                              masjidContactInfo: masjidContactInfoController.text,
                              masjidNearbyLandmarks: masjidNearbyLandmarksController.text,
                              jumma: jumma.value ?? false,
                              eid: eid.value ?? false,
                              parking: parking.value ?? false,
                              maghribDelayVal: maghribDelay.value ?? "No delay",
                              womenPrayerArea: womenPrayer.value ?? false,
                              womenWuzuArea: wuzu.value ?? false,
                            );
                            if (!mounted) return;
                            if (ok) {
                              context.flushBarSuccessMessage(message: "Masjid details updated");
                              // Navigator.of(context).pop(true);
                              _isLoading.value = false;
                            } else {
                              context.flushBarErrorMessage(message: "Update failed");
                              _isLoading.value = false;
                            }
                          }
                        }
                      },
                      title: 'Update',
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildYesNoRadio(String title, ValueNotifier<bool?> controller, ThemeData theme) {
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

Future<bool> _updateMasjidDetailsApi({
  required String id,
  required String masjidName,
  required String maslik,
  required Map<String, dynamic>? masjidAddressJson,
  required String masjidCity,
  required String masjidProvince,
  required String masjidCountry,
  required String masjidContactInfo,
  required String masjidNearbyLandmarks,
  required bool jumma,
  required bool eid,
  required bool parking,
  required String maghribDelayVal,
  required bool womenPrayerArea,
  required bool womenWuzuArea,
}) async {
  try {
    final List<Map<String, dynamic>> prayerTimings = [
      {"name": "Jumma", 'time': '01:00 PM', "isOffered": jumma},
    ];
    final Map<String, String> data = {
      "maslik": maslik,
      "masjidName": masjidName,
      "masjidAddress": jsonEncode(masjidAddressJson),
      "city": masjidCity,
      "province": masjidProvince,
      "country": masjidProvince,
      "contactInfo": masjidContactInfo,
      "nearbyLandmark": masjidNearbyLandmarks,
      "jumaPrayer": jumma == true ? "yes" : "no",
      "eidPrayer": eid == true ? "yes" : "no",
      "parkingFacility": parking == true ? "yes" : "no",
      "magribPrayerDelay": maghribDelayVal ?? "No delay",
      "womenFacility": womenPrayerArea == true ? "yes" : "no",
      "prayerArea": womenPrayerArea == true ? "yes" : "no",
      "wazuArea": womenWuzuArea == true ? "yes" : "no",
    };
    // final payload = {
    //   'prayerTimings': prayerTimings,
    // };
    if (kDebugMode) print("Response Payload: ${jsonEncode(data)}");
    final response = await http.put(
      Uri.parse(AppUrl.updateImamOwnMasjidEP),
      headers: {
        'Authorization': '${SessionController.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    final decodedData = jsonDecode(response.body);
    if (kDebugMode) print("Response body 111 : $decodedData");
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e, s) {
    if (kDebugMode) print("Error: $e\nStackTrace: $s");
    return false;
  }
}
