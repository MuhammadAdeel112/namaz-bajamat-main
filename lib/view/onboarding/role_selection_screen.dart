import 'package:flutter/material.dart';
import 'package:namaz_bajamat/config/components/round_button.dart';
import 'package:namaz_bajamat/config/routes/routes_name.dart';
import 'package:namaz_bajamat/utils/extensions/enum_extensions.dart';
import '../../services/session_controller/session_controller.dart';
import '../../utils/enums.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  final ValueNotifier<Role> selectedRole = ValueNotifier(Role.visitor);

  final List<Role> role = Role.values;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SessionController().saveRole(selectedRole.value);
  }

  @override
  void dispose() {
    selectedRole.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Text(
              'Please select your Role to continue:',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<Role>(
              valueListenable: selectedRole,
              builder: (_, value, __) {
                return Column(
                  children: role.map((role) {
                    return RadioListTile<Role>(
                      value: role,
                      groupValue: value,
                      title: Text(role.label, style: theme.textTheme.bodyLarge),
                      onChanged: (val) {
                        if (val != null) {
                          SessionController().saveRole(val);
                          selectedRole.value = val;
                        }
                      },
                    );
                  }).toList(),
                );
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: RoundButton(
                onPress: () {
                  if (selectedRole.value != null) {
                    if (selectedRole.value == Role.imam) {
                      Navigator.pushNamed(context, RoutesName.imamSignup);
                    } else {
                      print("pushing to dashboard");
                      Navigator.pushNamedAndRemoveUntil(
                          context, RoutesName.dashboard, (_) => false);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select a Role")),
                    );
                  }
                },
                title: 'Continue',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
