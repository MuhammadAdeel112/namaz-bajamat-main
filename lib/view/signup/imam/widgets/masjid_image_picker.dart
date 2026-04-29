import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../bloc/signup/signup_bloc.dart';
import '../../../../utils/image_utils.dart';
import '../../../shared_widgets/image_source_bottom_sheet.dart';

class MasjidImagePicker extends StatelessWidget {
  const MasjidImagePicker({super.key});

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final img = await ImageUtils.pickImage(source);
    if (img != null) {
      context.read<SignupBloc>().add(MasjidPicChanged(img));
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ImageSourceBottomSheet(
        onImageSelected: (source) => _pickImage(context, source),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _showBottomSheet(context),
      child: BlocBuilder<SignupBloc, SignupState>(
        builder: (context, state) {
          return Stack(
            children: [
              Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  image: state.masjidPic != null
                      ? DecorationImage(
                          image: FileImage(state.masjidPic!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: state.masjidPic == null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_city,
                              size: 60,
                              color: theme.colorScheme.primary,
                            ),
                            Text("Add Masjid Picture",
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      )
                    : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
