import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:namaz_bajamat/bloc/mosques/mosques_bloc.dart';
import 'package:namaz_bajamat/model/all_mosques_model.dart';
import 'package:namaz_bajamat/services/session_controller/session_controller.dart';
import 'package:namaz_bajamat/view/dashboard/widgets/nearby_mosques_filter.dart';
import 'package:namaz_bajamat/view/shared_widgets/custom_bottom_nav_bar.dart';
import 'package:namaz_bajamat/view/shared_widgets/small_drop_down.dart';

import '../shared_widgets/custom_drawer.dart';
import 'widgets/namaz_timings_card.dart';
import 'widgets/nearby_mosque_list.dart';
import 'widgets/top_image_container.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("dashboard screen is calling fetch function");
    context.read<MosquesBloc>().add(
          FetchMosques(),
        );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final ValueNotifier<String?> _selectedFilter = ValueNotifier<String?>(null);
  final ValueNotifier<Masjids?> _selectedMasjid = ValueNotifier<Masjids?>(null);

  @override
  void dispose() {
    _selectedFilter.dispose();
    _selectedMasjid.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) print("Token : ${SessionController.token}");

    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      bottomNavigationBar: CustomBottomNavBar(scaffoldKey: _scaffoldKey),
      body: BlocBuilder<MosquesBloc, MosquesState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (msg) => Center(child: Text('Error: $msg')),
            success: (allMosques) =>
                _bodyContent(context, allMosques ?? AllMosquesModel()),
            orElse: () => const Center(child: Text('orElse')),
          );
        },
      ),
    );
  }

  Widget _bodyContent(BuildContext context, AllMosquesModel allMosques) {
    if (allMosques.count == 0 && allMosques.masjids!.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const TopImageContainer(),
          const SizedBox(height: 10),
          NearbyMosquesFilter(selectedFilter: _selectedFilter),
          const Expanded(
            child: Center(
              child: Text(
                  "No Mosque available near by\nChange Filter to a wider range"),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        const TopImageContainer(),
        const SizedBox(height: 10),
        NamazTimingsCard(
          selectedMasjid: _selectedMasjid,
          allMosques: allMosques,
        ),
        const SizedBox(height: 10),
        NearbyMosquesFilter(selectedFilter: _selectedFilter),
        NearbyMosqueList(
          selectedMasjid: _selectedMasjid,
          allMosques: allMosques,
        ),
      ],
    );
  }
}
