import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpods_must_eat/model/address.dart';
import 'package:riverpods_must_eat/vm/gps_handler.dart';
import 'package:riverpods_must_eat/vm/image_handler.dart';
import 'package:riverpods_must_eat/vm/vm_handler.dart';

class InsertPlace extends ConsumerWidget {
  InsertPlace({super.key});

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final estimateController = TextEditingController();
  final latController = TextEditingController();
  final lngController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gps = ref.watch(GpsNotifierProvider); //째려봄
    final imageModel = ref.watch(
      imageNotifierProvider,
    ); //<<<<<<<<<<<<

    //위치 데이터 요청
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (gps.latitude.isNotEmpty) {
        latController.text = gps.latitude;
        lngController.text = gps.longitude;
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text('맛집 추가')),
      body: gps.latitude.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildImagePicker(context, ref),
                    _buildLatLngFields(),
                    _buildTextField('이름', nameController),
                    _buildTextField(
                      '전화번호',
                      phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    _buildTextField(
                      '평가',
                      estimateController,
                      maxLine: 3,
                      maxLength: 50,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _insert(
                          context,
                          imageModel.imageFile,
                          ref,
                        );
                      },
                      child: Text('입력'),
                    ),
                  ],
                ),
              ),
            ),
    );
  } // build

  // === Widgets ===
  Widget _buildImagePicker(
    BuildContext context,
    WidgetRef ref,
  ) {
    final imageModel = ref.read(
      imageNotifierProvider.notifier,
    );
    final image = ref.watch(
      imageNotifierProvider, //<<<<<<<<<<<
    );
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  imageModel.getImageFromGallery(
                    ImageSource.gallery,
                  );
                },
                child: Text('갤러리'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  imageModel.getImageFromGallery(
                    ImageSource.camera,
                  );
                },
                child: Text('카메라'),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            height: 200,
            color: Colors.grey[200],
            child: image == null
                ? Center(child: Text('이미지를 선택하여라'))
                : Image.file(File(image.imageFile!.path)),
          ),
        ),
      ],
    );
  } // _buildImagePicker

  Widget _buildLatLngFields() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _coordField("위도", latController),
      _coordField("경도", lngController),
    ],
  ); // _buildLatLngFields

  Widget _coordField(
    String label,
    TextEditingController controller,
  ) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      width: 150,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        readOnly: true,
      ),
    ),
  ); // _coordField

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    int maxLine = 1,
    int? maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        maxLines: maxLine,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  } // _buildTextField

  // === Functions ===

  Future _insert(
    BuildContext context,
    XFile? imageFile,
    WidgetRef ref,
  ) async {
    if (imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('이미지를 선택해 주세요'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final bytes = await File(imageFile.path).readAsBytes();
    final address = Address(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      estimate: estimateController.text.trim(),
      lat: double.parse(latController.text),
      lng: double.parse(lngController.text),
      image: bytes,
    );

    await ref
        .read(vmNotifierProvider.notifier)
        .insertAddress(address);
    if (!context.mounted) return;
    _showDialog(context);
  } // _insert

  void _showDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.amber[50],
          title: const Text('입력 완료'),
          content: const Text("맛집이 등록 되었습니다."),
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
  } // _showDialog
} // class
