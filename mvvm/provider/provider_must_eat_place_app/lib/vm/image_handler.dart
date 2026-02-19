import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageModel extends ChangeNotifier {
  final ImagePicker picker = ImagePicker();
  XFile? imageFile;

  Future<void> getImageFromGallery(
    ImageSource source,
  ) async {
    final pickedFile = await picker.pickImage(
      source: source,
    );
    if (pickedFile != null) {
      imageFile = pickedFile;
      notifyListeners(); //불러오고 노티파이
    }
  }

  void clearImage() {
    imageFile = null;
    notifyListeners(); //지우고 노티파이
  }
}
