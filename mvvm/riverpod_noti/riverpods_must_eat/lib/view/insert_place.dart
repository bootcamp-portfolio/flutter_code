import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpods_must_eat/model/address.dart';
import 'package:riverpods_must_eat/vm/gps_handler.dart';
import 'package:riverpods_must_eat/vm/image_handler.dart';
import 'package:riverpods_must_eat/vm/vm_handler.dart';

class InsertPlace extends ConsumerStatefulWidget {
  const InsertPlace({super.key});
  //<<<<<<<<<<<<<Stateful 위치요청+dispose

  @override
  ConsumerState<InsertPlace> createState() =>
      _InsertPlaceState();
}

class _InsertPlaceState extends ConsumerState<InsertPlace> {
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController estimateController;
  late final TextEditingController latController;
  late final TextEditingController lngController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    estimateController = TextEditingController();
    latController = TextEditingController();
    lngController = TextEditingController();
    //위치데이터 요청 1번만
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
    //<<<<<<<<<<<<<<<<<<<<<<<<<<
    final gps = ref.watch(gpsNotifierProvider);
    final ImageState = ref.watch(imageNotifierProvider);

    // 위치 데이터 요청
    // ref
    //     .read(gpsNotifierProvider.notifier)
    //     .checkLocationPermission();

    // latController.text = gps.latitude;
    // lngController.text = gps.longitude;

    if (gps.latitude.isNotEmpty)
      latController.text = gps.latitude;
    if (gps.longitude.isNotEmpty)
      lngController.text = gps.longitude;

    return Scaffold(
      appBar: AppBar(title: Text('맛집 추가')),
      body: gps.latitude.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildImagePicker(ref), //함수
                _buildLatLngFields(),
                _buildTextField('이름', nameController),
                _buildTextField(
                  '전화',
                  phoneController,
                  keyboardType: TextInputType.phone,
                ),
                _buildTextField(
                  '평가',
                  estimateController,
                  maxLines: 3,
                  maxLength: 50,
                ),
                ElevatedButton(
                  onPressed: () => _insert(
                    context,
                    ImageState.imageFile,
                    //ref뺌
                  ), //<<<<<<<<<<<<<<<<<<<<<<<<<
                  child: Text('입력'),
                ),
              ],
            ),
    );
  } // build

  // --- Widgets
  Widget _buildImagePicker(
    // BuildContext context,
    WidgetRef ref,
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
          children: [
            ElevatedButton(
              onPressed: () =>
                  ImageNotifier.getImageFromGallery(
                    ImageSource.gallery,
                  ),
              child: Text('갤러리'),
            ),
            ElevatedButton(
              onPressed: () =>
                  ImageNotifier.getImageFromGallery(
                    ImageSource.camera,
                  ),
              child: Text('카메라'),
            ),
          ],
        ),
        Container(
          width: double.infinity,
          height: 200,
          color: Colors.grey[300],
          child: image == null
              ? Center(child: Text('이미지를 선택해 주세요'))
              : Image.file(File(image.path)),
        ),
      ],
    );
  }

  Widget _buildLatLngFields() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _coordField("위도", latController),
      _coordField("경도", lngController),
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

  // ---Functions
  Future<void> _insert(
    BuildContext context,
    XFile? imageFile,
    // WidgetRef ref,
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
    if (!context.mounted) return; // 아래 파란줄 나오면 써주기
    _showDialog(context); //await이후유효한지 확인
  }

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
              child: const Text('종료'),
            ),
          ],
        );
      },
    );
  }
} // class
