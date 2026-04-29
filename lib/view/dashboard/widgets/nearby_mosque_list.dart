import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../model/all_mosques_model.dart';

class NearbyMosqueList extends StatelessWidget {
  const NearbyMosqueList({super.key, required this.selectedMasjid, required this.allMosques});
  final ValueNotifier<Masjids?> selectedMasjid;
  final AllMosquesModel allMosques;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: allMosques.masjids?.length ?? 0,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                selectedMasjid.value = allMosques.masjids![index];
                if (kDebugMode) print(selectedMasjid.value?.name);
              },
              child: _buildMosqueCard(context, allMosques.masjids![index]));
        },
      ),
    );
  }
  Widget _buildMosqueCard(BuildContext context, Masjids masjid) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
                child: Image.asset(
                  'assets/images/mosque_header.png',
                  height: 80,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    // "Ahl-Hadees",
                    masjid.maslik ?? "Unknown",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                top: 30,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    // "2.1 km",
                    "${masjid.distance.toString().substring(0, 5)} Km",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // 'Masjid Umar Mosque',
                  masjid.name ?? "Unknown",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  // 'Tullamulla, Kashmir',
                  masjid.masjidAddress?.address ?? "",
                  style: const TextStyle(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
