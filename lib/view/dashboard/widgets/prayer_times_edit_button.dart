import 'package:flutter/material.dart';
import 'package:namaz_bajamat/utils/extensions/flush_bar_extension.dart';

import '../../../config/routes/routes_name.dart';
import '../../../cubit/update_mosque_timings/update_mosque_timings_cubit.dart';
import '../../../model/all_mosques_model.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/session_controller/session_controller.dart';

// ====== POPUP (wired to cubit) ======
Future<List<PrayerTimings>?> showEditPrayerTimesDialog(
  BuildContext context, {
  required Masjids model,
}) {
  const List<String> order = [
    'Fajr',
    'Zuhr',
    'Asr',
    'Maghrib',
    'Isha',
    'Jummah'
  ];

  final existing = {
    for (final p in (model.prayerTimings ?? <PrayerTimings>[]))
      (p.name ?? '').toLowerCase(): p
  };

  final Map<String, TimeOfDay?> times = {
    for (final n in order) n: _parseTimeOfDay(existing[n.toLowerCase()]?.time)
  };

  return showDialog<List<PrayerTimings>>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      // If the cubit isn't provided above in the tree, you can wrap just this dialog:
      // return BlocProvider.value(
      //   value: context.read<UpdateMosqueTimingsCubit>(),
      //   child: _EditDialogBody(...),
      // );

      return _EditDialogBody(
        model: model,
        existing: existing,
        times: times,
        order: order,
      );
    },
  );
}

class _EditDialogBody extends StatelessWidget {
  const _EditDialogBody({
    required this.model,
    required this.existing,
    required this.times,
    required this.order,
  });

  final Masjids model;
  final Map<String, PrayerTimings?> existing;
  final Map<String, TimeOfDay?> times;
  final List<String> order;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateMosqueTimingsCubit, UpdateMosqueTimingsState>(
      listenWhen: (p, c) => p != c,
      listener: (ctx, state) {
        state.maybeWhen(
          success: (msg) {
            // Build the same updated list you used to return previously
            final updated = <PrayerTimings>[];
            for (final name in order) {
              final key = name.toLowerCase();
              final old = existing[key];
              updated.add(
                PrayerTimings()
                  ..name = name
                  ..time = _formatTimeOfDay(
                      times[name] ?? const TimeOfDay(hour: 0, minute: 0))
                  ..isOffered = old?.isOffered ?? true
                  ..id = old?.id,
              );
            }
            context.flushBarSuccessMessage(message: msg);

            Future.delayed(const Duration(seconds: 2)).then((onValue) {
              Navigator.of(ctx).pop(updated);
              Navigator.of(ctx).pop(updated);
            });
          },
          orElse: () {},
        );
      },
      builder: (ctx, state) {
        final isLoading =
            state.maybeWhen(loading: () => true, orElse: () => false);
        final failureMsg =
            state.maybeWhen(failure: (m) => m, orElse: () => null);

        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: Text('Edit Prayer Timings',
                  style: Theme.of(ctx).textTheme.titleLarge),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (failureMsg != null) ...[
                      Text(failureMsg,
                          style: TextStyle(
                              color: Theme.of(ctx).colorScheme.error)),
                      const SizedBox(height: 8),
                    ],
                    for (final name in order)
                      _PrayerRow(
                        name: name,
                        time: times[name],
                        enabled: name != 'Jummah'
                            ? true
                            : (existing['jummah']?.isOffered ?? true),
                        onPickTime: () async {
                          final initial = times[name] ??
                              const TimeOfDay(hour: 5, minute: 0);
                          final picked = await showTimePicker(
                            context: ctx,
                            initialTime: initial,
                            builder: (context, child) => MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(alwaysUse24HourFormat: false),
                              child: child ?? const SizedBox.shrink(),
                            ),
                          );
                          if (picked != null)
                            setState(() => times[name] = picked);
                        },
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed:
                      isLoading ? null : () => Navigator.of(ctx).pop(null),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          // Build plain strings for the update cubit
                          final fajr = _formatTimeOfDay(times['Fajr'] ??
                              const TimeOfDay(hour: 0, minute: 0));
                          final zuhr = _formatTimeOfDay(times['Zuhr'] ??
                              const TimeOfDay(hour: 0, minute: 0));
                          final asr = _formatTimeOfDay(times['Asr'] ??
                              const TimeOfDay(hour: 0, minute: 0));
                          final maghrib = _formatTimeOfDay(times['Maghrib'] ??
                              const TimeOfDay(hour: 0, minute: 0));
                          final isha = _formatTimeOfDay(times['Isha'] ??
                              const TimeOfDay(hour: 0, minute: 0));
                          final jummaOffered =
                              (existing['jummah']?.isOffered ?? true);
                          final String? jumma =
                              jummaOffered && times['Jummah'] != null
                                  ? _formatTimeOfDay(times['Jummah']!)
                                  : null;

                          ctx.read<UpdateMosqueTimingsCubit>().update(
                                masjidId: model.id!,
                                fajr: fajr,
                                zuhr: zuhr,
                                asr: asr,
                                maghrib: maghrib,
                                isha: isha,
                                jumma: jumma, // null if not offered or unset
                              );
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// ====== TRIGGER WIDGET (unchanged API) ======
class PrayerTimesEditButton extends StatelessWidget {
  const PrayerTimesEditButton({
    super.key,
    required this.selectedMasjid,
    this.onSave,
    this.buttonChild,
  });

  final ValueNotifier<Masjids?> selectedMasjid;
  final void Function(List<PrayerTimings> updated, Masjids masjid)? onSave;
  final Widget? buttonChild;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Masjids?>(
      valueListenable: selectedMasjid,
      builder: (context, masjid, _) {
        final enabled = masjid != null;
        return FilledButton.icon(
          onPressed: !enabled
              ? null
              : () async {
                  if (SessionController.isLogin ?? false) {
                    final result = await showEditPrayerTimesDialog(
                      context,
                      model: masjid,
                    );
                    if (result != null) onSave?.call(result, masjid);
                  } else {
                    Navigator.pushNamed(context, RoutesName.login);
                  }
                },
          icon: const Icon(Icons.schedule),
          label: buttonChild ?? const Text('Update Time'),
        );
      },
    );
  }
}

// ====== ROW WIDGET (no toggles) ======
class _PrayerRow extends StatelessWidget {
  const _PrayerRow({
    required this.name,
    required this.time,
    required this.onPickTime,
    this.enabled = true,
  });

  final String name;
  final TimeOfDay? time;
  final VoidCallback onPickTime;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(name, style: Theme.of(context).textTheme.titleMedium),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: enabled ? onPickTime : null,
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Text(
                  time != null ? _formatTimeOfDay(time!) : 'Set time',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====== TIME HELPERS (unchanged) ======
TimeOfDay? _parseTimeOfDay(String? input) {
  if (input == null) return null;
  final re = RegExp(r'^\s*(0?\d|1[0-2]):([0-5]\d)\s*([AaPp][Mm])\s*$');
  final m = re.firstMatch(input.trim());
  if (m == null) return null;
  var hour = int.parse(m.group(1)!);
  final minute = int.parse(m.group(2)!);
  final meridiem = m.group(3)!.toUpperCase();
  if (meridiem == 'PM' && hour != 12) hour += 12;
  if (meridiem == 'AM' && hour == 12) hour = 0;
  return TimeOfDay(hour: hour, minute: minute);
}

String _formatTimeOfDay(TimeOfDay t) {
  final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
  final hh = h.toString().padLeft(2, '0');
  final mm = t.minute.toString().padLeft(2, '0');
  final period = t.period == DayPeriod.am ? 'AM' : 'PM';
  return '$hh:$mm $period';
}
