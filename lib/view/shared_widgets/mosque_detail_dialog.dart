import 'package:flutter/material.dart';

import '../../model/all_mosques_model.dart';

void onMasjidInfoTap(Masjids m, BuildContext context) {
  showDialog(
    context: context,
    builder: (_) {
      final timings = _orderedTimings(m.prayerTimings);

      return AlertDialog(
        title: Text(m.name ?? 'Masjid', style: Theme.of(context).textTheme.titleLarge),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ---- Prayer Timings (first) ----
              Text('Prayer Timings', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              if (timings.isEmpty)
                Text('No timings provided', style: Theme.of(context).textTheme.bodyMedium)
              else
                ...timings.map((t) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(t.name ?? '-', style: Theme.of(context).textTheme.bodyLarge),
                      Text(t.time ?? '-', style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                )),
              const SizedBox(height: 12),
              const Divider(height: 24),

              // ---- Other details ----
              if ((m.masjidAddress?.address ?? '').trim().isNotEmpty)
                _detailRow(Icons.place, 'Address', m.masjidAddress!.address!),
              if ((m.maslik ?? '').trim().isNotEmpty)
                _detailRow(Icons.account_tree, 'Maslik', m.maslik!),
              if ([m.city, m.province, m.country].any((e) => (e ?? '').trim().isNotEmpty))
                _detailRow(
                  Icons.public,
                  'Location',
                  [
                    m.city,
                    m.province,
                    m.country,
                  ].where((e) => (e ?? '').trim().isNotEmpty).join(', '),
                ),
              if ((m.nearbyLandmark ?? '').trim().isNotEmpty)
                _detailRow(Icons.landscape, 'Nearby Landmark', m.nearbyLandmark!),
              if ((m.contactInfo ?? '').trim().isNotEmpty)
                _detailRow(Icons.phone, 'Contact', m.contactInfo!),
              if ((m.magribPrayerDelay ?? '').trim().isNotEmpty)
                _detailRow(Icons.schedule, 'Maghrib Prayer Delay', "${m.magribPrayerDelay!} min"),
              if (m.distance != null)
                _detailRow(Icons.directions_walk, 'Distance', '${m.distance?.toStringAsFixed(1)} km'),
              if ((m.parkingFacility ?? '').trim().isNotEmpty)
                _detailRow(Icons.local_parking, 'Parking', m.parkingFacility!),
              if ((m.prayerArea ?? '').trim().isNotEmpty)
                _detailRow(Icons.chair, 'Women Prayer Area', m.prayerArea!),
              if ((m.wazuArea ?? '').trim().isNotEmpty)
                _detailRow(Icons.water_drop, 'Women Wuzu Area', m.wazuArea!),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      );
    },
  );
}

/// Order timings as Fajr, Zuhr, Asr, Maghrib, Isha, Jummah (case-insensitive),
/// and skip ones explicitly marked as not offered.
List<PrayerTimings> _orderedTimings(List<PrayerTimings>? list) {
  if (list == null) return [];
  const order = ['fajr', 'zuhr', 'asr', 'maghrib', 'isha', 'jummah'];
  final map = {
    for (final p in list)
      (p.name ?? '').toLowerCase(): p
  };
  final out = <PrayerTimings>[];
  for (final key in order) {
    final p = map[key];
    if (p == null) continue;
    if (p.isOffered == false) continue;
    out.add(p);
  }
  // Append any extras not in the known order
  for (final p in list) {
    final k = (p.name ?? '').toLowerCase();
    if (!order.contains(k) && p.isOffered != false) out.add(p);
  }
  return out;
}

Widget _detailRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black87),
              children: [
                TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}