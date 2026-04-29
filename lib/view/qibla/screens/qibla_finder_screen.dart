import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dart:async';
import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';

import '../../../config/color/color.dart';

class QiblaFinderScreen extends StatelessWidget {
  const QiblaFinderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text("Qibla Finder"),
        ),
        body: const Center(
            child: QiblahCompassWidget1(
          compassAssetPath: 'assets/images/compass.svg',
          needleAssetPath: 'assets/images/needle.svg',
          kaabaAssetPath: 'assets/icons/kaaba.svg',
          // size: 320,
          kaabaSize: 56,
        ),)
        // body: Center(child: QiblahCompass())
        );
  }
}

class QiblahCompassWidget1 extends StatelessWidget {
  const QiblahCompassWidget1({
    super.key,
    this.compassAssetPath = 'assets/images/compass.svg',
    this.needleAssetPath =
        'assets/images/my_needle.svg', // <-- change to your needle
    this.kaabaAssetPath =
        'assets/images/my_kaaba.svg', // <-- change to your kaaba
    this.size, // optional fixed size; if null it auto scales
    this.kaabaSize = 48, // size of kaaba icon
  });

  /// Compass face SVG (your existing ring/face)
  final String compassAssetPath;

  /// Your needle SVG (replaces the old needle)
  final String needleAssetPath;

  /// Your Kaaba SVG (new)
  final String kaabaAssetPath;

  /// Optional fixed side length (square). If null, scales to screen width.
  final double? size;

  /// Visual size of the Kaaba icon.
  final double kaabaSize;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final double side = size ??
        (media.size.width * 0.78).clamp(220.0, media.size.shortestSide * 0.9);

    return StreamBuilder<QiblahDirection>(
      stream: FlutterQiblah.qiblahStream,
      builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final q = snapshot.data!;
        // Keep your original math/signs:
        // - Ring rotates by -direction (so it follows phone heading)
        // - Needle & Kaaba rotate by -qiblah (locked to absolute Qibla on screen)
        final ringAngleRad = -(q.direction) * (pi / 180.0);
        final needleAngleRad = -(q.qiblah) * (pi / 180.0);

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: side,
              height: side,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  // --- Compass face (your SVG), rotates with device heading ---
                  Transform.rotate(
                    angle: ringAngleRad,
                    child: SvgPicture.asset(
                      compassAssetPath,
                      width: side,
                      height: side,
                      fit: BoxFit.contain,
                      colorFilter: ColorFilter.mode(
                          AppColors.secondaryColor, BlendMode.srcIn),
                    ),
                  ),

                  // --- Needle (YOUR asset), locked to Qibla ---
                  Transform.rotate(
                    angle: needleAngleRad,
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      needleAssetPath,
                      height: side * 0.62, // tweak to fit your design
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      // colorFilter: ColorFilter.mode(AppColors.secondaryColor, BlendMode.srcIn),
                    ),
                  ),

                  // --- Kaaba icon at the ring edge, also locked to Qibla ---
                  // We rotate to the same angle, then translate to the top edge so it overlaps the ring.
                  Transform.rotate(
                    angle: needleAngleRad,
                    child: Transform.translate(
                      // place near the top edge; adjust the -8 for a slight overlap
                      offset: Offset(0, -(side * 0.5) + (kaabaSize / 2) - 8),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          // color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x33000000),
                              offset: Offset(0, 3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: SvgPicture.asset(
                          kaabaAssetPath,
                          width: kaabaSize,
                          height: kaabaSize,
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),

                  // --- Offset readout (same as your original) ---
                  // Positioned(
                  //   bottom: 8,
                  //   child: Text("${q.offset.toStringAsFixed(3)}°"),
                  // ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: const Text(
                  '''Place the phone on a flat surface and rotate it gently for a few seconds. The needle and Kaaba icon will auto-adjust—follow them to face Qibla.'''),
            ),
          ],
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_qiblah/flutter_qiblah.dart';
//
// // Normalize to [-180, 180] for nicer logic
// double _normalize180(double a) {
//   double x = (a + 360) % 360;
//   if (x > 180) x -= 360;
//   return x;
// }
//
// class QiblaFinderScreen extends StatelessWidget {
//   const QiblaFinderScreen({super.key});
//
//   // If the arrow seems mirrored (points opposite side), set this to true.
//   static const bool invertRotation = false;
//
//   // If you use Icons.navigation (which looks ~45° by default), set this to 45.
//   // For Icons.arrow_upward_* keep 0.
//   static const double iconBiasDeg = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Qibla Pointer')),
//       body: StreamBuilder<QiblahDirection>(
//         stream: FlutterQiblah.qiblahStream,
//         builder: (context, snap) {
//           if (!snap.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           final q = snap.data!;
//           // Use the plugin’s offset directly (this is the angle you need).
//           double offset = _normalize180(q.offset);
//
//           // Apply optional fixes
//           if (invertRotation) offset = -offset;
//           offset -= iconBiasDeg; // compensate icon baseline if needed
//
//           final aligned = offset.abs() < 5; // tolerance (3–7° is fine)
//
//           return Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 AnimatedRotation(
//                   // AnimatedRotation uses "turns" (revolutions)
//                   turns: offset / 360.0,
//                   duration: const Duration(milliseconds: 140),
//                   curve: Curves.easeOut,
//                   child: const Icon(
//                     Icons.arrow_upward_rounded, // baseline is straight up
//                     size: 120,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   aligned
//                       ? 'Facing Qibla'
//                       : (offset > 0
//                       ? 'Turn RIGHT ${offset.toStringAsFixed(0)}°'
//                       : 'Turn LEFT ${offset.abs().toStringAsFixed(0)}°'),
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Heading ${q.direction.toStringAsFixed(0)}° • '
//                       'Qibla ${q.qiblah.toStringAsFixed(0)}° • '
//                       'Offset ${_normalize180(q.offset).toStringAsFixed(0)}°',
//                   style: Theme.of(context).textTheme.bodySmall,
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
//
//
//
// // import 'dart:math' as math;
// // import 'package:flutter/material.dart';
// // import 'package:flutter_qiblah/flutter_qiblah.dart';
// //
// // double _normalize180(double a) {
// //   double x = (a + 360) % 360;
// //   if (x > 180) x -= 360;
// //   return x; // [-180, 180]
// // }
// //
// // class QiblaFinderScreen extends StatefulWidget {
// //   const QiblaFinderScreen({super.key});
// //   @override
// //   State<QiblaFinderScreen> createState() => _QiblaFinderScreenState();
// // }
// //
// // class _QiblaFinderScreenState extends State<QiblaFinderScreen> {
// //   double? _lockedQiblaDeg; // fixed once
// //   int _calibSamples = 0;
// //   double _calibSum = 0;
// //
// //   void _relock() {
// //     setState(() {
// //       _lockedQiblaDeg = null;
// //       _calibSamples = 0;
// //       _calibSum = 0;
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     FlutterQiblah().dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Qibla Pointer'),
// //         actions: [
// //           IconButton(
// //             tooltip: 'Re-lock Qibla',
// //             onPressed: _relock,
// //             icon: const Icon(Icons.refresh),
// //           ),
// //         ],
// //       ),
// //       body: StreamBuilder<QiblahDirection>(
// //         stream: FlutterQiblah.qiblahStream,
// //         builder: (context, snapshot) {
// //           if (!snapshot.hasData) {
// //             return const Center(child: CircularProgressIndicator());
// //           }
// //           final q = snapshot.data!;
// //
// //           // Lock a stable Qibla bearing (average a few frames to reduce noise)
// //           if (_lockedQiblaDeg == null) {
// //             _calibSum += q.qiblah;
// //             _calibSamples++;
// //             if (_calibSamples >= 6) {
// //               _lockedQiblaDeg = _calibSum / _calibSamples;
// //             }
// //             return const Center(child: Text('Calibrating Qibla… hold steady'));
// //           }
// //
// //           final offset = _normalize180(_lockedQiblaDeg! - q.direction);
// //           final aligned = offset.abs() < 5; // tolerance
// //
// //           return Center(
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 AnimatedRotation(
// //                   // AnimatedRotation takes "turns" (revolutions)
// //                   turns: offset / 360.0,
// //                   duration: const Duration(milliseconds: 140),
// //                   curve: Curves.easeOut,
// //                   child: Icon(
// //                     Icons.arrow_right, // or your Kaaba/arrow asset
// //                     size: 120,
// //                     color: aligned ? Colors.green : Colors.black,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 16),
// //                 Text(
// //                   aligned
// //                       ? 'Facing Qibla'
// //                       : (offset > 0
// //                       ? 'Turn RIGHT ${offset.toStringAsFixed(0)}°'
// //                       : 'Turn LEFT ${offset.abs().toStringAsFixed(0)}°'),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 Text(
// //                   'Locked ${_lockedQiblaDeg!.toStringAsFixed(0)}° • '
// //                       'Heading ${q.direction.toStringAsFixed(0)}° • '
// //                       'Offset ${offset.toStringAsFixed(0)}°',
// //                   style: Theme.of(context).textTheme.bodySmall,
// //                 ),
// //               ],
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// // // import 'dart:math' as math;
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_qiblah/flutter_qiblah.dart';
// // //
// // // double _deg2rad(double d) => d * (math.pi / 180);
// // // double _normalize180(double a) {
// // //   // Normalize to [-180, 180] for nice “turn left/right” text
// // //   double x = (a + 360) % 360;
// // //   if (x > 180) x -= 360;
// // //   return x;
// // // }
// // //
// // // class QiblaFinderScreen extends StatefulWidget {
// // //   const QiblaFinderScreen({super.key});
// // //
// // //   @override
// // //   State<QiblaFinderScreen> createState() => _QiblaFinderScreenState();
// // // }
// // //
// // // class _QiblaFinderScreenState extends State<QiblaFinderScreen> {
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _ensureReady();
// // //   }
// // //
// // //   Future<void> _ensureReady() async {
// // //     final status = await FlutterQiblah.checkLocationStatus();
// // //     if (!mounted) return;
// // //     if (!status.enabled) {
// // //       // Ask for permission (you can show a snackbar/toast here)
// // //       await FlutterQiblah.requestPermissions();
// // //     }
// // //   }
// // //
// // //   @override
// // //   void dispose() {
// // //     FlutterQiblah().dispose();
// // //     super.dispose();
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: const Text('Qibla Finder')),
// // //       body: StreamBuilder<QiblahDirection>(
// // //         stream: FlutterQiblah.qiblahStream,
// // //         builder: (context, snapshot) {
// // //           if (!snapshot.hasData) {
// // //             return const Center(child: CircularProgressIndicator());
// // //           }
// // //           final q = snapshot.data!;
// // //           final offset = _normalize180(q.qiblah - q.direction); // [-180, 180]
// // //           final aligned = offset.abs() < 5; // tolerance, tweak 3–7°
// // //
// // //           return Center(
// // //             child: Column(
// // //               mainAxisSize: MainAxisSize.min,
// // //               children: [
// // //                 SizedBox(
// // //                   width: 260,
// // //                   height: 260,
// // //                   child: Stack(
// // //                     alignment: Alignment.center,
// // //                     children: [
// // //                       // 1) Compass background (rotates opposite device heading)
// // //                       Transform.rotate(
// // //                         angle: _deg2rad(-q.direction),
// // //                         child: _CompassDisk(), // see simple painter below
// // //                       ),
// // //
// // //                       // 2) Qibla arrow (relative to device top)
// // //                       Transform.rotate(
// // //                         angle: _deg2rad(offset),
// // //                         child: Icon(
// // //                           Icons.navigation,
// // //                           size: 90,
// // //                           color: aligned ? Colors.green : Colors.black,
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 16),
// // //                 Text(
// // //                   aligned
// // //                       ? 'Facing Qibla'
// // //                       : (offset > 0
// // //                       ? 'Turn RIGHT ${offset.toStringAsFixed(0)}°'
// // //                       : 'Turn LEFT ${offset.abs().toStringAsFixed(0)}°'),
// // //                   style: Theme.of(context).textTheme.titleMedium,
// // //                 ),
// // //                 const SizedBox(height: 8),
// // //                 Text(
// // //                   'Qibla: ${q.qiblah.toStringAsFixed(0)}° • Heading: ${q.direction.toStringAsFixed(0)}° • Offset: ${offset.toStringAsFixed(0)}°',
// // //                 ),
// // //               ],
// // //             ),
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // /// Simple compass ring so the background isn’t another arrow.
// // // /// Replace with Image.asset('assets/compass.png') if you have one.
// // // class _CompassDisk extends StatelessWidget {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return CustomPaint(
// // //       size: const Size.square(240),
// // //       painter: _CompassPainter(),
// // //     );
// // //   }
// // // }
// // //
// // // class _CompassPainter extends CustomPainter {
// // //   @override
// // //   void paint(Canvas canvas, Size size) {
// // //     final Paint ring = Paint()
// // //       ..style = PaintingStyle.stroke
// // //       ..strokeWidth = 3;
// // //     final center = size.center(Offset.zero);
// // //     final radius = size.width / 2;
// // //
// // //     canvas.drawCircle(center, radius, ring);
// // //
// // //     // Draw N/E/S/W ticks
// // //     final tick = Paint()
// // //       ..strokeWidth = 2
// // //       ..style = PaintingStyle.stroke;
// // //     for (int i = 0; i < 4; i++) {
// // //       final angle = i * (math.pi / 2);
// // //       final p1 = center + Offset(math.cos(angle), math.sin(angle)) * (radius - 8);
// // //       final p2 = center + Offset(math.cos(angle), math.sin(angle)) * (radius);
// // //       canvas.drawLine(p1, p2, tick);
// // //     }
// // //   }
// // //
// // //   @override
// // //   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// // // }
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// // // import 'dart:math' as math;
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_qiblah/flutter_qiblah.dart';
// // // import 'package:namaz_bajamat/utils/extensions/flush_bar_extension.dart';
// // //
// // // class QiblaFinderScreen extends StatefulWidget {
// // //   const QiblaFinderScreen({super.key});
// // //
// // //   @override
// // //   State<QiblaFinderScreen> createState() => _QiblaFinderScreenState();
// // // }
// // //
// // // class _QiblaFinderScreenState extends State<QiblaFinderScreen> {
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _ensureReady();
// // //   }
// // //
// // //   Future<void> _ensureReady() async {
// // //     final status = await FlutterQiblah.checkLocationStatus();
// // //     if (!mounted) return;
// // //     if (!status.enabled) {
// // //       context.flushBarErrorMessage(message: 'Enable Location Permission');
// // //       await FlutterQiblah.requestPermissions();
// // //     }
// // //   }
// // //
// // //   @override
// // //   void dispose() {
// // //     FlutterQiblah().dispose();
// // //     super.dispose();
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: const Text('Qibla Finder')),
// // //       body: StreamBuilder<QiblahDirection>(
// // //         stream: FlutterQiblah.qiblahStream,
// // //         builder: (context, snapshot) {
// // //           if (!snapshot.hasData) {
// // //             return const Center(child: CircularProgressIndicator());
// // //           }
// // //           final q = snapshot.data!;
// // //           // q.direction = device heading from North (0..360)
// // //           // q.qiblah   = Qibla bearing from North (0..360)
// // //           // q.offset   = (q.qiblah - q.direction), signed
// // //           return Center(
// // //             child: Stack(
// // //               alignment: Alignment.center,
// // //               children: [
// // //                 // Your compass background
// // //                 Transform.rotate(
// // //                   angle: (-q.direction) * (math.pi / 180),
// // //                   child: Icon(Icons.navigation, size: 80),
// // //                   // child: Image.asset('assets/icons/mosque-icon.png', width: 260),
// // //                 ),
// // //                 // Qibla arrow (points to Kaaba)
// // //                 Transform.rotate(
// // //                   angle: (q.qiblah - q.direction) * (math.pi / 180),
// // //                   child: Icon(Icons.navigation, size: 80),
// // //                 ),
// // //                 Positioned(
// // //                   bottom: 24,
// // //                   child: Text(
// // //                     'Qibla: ${q.qiblah.toStringAsFixed(0)}° • Offset: ${q.offset.toStringAsFixed(0)}°',
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }
// // // }
