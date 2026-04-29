import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final ValueNotifier<String?> selectedValue;
  final List<String> values;
  final String label;
  final String? hint;
  final InputDecoration? decoration;

  const CustomDropdown({super.key, required this.selectedValue, required this.values, this.label = "Select", this.hint, this.decoration});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ValueListenableBuilder<String?>(
      valueListenable: selectedValue,
      builder: (context, value, child) {
        return DropdownButtonFormField<String>(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          value: value,
          dropdownColor: Colors.white,
          menuMaxHeight: 300,
          decoration: decoration ?? InputDecoration(
            labelText: label,
            hintText: hint,
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
          items: values.map((province) {
            return DropdownMenuItem<String>(
              value: province,
              child: Text(province),
            );
          }).toList(),
          onChanged: (newValue) {
            selectedValue.value = newValue;
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
