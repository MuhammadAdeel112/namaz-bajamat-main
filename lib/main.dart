import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:namaz_bajamat/config/themes/dark_theme.dart';
import 'package:namaz_bajamat/config/themes/light_theme.dart';
import 'package:namaz_bajamat/cubit/address_field_cubit/address_field_cubit.dart';
import 'package:namaz_bajamat/cubit/update_mosque_timings/update_mosque_timings_cubit.dart';

import 'bloc/mosques/mosques_bloc.dart';
import 'bloc/signup/signup_bloc.dart';
import 'config/routes/routes.dart';
import 'config/routes/routes_name.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SignupBloc()),
        BlocProvider(create: (_) => MosquesBloc()),
        BlocProvider(create: (_) => AddressFieldCubit(googleApiKey: "AIzaSyCpx9xm5qvll_KR5mSBTsP8W_O8Mn0gkYo")),
        BlocProvider(create: (_) => UpdateMosqueTimingsCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: lightTheme,
        darkTheme: darkTheme,
        initialRoute: RoutesName.splash,
        onGenerateRoute: (settings) => Routes.generateRoute(settings),
        builder: EasyLoading.init(),
      ),
    );
  }
}
