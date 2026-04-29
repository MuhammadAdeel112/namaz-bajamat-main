import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/address_field_cubit/address_field_cubit.dart';

class AddressField extends StatelessWidget {
  final bool showLabel;
  final InputDecoration? inputDecoration;
  final GlobalKey<FormFieldState>? formKey;

  const AddressField({
    super.key,
    this.showLabel = false,
    this.inputDecoration,
    this.formKey,
  });

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return BlocBuilder<AddressFieldCubit, AddressFieldState>(
      builder: (context, state) {
        final cubit = context.read<AddressFieldCubit>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              key: formKey,
              controller: cubit.addressController,
              onChanged: cubit.getSuggestions,
              decoration: inputDecoration ??
              InputDecoration(
                label: showLabel ? const Text("Address") : const SizedBox.shrink(),
                hintText: 'Enter Address',
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
              validator: (value){
                if(value == null || value.isEmpty){
                  return "Required";
                }
                return null;
              },
            ),

            Visibility(
              visible: state.suggestions.isNotEmpty,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.suggestions.length,
                  itemBuilder: (context, index) {
                    final pred = state.suggestions[index];
                    final title = pred.fullText ?? pred.primaryText;
                    return ListTile(
                      title: Text(title),
                      onTap: () => cubit.getPlaceDetails(pred.placeId),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
