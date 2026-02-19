import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:getx_must_eat_place_app/vm/gps_handler.dart';
import 'package:image_picker/image_picker.dart';

class ImageHandler extends GpsHandler {
  final ImagePicker picker = ImagePicker();
  final imageFile = Rx<XFile?>(null); //obs사용하면 null 체크 불가

  Future<void> getImageFromGallery(
    ImageSource source,
  ) async {
    final pickedFile = await picker.pickImage(
      source: source,
    );
    if (pickedFile != null) {
      imageFile.value = pickedFile;
    }
  }

  void clearImage() {
    imageFile.value = null;
  }
}
