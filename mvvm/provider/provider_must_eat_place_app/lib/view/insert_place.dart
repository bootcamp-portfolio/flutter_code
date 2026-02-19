import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:provider_must_eat_place_app/model/address.dart';
import 'package:provider_must_eat_place_app/vm/gps_handler.dart';
import 'package:provider_must_eat_place_app/vm/image_handler.dart';
import 'package:provider_must_eat_place_app/vm/vm_handler.dart';

class InsertPlace extends StatelessWidget {
  InsertPlace({super.key});

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final estimateController = TextEditingController();
  final latController = TextEditingController();
  final lngController = TextEditingController();
  //watch

  @override
  Widget build(BuildContext context) {
    final gps = context.watch<GpsModel>();
    final imageModel = context.watch<ImageModel>();
    latController.text = gps.latitude;
    lngController.text = gps.longitude;
    return Scaffold(
      appBar: AppBar(title: Text('맛집 추가')),
      body: gps.latitude.isEmpty
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
                  onPressed: () =>
                      _insert(context, imageModel),
                  child: Text('입력'),
                ),
              ],
            ),
    );
  } //build

  //widgets
  Widget _buildImagePicker(BuildContext context) {
    final imageModel = context.read<ImageModel>();
    final image = context.watch<ImageModel>().imageFile;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => imageModel
                  .getImageFromGallery(ImageSource.gallery),
              child: Text('gallery'),
            ),
            ElevatedButton(
              onPressed: () => imageModel
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
      _coordFields("위도", latController),
      _coordFields("경도", lngController),
    ],
  );

  Widget _coordFields(
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
  Future<void> _insert(
    BuildContext context,
    ImageModel imageModel, //공부 필요
  ) async {
    final vmModel = context.read<VMModel>();
    if (imageModel.imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('이미지를 선택해 주세요'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final bytes = await File(
      //공부 매우 필요
      imageModel.imageFile!.path,
    ).readAsBytes();
    final address = Address(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      estimate: estimateController.text.trim(),
      lat: double.parse(latController.text),
      lng: double.parse(lngController.text),
      image: bytes,
    );
    await vmModel.insertAddress(address);
    if (!context.mounted) return; //중요 버그
    _showDialog(context); //gap발생:awaitasync때문에
  }

  void _showDialog(BuildContext parentContext) {
    showDialog(
      //parent 이름 다르게
      //공부 필요
      context: parentContext,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.amber[50],
          title: Text('입력 완료'),
          content: Text("맛집이 등록 되었습니다."),
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
} //class
