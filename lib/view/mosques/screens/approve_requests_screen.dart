import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:namaz_bajamat/utils/app_url.dart';

import '../../../model/approve_request_response_model.dart';
import '../../../services/session_controller/session_controller.dart';

class ApproveRequestsPage extends StatefulWidget {
  const ApproveRequestsPage({super.key});

  @override
  State<ApproveRequestsPage> createState() => _ApproveRequestsPageState();
}

enum _ViewState { loading, error, empty, data }

class _ApproveRequestsPageState extends State<ApproveRequestsPage> {
  _ViewState _state = _ViewState.loading;
  String _errorMessage = 'Something went wrong.';
  List<Requests> _requests = const [];

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    setState(() {
      _state = _ViewState.loading;
      _errorMessage = 'Something went wrong.';
      _requests = const [];
    });

    try {
      final uri = Uri.parse(AppUrl.getUpdateRequestsEP);
      final res = await http.get(
        uri,
        headers: {
          'Authorization': '${SessionController.token}',
          'Content-Type': 'application/json',
        },
      );

      if (kDebugMode) print("Status  ${res.statusCode}");
      if (kDebugMode) print("Response  ${res.body}");
      if (res.statusCode != 200) {
        setState(() {
          _state = _ViewState.error;
          _errorMessage = 'Failed to fetch requests (${res.statusCode}).';
        });
        return;
      }

      final dynamic decoded = jsonDecode(res.body);

      // If 'requests' missing or empty => DO NOT PARSE, show empty state
      final dynamic rawList =
          (decoded is Map<String, dynamic>) ? decoded['requests'] : null;
      if (rawList is! List || rawList.isEmpty) {
        setState(() {
          _state = _ViewState.empty;
        });
        return;
      }

      // Safe to parse model now
      final model = ApproveRequestResponseModel.fromJson(decoded);
      final list = model.requests ?? <Requests>[];

      if (list.isEmpty) {
        setState(() {
          _state = _ViewState.empty;
        });
        return;
      }

      setState(() {
        _requests = list;
        _state = _ViewState.data;
      });
    } catch (e,s) {
      if(kDebugMode) print("Error: $e\nStakcs $s");
      setState(() {
        _state = _ViewState.error;
        _errorMessage = 'Could not load requests.';
      });
    }
  }

  Future<bool> _approveReject(String id, String action) async {
    try {
      final uri = Uri.parse(AppUrl.approveRequests(id));
      final res = await http.put(
        uri, headers: {
        'Authorization': '${SessionController.token}',
        'Content-Type': 'application/json',
      },
        body: jsonEncode({'action': action}),
      );
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<void> _handleApprove(Requests r) async {
    final ok = await _approveReject(r.id ?? '', 'approve');
    _showSnack(ok ? 'Request approved' : 'Failed to approve');
    if (ok) _fetchRequests(); // refresh list
  }

  Future<void> _handleReject(Requests r) async {
    final ok = await _approveReject(r.id ?? '', 'reject');
    _showSnack(ok ? 'Request rejected' : 'Failed to reject');
    if (ok) _fetchRequests(); // refresh list
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case _ViewState.loading:
        return const Scaffold(
          appBar: _AppTopBar(),
          body: Center(child: CircularProgressIndicator()),
        );

      case _ViewState.error:
        return Scaffold(
          appBar: const _AppTopBar(),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        );

      case _ViewState.empty:
        return Scaffold(
          appBar: const _AppTopBar(),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'No requests available.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        );

      case _ViewState.data:
        return Scaffold(
          appBar: const _AppTopBar(),
          body: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: _requests.length,
            itemBuilder: (_, i) => _RequestCard(
              request: _requests[i],
              onApprove: () => _confirm(
                title: 'Approve this request?',
                message: 'This change will be applied.',
                proceedText: 'Approve',
                proceedColor: Colors.white,
                onProceed: () => _handleApprove(_requests[i]),
              ),
              onReject: () => _confirm(
                title: 'Reject this request?',
                message: 'This change will be declined.',
                proceedText: 'Reject',
                proceedColor: Colors.red,
                onProceed: () => _handleReject(_requests[i]),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _fetchRequests,
            child: const Icon(Icons.refresh),
          ),
        );
    }
  }

  Future<void> _confirm({
    required String title,
    required String message,
    required String proceedText,
    required Color proceedColor,
    required VoidCallback onProceed,
  }) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title,style: const TextStyle(color: Colors.black),),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: proceedText == 'Approve'
                  ? Theme.of(ctx).colorScheme.primary
                  : Colors.red,
              foregroundColor: proceedColor,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(proceedText,style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
    if (ok == true) onProceed();
  }
}

// ---------- UI bits ----------

class _AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppTopBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Approval Requests'),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.request,
    required this.onApprove,
    required this.onReject,
  });

  final Requests request;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final created = _fmtDate(request.createdAt);
    final updated = _fmtDate(request.updatedAt);
    final status = (request.status ?? 'pending').toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Color(0x14000000), blurRadius: 14, offset: Offset(0, 8))
        ],
        border: Border.all(color: const Color(0x11000000)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            decoration: const BoxDecoration(
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(16)),
              gradient: LinearGradient(
                colors: [Color(0xFF0C8C7A), Color(0xFF065F55)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.mosque_rounded, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    request.masjidId ?? 'Masjid',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _Chip(status),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _KV(
                    icon: Icons.person_outline,
                    k: 'Requested By',
                    v: request.requestedBy?.name ??
                        request.requestedBy?.email ??
                        'Unknown'),
                const SizedBox(height: 6),
                _KV(
                    icon: Icons.schedule_outlined,
                    k: 'Submitted',
                    v: created ?? '—'),
                const SizedBox(height: 6),
                _KV(icon: Icons.update, k: 'Last Update', v: updated ?? '—'),
                const SizedBox(height: 12),
                Text('Requested Changes',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                _TimingsPreview(
                    list: request.updatedFields?.prayerTimings ?? const []),
              ],
            ),
          ),

          // Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onReject,
                    icon: const Icon(Icons.close_rounded),
                    label: const Text('Reject'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onApprove,
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('Approve'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0C8C7A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final isApproved = text.toLowerCase() == 'approved';
    final isRejected = text.toLowerCase() == 'rejected';
    final bg = isApproved
        ? const Color(0x1A0E9F6E)
        : isRejected
            ? const Color(0x1AFF4E50)
            : const Color(0x1A246BFD);
    final fg = isApproved
        ? const Color(0xFF0E9F6E)
        : isRejected
            ? const Color(0xFFFF4E50)
            : const Color(0xFF246BFD);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(text,
          style:
              TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 12)),
    );
  }
}

class _KV extends StatelessWidget {
  const _KV({required this.icon, required this.k, required this.v});

  final IconData icon;
  final String k;
  final String v;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon,
            size: 18,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.9)),
        const SizedBox(width: 8),
        Text('$k: ',
            style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        Expanded(
            child: Text(v,
                style: t.bodyMedium,
                overflow: TextOverflow.ellipsis,
                maxLines: 2)),
      ],
    );
  }
}

class _TimingsPreview extends StatelessWidget {
  const _TimingsPreview({required this.list});

  /// Expecting: List<PrayerTimingEntry>
  final List<PrayerTimingEntry> list;

  static const _order = ['fajr', 'zuhr', 'asr', 'maghrib', 'isha', 'jummah'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final deco = BoxDecoration(
      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: theme.dividerColor.withOpacity(0.15)),
    );

    if (list.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: deco,
        child: Text(
          'No prayer timings included in this request.',
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    // Build an ordered list regardless of incoming order/duplicates.
    final map = <String, PrayerTimingEntry>{};
    for (final e in list) {
      final key = e.name.toLowerCase().trim() == 'jumma' ? 'jummah' : e.name.toLowerCase().trim();
      map[key] = PrayerTimingEntry(name: key, time: e.time); // last one wins if duplicates
    }
    final ordered = <PrayerTimingEntry>[
      for (final n in _order)
        if (map[n] != null) map[n]!,
    ];

    return Container(
      decoration: deco,
      child: Column(
        children: List.generate(ordered.length, (i) {
          final e = ordered[i];
          final isLast = i == ordered.length - 1;
          final title = _displayName(e.name);

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : Border(
                bottom: BorderSide(
                  color: theme.dividerColor.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 18),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text(
                  e.time.isNotEmpty ? e.time : '—',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    // tabular figures keep times aligned
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  String _displayName(String raw) {
    final n = raw.toLowerCase().trim();
    if (n == 'jumma' || n == 'jummah') return 'Jummah';
    return n.isEmpty ? '' : n[0].toUpperCase() + n.substring(1);
  }
}

String? _fmtDate(String? iso) {
  if (iso == null || iso.trim().isEmpty) return null;
  try {
    final dt = DateTime.parse(iso).toLocal();
    final wd =
        ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][dt.weekday - 1];
    final mo = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ][dt.month - 1];
    final hr = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$wd, ${dt.day} $mo ${dt.year} • $hr:$mm $ampm';
  } catch (_) {
    return iso;
  }
}
