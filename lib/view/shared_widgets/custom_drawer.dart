import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:namaz_bajamat/repository/mosques_api/mosques_api.dart';
import 'package:namaz_bajamat/services/session_controller/session_controller.dart';
import 'package:namaz_bajamat/utils/app_url.dart';
import 'package:namaz_bajamat/utils/extensions/flush_bar_extension.dart';
import 'package:namaz_bajamat/view/mosques/screens/update_masjid_details_screen.dart';

import '../../config/routes/routes_name.dart';
import '../../utils/enums.dart';
import '../dashboard/widgets/prayer_times_edit_button.dart';
import '../../../model/all_mosques_model.dart';
import 'package:http/http.dart' as http;

import '../mosques/screens/approve_requests_screen.dart';
import '../mosques/screens/update_imam_own_masjid.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final role = SessionController.role ?? Role.visitor;
  final imam = SessionController.imam;
  final visitor = SessionController.visitor;
  String name = '';
  String? phone = '';
  String? image;

  @override
  Widget build(BuildContext context) {
    if (role == Role.imam) {
      name = imam?.name ?? "";
      image = imam?.imamPic;
      phone = imam?.phoneNo;
    } else {
      name = visitor?.name ?? "Guest";
      phone = visitor?.phone;
    }

    final theme = Theme.of(context);
    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.6,
      backgroundColor: Colors.white,
      child: Column(
        children: [
          //profile pic
          DrawerHeader(
            // margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey.shade300,
                  foregroundImage:
                      (image != null) ? NetworkImage(image!) : null,
                  child: const Icon(
                    Icons.person,
                    size: 50,
                  ),
                ),
                Text(
                  name,
                  style: theme.textTheme.bodyLarge,
                ),
                phone != null
                    ? Text(
                        phone ?? "",
                        style: theme.textTheme.bodyLarge,
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),

          // update profile
          SessionController.isLogin ?? false
              ? drawerItem(
                  context: context,
                  title: "Update Profile",
                  leading: const Icon(Icons.person),
                  onTap: () async {
                    if (role == Role.visitor) {
                      Navigator.pushNamed(
                          context, RoutesName.updateVisitorProfile);
                    } else if (role == Role.imam) {
                      Navigator.pushNamed(
                          context, RoutesName.updateImamProfile);
                    }
                  },
                )
              : const SizedBox.shrink(),

          // requests
          role == Role.imam
              ? drawerItem(
                  context: context,
                  title: "Requests",
                  leading: const Icon(Icons.add_box),
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ApproveRequestsPage()));
                  },
                )
              : const SizedBox.shrink(),

          // update mosques details
          role == Role.imam
              ? drawerItem(
                  context: context,
                  title: "Update Prayer Timings",
                  leading: const Icon(Icons.add_box),
                  onTap: () async {
                    try {
                      final response = await http
                          .get(Uri.parse(AppUrl.getImamOwnMasjidEP), headers: {
                        'Authorization': '${SessionController.token}',
                        'Content-Type': 'application/json',
                      });
                      final decodedData = jsonDecode(response.body);
                      if (kDebugMode) print("DecodedResponse: $decodedData");
                      if (response.statusCode == 200) {
                        final model = Masjids.fromJson(decodedData['masjid']);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateImamOwnMasjid(
                                      model: model,
                                    )));

                        // showEditPrayerTimesDialog(context, model: model);
                      } else {
                        context.flushBarErrorMessage(
                            message:
                                "An Unknown Error Occurred\nPlease try again later");
                      }
                    } catch (e, s) {
                      if (kDebugMode) print("Error: $e\nStackTrace: $s");
                      context.flushBarErrorMessage(
                          message: "An Error Occurred\n$e");
                    }
                  },
                )
              : const SizedBox.shrink(),

          // update mosques details
          role == Role.imam
              ? drawerItem(
                  context: context,
                  title: "Update Mosque Details",
                  leading: const Icon(Icons.add_box),
                  onTap: () async {
                    try {
                      final response = await http
                          .get(Uri.parse(AppUrl.getImamOwnMasjidEP), headers: {
                        'Authorization': '${SessionController.token}',
                        'Content-Type': 'application/json',
                      });
                      final decodedData = jsonDecode(response.body);
                      if (response.statusCode == 200) {
                        final model = Masjids.fromJson(decodedData['masjid']);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateMasjidDetailsScreen(
                                      model: model,
                                    )));

                        // showEditPrayerTimesDialog(context, model: model);
                      } else {
                        context.flushBarErrorMessage(
                            message:
                                "An Unknown Error Occurred\nPlease try again later");
                      }
                    } catch (e, s) {
                      if (kDebugMode) print("Error: $e\nStackTrace: $s");
                      context.flushBarErrorMessage(
                          message: "An Error Occurred\n$e");
                    }
                  },
                )
              : const SizedBox.shrink(),

          SessionController.role == Role.visitor
              ? (SessionController.isLogin ?? false
                  ? drawerItem(
                      context: context,
                      title: "Logout Visitor",
                      leading: const Icon(Icons.logout),
                      onTap: () async {
                        try {
                          print('before remove');
                          await SessionController().removeUser();
                          print('future resolved'); // <-- you’ll see this now

                          // If these load from prefs, await them too
                          await SessionController()
                              .loadUserDataFromPreference();

                          print(
                              'rehydrated; token: ${SessionController.token}');

                          if (!context.mounted) return;
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            RoutesName.roleSelection,
                            (_) => false,
                          );
                        } catch (e, st) {
                          // If anything throws, you’ll see it here instead of silently skipping .then
                          debugPrint('removeUser failed: $e\n$st');
                        }
                      }
                      // onTap: () async {
                      //   SessionController().removeUser();
                      //   Navigator.pushNamedAndRemoveUntil(
                      //       context, RoutesName.fiqaSelection, (_) => false);
                      // },
                      )
                  : drawerItem(
                      context: context,
                      title: "Login",
                      leading: const Icon(Icons.login),
                      onTap: () async {
                        if (SessionController.role == Role.visitor) {
                          Navigator.pushNamed(context, RoutesName.login);
                        } else {
                          Navigator.pushNamedAndRemoveUntil(
                              context, RoutesName.roleSelection, (_) => false);
                        }
                      },
                    ))
              : drawerItem(
                  context: context,
                  title: "Logout Imam",
                  leading: const Icon(Icons.logout),
                  onTap: () async {
                    try {
                      print('before remove');
                      await SessionController().removeUser();
                      print('future resolved'); // <-- you’ll see this now

                      // If these load from prefs, await them too
                      await SessionController().loadUserDataFromPreference();

                      print('rehydrated; token: ${SessionController.token}');

                      if (!context.mounted) return;
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RoutesName.roleSelection,
                        (_) => false,
                      );
                    } catch (e, st) {
                      // If anything throws, you’ll see it here instead of silently skipping .then
                      debugPrint('removeUser failed: $e\n$st');
                    }
                  }

                  // onTap: () async {
                  //       await SessionController().removeUser().then((_){
                  //         print("future resolved");
                  //         SessionController().getVisitorFromPreference();
                  //         SessionController().getUserFromPreference();
                  //       });
                  //       print(SessionController.token);
                  //       Navigator.pushNamedAndRemoveUntil(
                  //           context, RoutesName.fiqaSelection, (_) => false);
                  //     },
                  ),
        ],
      ),
    );
  }

  Widget drawerItem({
    required BuildContext context,
    required String title,
    required Icon leading,
    required VoidCallback onTap,
  }) {
    return ListTile(
      dense: true,
      onTap: onTap,
      leading: leading,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
