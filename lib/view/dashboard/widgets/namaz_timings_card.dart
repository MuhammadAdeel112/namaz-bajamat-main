import 'package:flutter/material.dart';
import 'package:namaz_bajamat/config/routes/routes_name.dart';

import '../../../model/all_mosques_model.dart';
import '../../../services/session_controller/session_controller.dart';
import '../../shared_widgets/mosque_detail_dialog.dart';
import 'prayer_times_edit_button.dart';

class NamazTimingsCard extends StatelessWidget {
  const NamazTimingsCard({super.key, required this.selectedMasjid, required this.allMosques});
  final ValueNotifier<Masjids?> selectedMasjid;
  final AllMosquesModel allMosques;

  @override
  Widget build(BuildContext context) {

    selectedMasjid.value = allMosques.masjids?[0];
    final smPrayerTimings = selectedMasjid.value?.prayerTimings;
    final smFajrTime = smPrayerTimings?[0].time?.split(' ')[0];
    final smZuhrTime = smPrayerTimings?[1].time?.split(' ')[0];
    final smAsrTime = smPrayerTimings?[2].time?.split(' ')[0];
    final smMaghribTime = smPrayerTimings?[3].time?.split(' ')[0];
    final smIshaTime = smPrayerTimings?[4].time?.split(' ')[0];

    String? smJummaTime;
    if (selectedMasjid.value?.jummahPrayer == 'yes') {
      smJummaTime = smPrayerTimings?[5].time?.split(' ')[0];
    }

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Namaz Timings', style: textTheme.titleMedium),
              // Somewhere in your UI (e.g., AppBar actions or a section header)
              PrayerTimesEditButton(
                selectedMasjid: selectedMasjid,
                onSave: (updatedTimings, masjid) {
                  final newMasjid = Masjids(
                    masjidAddress: masjid.masjidAddress,
                    jummahPrayer: masjid.jummahPrayer,
                    id: masjid.id,
                    name: masjid.name,
                    maslik: masjid.maslik,
                    city: masjid.city,
                    province: masjid.province,
                    country: masjid.country,
                    contactInfo: masjid.contactInfo,
                    nearbyLandmark: masjid.nearbyLandmark,
                    masjidPic: masjid.masjidPic,
                    eidPrayer: masjid.eidPrayer,
                    parkingFacility: masjid.parkingFacility,
                    magribPrayerDelay: masjid.magribPrayerDelay,
                    womenFacility: masjid.womenFacility,
                    prayerArea: masjid.prayerArea,
                    wazuArea: masjid.wazuArea,
                    status: masjid.status,
                    role: masjid.role,
                    prayerTimings: updatedTimings,
                    createdAt: masjid.createdAt,
                    updatedAt: masjid.updatedAt,
                    v: masjid.v,
                    distance: masjid.distance,
                  );
                  selectedMasjid.value = newMasjid;
                },
              ),
              // TextButton(onPressed: () {}, child: const Text("Update Time")),
            ],
          ),
        ),
        ValueListenableBuilder<Masjids?>(
            valueListenable: selectedMasjid,
            builder: (context, value, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () {
                    if(selectedMasjid.value != null){
                      onMasjidInfoTap(selectedMasjid.value!,context);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Header Row with Dropdown
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: colorScheme.primary,
                                // border: Border.all(color: ),
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(
                              // 'Abbottabad Mandian',
                              selectedMasjid.value?.masjidAddress?.address ??
                                  "Unknown Mosque",
                              style: textTheme.titleMedium
                                  ?.copyWith(color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            // 'Masjid Umar Mosque',
                            selectedMasjid.value?.name ?? "Unknown Mosque",
                            style: textTheme.titleMedium
                                ?.copyWith(color: Colors.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Center(
                          child: Text(
                            SessionController.hijriDate ?? '',
                            style: textTheme.bodySmall
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 12),

                        /// Namaz Timings Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildNamazCard('Fajr', smFajrTime ?? "00:00",
                                Icons.wb_twilight, theme),
                            selectedMasjid.value?.jummahPrayer == 'yes' &&
                                SessionController.day == 'Friday'
                                ? _buildNamazCard('Jumma', smJummaTime ?? "00:00",
                                Icons.sunny, theme)
                                : _buildNamazCard('Zuhr', smZuhrTime ?? "00:00",
                                Icons.sunny, theme),
                            _buildNamazCard('Asar', smAsrTime ?? "00:00",
                                Icons.sunny_snowing, theme),
                            _buildNamazCard('Maghrib', smMaghribTime ?? "00:00",
                                Icons.nightlight, theme),
                            _buildNamazCard('Isha', smIshaTime ?? "00:00",
                                Icons.bedtime, theme),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ],
    );
  }

  Widget _buildNamazCard(
      String name, String time, IconData icon, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
      decoration: BoxDecoration(
        // color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: theme.primaryColor),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(color: Colors.white)),
          Text(time,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.white)),
          // Text(time,
          //     style: const TextStyle(fontSize: 10,
          //         fontWeight: FontWeight.w600, color: Colors.white)),
        ],
      ),
    );
  }
}
