import 'package:flutter/material.dart';

class SmallDropdown extends StatelessWidget {
  final ValueNotifier<String?> selectedValue;
  final List<String> values;
  final String label;
  final String? hint;
  final InputDecoration? decoration;
  final Widget? trailingIcon;
  final Widget? leadingIcon;
  final Function(String?)? onChanged;

  const SmallDropdown({
    super.key,
    required this.selectedValue,
    required this.values,
    this.label = "Select",
    this.hint,
    this.decoration,
    this.leadingIcon,
    this.trailingIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (leadingIcon != null) leadingIcon!,
        ValueListenableBuilder<String?>(
          valueListenable: selectedValue,
          builder: (context, value, child) {
            return DropdownButton<String>(
              value: value,
              hint: hint != null
                  ? Text(
                      hint!,
                      style: theme.textTheme.titleMedium,
                    )
                  : null,
              underline: const SizedBox.shrink(),
              dropdownColor: Colors.white,
              menuMaxHeight: 300,
              borderRadius: BorderRadius.circular(10),
              icon: trailingIcon,
              items: values.map((province) {
                return DropdownMenuItem<String>(
                  value: province,
                  child: Text(province),
                );
              }).toList(),
              onChanged: (newValue) {
                selectedValue.value = newValue;
                if (onChanged != null) onChanged!(newValue);
              },
            );
          },
        ),
      ],
    );
  }
}
