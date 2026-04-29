// import 'package:flutter/material.dart';
// import 'package:namaz_bajamat/config/components/round_button.dart';
// import 'package:namaz_bajamat/config/routes/routes_name.dart';
// import 'package:namaz_bajamat/utils/extensions/enum_extensions.dart';
// import '../../services/session_controller/session_controller.dart';
// import '../../utils/enums.dart';
//
// class FiqaSelectionScreen extends StatefulWidget {
//   const FiqaSelectionScreen({super.key});
//
//   @override
//   State<FiqaSelectionScreen> createState() => _FiqaSelectionScreenState();
// }
//
// class _FiqaSelectionScreenState extends State<FiqaSelectionScreen> {
//   final ValueNotifier<Fiqa?> selectedFiqa = ValueNotifier(null);
//
//   final List<Fiqa> fiqas = Fiqa.values;
//
//   @override
//   void dispose() {
//     selectedFiqa.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 50),
//             Text(
//               'Please select your Fiqa to continue:',
//               style: theme.textTheme.titleLarge,
//             ),
//             const SizedBox(height: 20),
//             ValueListenableBuilder<Fiqa?>(
//               valueListenable: selectedFiqa,
//               builder: (_, value, __) {
//                 return Column(
//                   children: fiqas.map((fiqa) {
//                     return RadioListTile<Fiqa>(
//                       value: fiqa,
//                       groupValue: value,
//                       title: Text(fiqa.label, style: theme.textTheme.bodyLarge),
//                       onChanged: (val) {
//                         // if (val != null) SessionController().saveFiqa(val);
//                         selectedFiqa.value = val;
//                       },
//                     );
//                   }).toList(),
//                 );
//               },
//             ),
//             const Spacer(),
//             SizedBox(
//               width: double.infinity,
//               child: RoundButton(
//                 onPress: () {
//                   if (selectedFiqa.value != null) {
//                     Navigator.pushNamed(context, RoutesName.roleSelection);
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text("Please select a Fiqa")),
//                     );
//                   }
//                 },
//                 title: 'Continue',
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
