import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/mosques/mosques_bloc.dart';
import '../../shared_widgets/small_drop_down.dart';

class NearbyMosquesFilter extends StatelessWidget {

  const NearbyMosquesFilter({super.key, required this.selectedFilter});

  final ValueNotifier<String?> selectedFilter;

  static const List<String> values = [
    '1 Km',
    '2 Km',
    '5 Km',
    '10 Km',
    'All',
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Near By Mosque', style: textTheme.titleMedium),
          SmallDropdown(
            selectedValue: selectedFilter,
            values: values,
            hint: "Filter",
            leadingIcon:
            const Icon(Icons.tune, color: Color(0xFF4A9CFF), size: 20),
            onChanged: (val) {
              if (val == null) return;

              selectedFilter.value = val;

              int? km;
              if (val.toLowerCase() != 'all') {
                km = int.tryParse(val.split(' ').first) ?? 5;
              }

              context.read<MosquesBloc>().add(
                FetchMosques(filterInKm: km),
              );
            },
          ),
        ],
      ),
    );
  }
}
