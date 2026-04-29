import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:namaz_bajamat/utils/app_url.dart';

import 'package:namaz_bajamat/utils/extensions/flush_bar_extension.dart';

import '../../../model/all_mosques_model.dart';
import 'package:http/http.dart' as http;

import '../../../services/session_controller/session_controller.dart';

class UpdateImamOwnMasjid extends StatefulWidget {
  const UpdateImamOwnMasjid({super.key, required this.model});

  final Masjids model;

  @override
  State<UpdateImamOwnMasjid> createState() => _UpdateImamOwnMasjidState();
}

class _UpdateImamOwnMasjidState extends State<UpdateImamOwnMasjid> {
  static const List<String> _order = <String>[
    'Fajr',
    'Zuhr',
    'Asr',
    'Maghrib',
    'Isha',
    'Jummah',
  ];

  late final Map<String, PrayerTimings?> _existing;
  late final Map<String, TimeOfDay?> _times;
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _existing = <String, PrayerTimings?>{
      for (final p in (widget.model.prayerTimings ?? <PrayerTimings>[]))
        (p.name ?? '').toLowerCase(): p,
    };

    _times = <String, TimeOfDay?>{
      for (final n in _order)
        n: _parseTimeOfDay(_existing[n.toLowerCase()]?.time),
    };
  }

  @override
  void dispose() {
    _isLoading.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (_isLoading.value) return;
    _isLoading.value = true;

    // Build plain strings for the API
    final String fajr =
        _formatTimeOfDay(_times['Fajr'] ?? const TimeOfDay(hour: 0, minute: 0));
    final String zuhr =
        _formatTimeOfDay(_times['Zuhr'] ?? const TimeOfDay(hour: 0, minute: 0));
    final String asr =
        _formatTimeOfDay(_times['Asr'] ?? const TimeOfDay(hour: 0, minute: 0));
    final String maghrib = _formatTimeOfDay(
        _times['Maghrib'] ?? const TimeOfDay(hour: 0, minute: 0));
    final String isha =
        _formatTimeOfDay(_times['Isha'] ?? const TimeOfDay(hour: 0, minute: 0));

    final bool jummaOffered = (_existing['jummah']?.isOffered ?? true);
    final String? jumma = jummaOffered && _times['Jummah'] != null
        ? _formatTimeOfDay(_times['Jummah']!)
        : null;

    try {
      final bool ok = await _updatePrayerTimingsApi(
        masjidId: widget.model.id!,
        fajr: fajr,
        zuhr: zuhr,
        asr: asr,
        maghrib: maghrib,
        isha: isha,
        jumma: jumma,
      );

      if (!mounted) return;
      if (ok) {
        final updated = _buildUpdatedForResult();
        context.flushBarSuccessMessage(message: 'Prayer timings updated');
        // Pop with the updated list (same as previous behavior)
        // Future.delayed(const Duration(milliseconds: 600)).then((_) {
        //   if (mounted) Navigator.of(context).pop(updated);
        // });
        _isLoading.value = false;
      } else {
        context.flushBarErrorMessage(message: 'Failed to update timings');
        _isLoading.value = false;
      }
    } catch (e) {
      if (!mounted) return;
      context.flushBarErrorMessage(message: 'Something went wrong');
      _isLoading.value = false;
    }
  }

  List<PrayerTimings> _buildUpdatedForResult() {
    final updated = <PrayerTimings>[];
    for (final name in _order) {
      final key = name.toLowerCase();
      final old = _existing[key];
      updated.add(
        PrayerTimings()
          ..name = name
          ..time = _formatTimeOfDay(
              _times[name] ?? const TimeOfDay(hour: 0, minute: 0))
          ..isOffered = old?.isOffered ?? true
          ..id = old?.id,
      );
    }
    return updated;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Prayer Timings'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _order.length,
              itemBuilder: (BuildContext context, int index) {
                final String name = _order[index];
                final bool enabled = name != 'Jummah'
                    ? true
                    : (_existing['jummah']?.isOffered ?? false);
                final TimeOfDay? time = _times[name];
                return _PrayerRow(
                  name: name,
                  time: time,
                  enabled: enabled,
                  onPickTime: () async {
                    if (_isLoading.value)
                      return; // prevent changes while saving
                    final TimeOfDay initial =
                        time ?? const TimeOfDay(hour: 5, minute: 0);
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: initial,
                      builder: (context, child) => MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: false),
                        child: child ?? const SizedBox.shrink(),
                      ),
                    );
                    if (picked != null) {
                      setState(() => _times[name] = picked);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: ValueListenableBuilder<bool>(
            valueListenable: _isLoading,
            builder: (BuildContext context, bool loading, Widget? _) {
              return SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: loading ? null : _onSave,
                  child: loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ====== Simulated API (replace with real implementation) ======
Future<bool> _updatePrayerTimingsApi({
  required String masjidId,
  required String fajr,
  required String zuhr,
  required String asr,
  required String maghrib,
  required String isha,
  String? jumma,
}) async {
  try {
    final List<Map<String, dynamic>> data = [
      {"name": "Fajr", 'time': fajr, "isOffered": true},
      {"name": "Zuhr", 'time': zuhr, "isOffered": true},
      {"name": "Asr", 'time': asr, "isOffered": true},
      {"name": "Maghrib", 'time': maghrib, "isOffered": true},
      {"name": "Isha", 'time': isha, "isOffered": true},
    ];
    if (jumma != null && jumma.trim().isNotEmpty) {
      data.add({"name": "Jummah", 'time': jumma, "isOffered": true});
    }
    final payload = {
      'prayerTimings': data,
    };
    if (kDebugMode) print("Response Payload: ${jsonEncode(payload)}");
    final response = await http.put(
      Uri.parse(AppUrl.updateImamOwnMasjidEP),
      headers: {
        'Authorization': '${SessionController.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );
    final decodedData = jsonDecode(response.body);
    if (kDebugMode) print("Response body: $decodedData");
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e, s) {
    if (kDebugMode) print("Error: $e\nStackTrace: $s");
    return false;
  }
}

// ====== ROW WIDGET (unchanged look) ======
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
          children: <Widget>[
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

// ====== TIME HELPERS ======
TimeOfDay? _parseTimeOfDay(String? input) {
  if (input == null) return null;
  final RegExp re = RegExp(r'^\s*(0?\d|1[0-2]):([0-5]\d)\s*([AaPp][Mm])\s*$');
  final RegExpMatch? m = re.firstMatch(input.trim());
  if (m == null) return null;
  var hour = int.parse(m.group(1)!);
  final int minute = int.parse(m.group(2)!);
  final String meridiem = m.group(3)!.toUpperCase();
  if (meridiem == 'PM' && hour != 12) hour += 12;
  if (meridiem == 'AM' && hour == 12) hour = 0;
  return TimeOfDay(hour: hour, minute: minute);
}

String _formatTimeOfDay(TimeOfDay t) {
  final int h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
  final String hh = h.toString().padLeft(2, '0');
  final String mm = t.minute.toString().padLeft(2, '0');
  final String period = t.period == DayPeriod.am ? 'AM' : 'PM';
  return '$hh:$mm $period';
}
