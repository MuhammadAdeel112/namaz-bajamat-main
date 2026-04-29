import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TopImageContainer extends StatelessWidget {
  const TopImageContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    double maxHeight = 200;
    if(screenHeight < 752) maxHeight = screenHeight * 0.2;
    return Stack(
      children: [
        Image.asset(
          'assets/images/mosque_header.png',
          width: double.infinity,
          height: maxHeight,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 30,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                "assets/animations/bismillah.json",
                height: 100,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 10,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                "assets/animations/namaz.json",
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 5,
              )
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 30,
          child: Lottie.asset(
            "assets/animations/quran.json",
            height: 80,
            width: 80,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
