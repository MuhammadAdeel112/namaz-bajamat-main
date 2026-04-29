import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceBottomSheet extends StatelessWidget {
  final void Function(ImageSource source) onImageSelected;

  const ImageSourceBottomSheet({
    super.key,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take Photo"),
              onTap: () {
                Navigator.pop(context);
                onImageSelected(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
              onTap: () {
                Navigator.pop(context);
                onImageSelected(ImageSource.gallery);
              },
            ),
            // const Divider(height: 1),
            // ListTile(
            //   leading: const Icon(Icons.close),
            //   title: const Text("Cancel"),
            //   onTap: () => Navigator.pop(context),
            // ),
          ],
        ),
      ),
    );
  }
}
