import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_must_eat_place_app/model/address.dart';
import 'package:getx_must_eat_place_app/vm/vm_handler.dart';
import 'package:image_picker/image_picker.dart';

class InsertPlace extends StatelessWidget {
  InsertPlace({super.key});
  //정의
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final estimateController = TextEditingController();
  final latController = TextEditingController();
  final lngController = TextEditingController();
  //watch
  final vmHandler = Get.find<VmHandler>();

  @override
  Widget build(BuildContext context) {
    vmHandler.checkLocationPermission();

    return Scaffold(
      appBar: AppBar(title: Text('맛집 추가')),
      body: Obx(
        () => vmHandler.latitude.value.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildImagePicker(context),
                  _buildLatLngFileds(),
                  _buildTextField('이름', nameController),
                  _buildTextField(
                    '전화',
                    phoneController,
                    keyboardType: TextInputType.phone,
                  ), //키밸류 딕셔너리 맵
                  _buildTextField(
                    '평가',
                    estimateController,
                    maxLines: 3,
                    maxLength: 50,
                  ), //공부 필요
                  ElevatedButton(
                    onPressed: () => _insert(),
                    child: Text('입력'),
                  ),
                ],
              ),
      ),
    );
  } //build

  //widgets
  Widget _buildImagePicker(BuildContext context) {
    final image = vmHandler.imageFile.value;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => vmHandler
                  .getImageFromGallery(ImageSource.gallery),
              child: Text('gallery'),
            ),
            ElevatedButton(
              onPressed: () => vmHandler
                  .getImageFromGallery(ImageSource.camera),
              child: Text('camera'),
            ),
          ],
        ),
        Container(
          width: double.infinity,
          height: 200,
          color: Colors.grey[300],
          child: image == null
              ? Center(child: Text('이미지를 선택해주세요.'))
              : Image.file(File(image.path)),
        ),
      ],
    );
  } //

  Widget _buildLatLngFileds() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _coordFields(
        "위도",
        latController,
        vmHandler.latitude.value,
      ),
      _coordFields(
        "경도",
        lngController,
        vmHandler.longitude.value,
      ),
    ],
  );

  Widget _coordFields(
    String label,
    TextEditingController controller,
    String value,
  ) {
    controller.text = value;
    return SizedBox(
      width: 150,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        readOnly: true,
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    int maxLines = 1,
    int? maxLength,
    //옵셔널 생략가능//기본값
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

  //function
  Future<void> _insert() async {
    if (vmHandler.imageFile.value == null) {
      Get.snackbar('오류', '이미지를 선택해주세요');
      return;
    }
    final bytes = await File(
      //공부 매우 필요
      vmHandler.imageFile.value!.path,
    ).readAsBytes();
    final address = Address(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      estimate: estimateController.text.trim(),
      lat: double.parse(latController.text),
      lng: double.parse(lngController.text),
      image: bytes,
    );
    await vmHandler.insertAddress(address);
    vmHandler.imageFile.value = null;
    _showDialog();
  }

  void _showDialog() {
    Get.defaultDialog(
      title: '입력완료',
      middleText: '맛집이 등록되었습니다.',
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('확인'),
        ),
      ],
    ).then((_) => Get.back());
  }
} //class
