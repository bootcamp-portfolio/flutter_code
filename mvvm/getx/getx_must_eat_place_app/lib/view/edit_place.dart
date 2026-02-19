import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_must_eat_place_app/model/address.dart';
import 'package:getx_must_eat_place_app/vm/vm_handler.dart';
import 'package:image_picker/image_picker.dart';

class EditPlace extends StatelessWidget {
  EditPlace({super.key});

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final estimateController = TextEditingController();
  final latController = TextEditingController();
  final lngController = TextEditingController();

  final vmHandler = Get.find<VmHandler>();
  @override
  Widget build(BuildContext context) {
    final address = Get.arguments as Map<String, dynamic>;

    nameController.text = address['name'];
    phoneController.text = address['phone'];
    estimateController.text = address['estimate'];
    ; // args[3];
    latController.text = address['lat']
        .toString(); // //args[4].toString();
    lngController.text = address['lng']
        .toString(); // args[5].toString();

    return Scaffold(
      appBar: AppBar(title: Text("맛집 수정")),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildImagePicker(
                address['image'],
              ), //args[6]),
              _buildLatLngFields(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildTextField(
                  "이름",
                  nameController,
                ),
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
                onPressed: () {
                  _update(address['id']!, address['image']);
                  // _update(args[0], args[6]);
                },
                child: Text("수정"),
              ),
            ],
          ),
        ),
      ),
    );
  } // build

  // --- Widgets ---
  Widget _buildImagePicker(Uint8List originalImage) {
    final image = vmHandler.imageFile.value;

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
                    vmHandler.getImageFromGallery(
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
                    vmHandler.getImageFromGallery(
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
    int id,
    Uint8List originalImage,
  ) async {
    final handler = Get.find<VmHandler>();
    Uint8List imageBytes = originalImage;
    if (handler.imageFile.value != null) {
      imageBytes = await File(
        handler.imageFile.value!.path,
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

    if (handler.imageFile.value != null) {
      await handler.updateAddressAll(address);
    } else {
      await handler.updateAddress(address);
    }

    _showDialog();
  }

  void _showDialog() {
    Get.defaultDialog(
      title: '수정 완료',
      middleText: '맛집이 수정 되었습니다.',
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            Get.back();
          },
          child: const Text('종료'),
        ),
      ],
    );
  }
} // class
