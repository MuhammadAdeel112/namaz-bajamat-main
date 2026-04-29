import 'package:flutter/material.dart';
import 'package:namaz_bajamat/view/dashboard/dashboard_screen.dart';
import 'package:namaz_bajamat/view/login/login_screen.dart';
import 'package:namaz_bajamat/view/mosques/screens/update_imam_own_masjid.dart';
import 'package:namaz_bajamat/view/onboarding/fiqa_selection_screen.dart';
import 'package:namaz_bajamat/view/profile/screens/update_imam_profile_screen.dart';
import 'package:namaz_bajamat/view/profile/screens/update_visitor_profile_screen.dart';
import 'package:namaz_bajamat/view/qibla/screens/qibla_finder_screen.dart';

import '../../view/forgot_password/forgot_password_screen.dart';
import '../../view/mosques/screens/all_mosques_screen.dart';
import '../../view/onboarding/role_selection_screen.dart';
import '../../view/signup/imam/screens/masjid_details_screen.dart';
import '../../view/signup/imam/screens/signup_screen.dart';
import '../../view/signup/visitor/screens/vistor_signup_screen.dart';
import '../../view/splash/splash_screen.dart';
import 'routes_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings,) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());
      // case RoutesName.fiqaSelection:
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) => const FiqaSelectionScreen());
      case RoutesName.roleSelection:
        return MaterialPageRoute(
            builder: (BuildContext context) => const RoleSelectionScreen());
      case RoutesName.dashboard:
        return MaterialPageRoute(
            builder: (BuildContext context) => const DashboardScreen());

      case RoutesName.imamSignup:
        return MaterialPageRoute(builder: (BuildContext context) => ImamSignupScreen());
      case RoutesName.visitorSignup:
        return MaterialPageRoute(builder: (BuildContext context) => VistorSignupScreen());
      case RoutesName.forgetPassword:
        return MaterialPageRoute(builder: (BuildContext context) => ForgetPasswordScreen());
      case RoutesName.masjidDetails:
        return MaterialPageRoute(builder: (BuildContext context) => MasjidDetailsScreen());
      case RoutesName.login:
        return MaterialPageRoute(builder: (BuildContext context) => LoginScreen());
      case RoutesName.resetPassword:
        // return MaterialPageRoute(builder: (BuildContext context) => ResetPassword());
      case RoutesName.updateVisitorProfile:
        return MaterialPageRoute(builder: (BuildContext context) => UpdateVisitorProfileScreen());
      case RoutesName.updateImamProfile:
        return MaterialPageRoute(builder: (BuildContext context) => UpdateImamProfileScreen());
      case RoutesName.allMosques:
        return MaterialPageRoute(builder: (BuildContext context) => AllMosquesScreen());
      case RoutesName.qiblaFinder:
        return MaterialPageRoute(builder: (BuildContext context) => QiblaFinderScreen());
      // case RoutesName.updateImamOwnMasjid:
      //   return MaterialPageRoute(builder: (BuildContext context) => UpdateImamOwnMasjid());
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
}
