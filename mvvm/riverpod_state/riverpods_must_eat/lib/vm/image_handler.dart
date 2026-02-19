import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

class ImageState {
  XFile? imageFile;
  ImageState({this.imageFile});
} //ImageState

class ImageNotifier extends StateNotifier<ImageState> {
  ImageNotifier() : super(ImageState());
  final ImagePicker picker = ImagePicker();

  Future<void> getImageFromGallery(
    ImageSource source,
  ) async {
    final pickedFile = await picker.pickImage(
      source: source,
    );
    if (pickedFile != null) {
      //위의 생성자 사용
      state = ImageState(imageFile: pickedFile);
    }
  }

  void clearImage() {
    state = ImageState(); //<<<<<<<<<<<<<
  }
} //ImageNotifier

final imageNotifierProvider =
    StateNotifierProvider<ImageNotifier, ImageState>(
      (ref) => ImageNotifier(), //클래스 이름가지고 생성
    ); //<<<<<<<<<<<<<<중요
