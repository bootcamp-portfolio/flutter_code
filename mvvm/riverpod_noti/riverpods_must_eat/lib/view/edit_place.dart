import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpods_must_eat/model/address.dart';
import 'package:riverpods_must_eat/vm/gps_handler.dart';
import 'package:riverpods_must_eat/vm/image_handler.dart';
import 'package:riverpods_must_eat/vm/vm_handler.dart';

class EditPlace extends ConsumerStatefulWidget {
  final int id;
  final String name;
  final String phone;
  final String estimate;
  final double lat;
  final double lng;
  final Uint8List image;

  const EditPlace({
    super.key,
    required this.id,
    required this.name,
    required this.phone,
    required this.estimate,
    required this.lat,
    required this.lng,
    required this.image,
  });

  @override
  ConsumerState<EditPlace> createState() => _EditPlace();
}

class _EditPlace extends ConsumerState<EditPlace> {
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController estimateController;
  late final TextEditingController latController;
  late final TextEditingController lngController;

  @override
  void initState() {
    nameController = TextEditingController();
    phoneController = TextEditingController();
    estimateController = TextEditingController();
    latController = TextEditingController();
    lngController = TextEditingController();

    super.initState();

    // nameController.text = widget.name;
    // phoneController.text = phone;
    // estimateController.text = estimate;
    // latController.text = lat.toString();
    // lngController.text = lng.toString();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(gpsNotifierProvider.notifier)
          .checkLocationPermission();
    }); //재귀함수
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    estimateController.dispose();
    latController.dispose();
    lngController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ImageState = ref.watch(imageNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text("맛집 수정")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildImagePicker(widget.image),
            _buildLatLngFields(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildTextField("이름", nameController),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildTextField(
                "전화",
                phoneController,
                keyboardType: TextInputType.phone,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildTextField(
                "평가",
                estimateController,
                maxLines: 3,
                maxLength: 50,
              ),
            ),
            ElevatedButton(
              onPressed: () => _update(
                context,
                ImageState.imageFile,
                widget.id,
                widget.image,
                //ref,
              ),
              child: Text("수정"),
            ),
          ],
        ),
      ),
    );
  } // build

  // --- Widgets ---
  Widget _buildImagePicker(
    //vm&model부터
    //BuildContext context,
    Uint8List originalImage,
    // WidgetRef ref,
  ) {
    final ImageNotifier = ref.read(
      imageNotifierProvider.notifier,
    );
    final image = ref
        .watch(imageNotifierProvider)
        .imageFile;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                0,
                0,
                10,
                10,
              ),
              child: ElevatedButton(
                onPressed: () =>
                    ImageNotifier.getImageFromGallery(
                      ImageSource.gallery,
                    ),
                child: Text("갤러리"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                10,
                0,
                0,
                10,
              ),
              child: ElevatedButton(
                onPressed: () =>
                    ImageNotifier.getImageFromGallery(
                      ImageSource.camera,
                    ),
                child: Text("카메라"),
              ),
            ),
          ],
        ),
        Container(
          width: double.infinity,
          height: 200,
          color: Colors.grey[300],
          child: image == null
              ? Image.memory(originalImage) //widget.image
              : Image.file(File(image.path)),
        ),
      ],
    );
  }

  Widget _buildLatLngFields() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
        child: _coordField("위도", latController),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: _coordField("경도", lngController),
      ),
    ],
  );

  Widget _coordField(
    String label,
    TextEditingController controller,
  ) => SizedBox(
    width: 150,
    child: TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      readOnly: true,
    ),
  );

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    int maxLines = 1,
    int? maxLength,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  // --- Functions ---
  Future<void> _update(
    BuildContext context,
    XFile? imageFile,
    int id,
    Uint8List originalImage,
    // WidgetRef ref,
  ) async {
    final vmModel = ref.read(vmNotifierProvider.notifier);

    Uint8List imageBytes = originalImage;
    if (imageFile != null) {
      imageBytes = await File(imageFile.path).readAsBytes();
    }

    final address = Address(
      id: id,
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      estimate: estimateController.text.trim(),
      lat: double.parse(latController.text),
      lng: double.parse(lngController.text),
      image: imageBytes,
    );

    if (imageFile != null) {
      await vmModel.updateAddressAll(address);
    } else {
      await vmModel.updateAddress(address);
    }

    if (!context.mounted)
      return; // await 이후에는 context가 여전히 유효한지 확인
    _showDialog(context);
  }

  void _showDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.amber[50],
          title: Text('수정 완료'),
          content: Text("맛집이 수정 되었습니다."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(parentContext).pop();
                Navigator.of(parentContext).pop();
              },
              child: Text('종료'),
            ),
          ],
        );
      },
    );
  }
} // class
