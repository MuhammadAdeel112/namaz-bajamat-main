import 'package:flutter/material.dart';

class ProvinceDropdown extends StatelessWidget {
  final ValueNotifier<String?> selectedProvince;

  ProvinceDropdown({super.key, required this.selectedProvince});

  final List<String> provinces = [
    "Punjab",
    "Sindh",
    "Khyber Pakhtunkhwa",
    "Balochistan",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ValueListenableBuilder<String?>(
      valueListenable: selectedProvince,
      builder: (context, value, child) {
        return DropdownButtonFormField<String>(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          value: value,
          dropdownColor: Colors.white,
          menuMaxHeight: 300,
          decoration: InputDecoration(
            labelText: "Province",
            labelStyle: theme.textTheme.titleSmall,
            hintStyle: theme.textTheme.bodySmall,
            floatingLabelStyle: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.colorScheme.primary),
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            isDense: true,
          ),
          items: provinces.map((province) {
            return DropdownMenuItem<String>(
              value: province,
              child: Text(province),
            );
          }).toList(),
          onChanged: (newValue) {
            selectedProvince.value = newValue;
          },
          validator: (selected) {
            if (selected == null || selected.isEmpty) {
              return "Required";
            }
            return null; // valid
          },
        );
      },
    );
  }
}
