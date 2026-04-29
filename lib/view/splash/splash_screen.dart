// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:namaz_bajamat/services/splash/splash_services.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen>{
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text("data")
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:namaz_bajamat/services/splash/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this);
    SplashServices().checkAuth(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset("assets/animations/bismillah.json",
            height: 100,
            fit: BoxFit.cover,
            controller: _controller, onLoaded: (composition) {
          _controller
            ..duration = composition.duration * 0.3
            ..forward();
        }),
      ),
    );
  }
}
