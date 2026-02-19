import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ImageState {
  //클라스 안에서 클라스를 부름

  XFile? imageFile;

  ImageState({this.imageFile});
  ImageState copyWith({XFile? imageFile}) =>
      ImageState(imageFile: imageFile);
} //재귀함수? 래퍼쉬? 팩토리얼

class ImageNotifier extends Notifier<ImageState> {
  final ImagePicker picker = ImagePicker();
  @override
  ImageState build() => ImageState();

  // ImageNotifier() : super(ImageState());

  Future<void> getImageFromGallery(
    ImageSource source,
  ) async {
    final pickedFile = await picker.pickImage(
      source: source,
    );
    if (pickedFile != null) {
      state = state.copyWith(imageFile: pickedFile);
    }
  }

  void clearImage() {
    state = ImageState();
  }
} // ImageNotifier

final imageNotifierProvider =
    NotifierProvider<ImageNotifier, ImageState>(
      ImageNotifier.new,
    );
