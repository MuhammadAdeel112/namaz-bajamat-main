import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final void Function(String) onChanged;
  final String? Function(String?) validator;
  final bool obscureText;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController textEditingController;
  final bool readOnly;
  final VoidCallback? onTap;
  final AutovalidateMode autovalidateMode;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.onChanged,
    required this.validator,
    this.obscureText = false,
    this.textInputType,
    this.inputFormatters,
    required this.textEditingController,
    this.readOnly = false,
    this.onTap,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          autovalidateMode: autovalidateMode,
          controller: textEditingController,
          textInputAction: TextInputAction.next,
          obscureText: obscureText,
          obscuringCharacter: "*",
          style: theme.textTheme.bodyLarge,
          keyboardType: textInputType,
          inputFormatters: inputFormatters,
          readOnly: readOnly,
          decoration: InputDecoration(
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
          onChanged: onChanged,
          validator: validator,
          onTap: onTap,
        ),
      ],
    );
  }
}
