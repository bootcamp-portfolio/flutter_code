import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:provider_must_eat_place_app/model/address.dart';
import 'package:provider_must_eat_place_app/vm/image_handler.dart';
import 'package:provider_must_eat_place_app/vm/vm_handler.dart';

class EditPlace extends StatelessWidget {
  final int id;
  final String name;
  final String phone;
  final String estimate;
  final double lat;
  final double lng;
  final Uint8List image;
  //get알규먼트 생성자로 바꿔서
  EditPlace({
    super.key,
    required this.id,
    required this.name,
    required this.phone,
    required this.estimate,
    required this.lat,
    required this.lng,
    required this.image,
  });
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final estimateController = TextEditingController();
  final latController = TextEditingController();
  final lngController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final imageModel = context.watch<ImageModel>();

    nameController.text = name;
    phoneController.text = phone;
    estimateController.text = estimate;
    latController.text = lat.toString();
    lngController.text = lng.toString();

    return Scaffold(
      appBar: AppBar(title: Text("맛집 수정")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildImagePicker(context, image),
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
              onPressed: () =>
                  _update(context, imageModel, id, image),
              child: Text("수정"),
            ),
          ],
        ),
      ),
    );
  } // build

  // --- Widgets ---
  Widget _buildImagePicker(
    BuildContext context,
    Uint8List originalImage,
  ) {
    final imageModel = context.read<ImageModel>();
    final image = context.watch<ImageModel>().imageFile;
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
                    imageModel.getImageFromGallery(
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
                    imageModel.getImageFromGallery(
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
              ? Image.memory(originalImage)
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
    ImageModel imageModel,
    int id,
    Uint8List originalImage,
  ) async {
    final vmModel = context.read<VMModel>();

    Uint8List imageBytes = originalImage;
    if (imageModel.imageFile != null) {
      imageBytes = await File(
        imageModel.imageFile!.path,
      ).readAsBytes();
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

    if (imageModel.imageFile != null) {
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
          title: const Text('수정 완료'),
          content: const Text("맛집이 수정 되었습니다."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(parentContext).pop();
                Navigator.of(parentContext).pop();
              },
              child: const Text('종료'),
            ),
          ],
        );
      },
    );
  }
} // class
