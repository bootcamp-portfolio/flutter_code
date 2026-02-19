import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:riverpods_must_eat/view/edit_place.dart';
import 'package:riverpods_must_eat/view/insert_place.dart';
import 'package:riverpods_must_eat/vm/image_handler.dart';
import 'package:riverpods_must_eat/vm/map_place.dart';
import 'package:riverpods_must_eat/vm/vm_handler.dart';

class QueryPlace extends ConsumerWidget {
  const QueryPlace({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressAsync = ref.watch(vmNotifierProvider);
    final vm_handler = ref.read(
      vmNotifierProvider.notifier,
    );
    final imageHandler = ref.read(
      imageNotifierProvider.notifier,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('내가 경험한 맛집'),
        actions: [
          IconButton(
            onPressed: () {
              imageHandler.clearImage(); // 기존 입력 이미지 삭제
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InsertPlace(),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: addressAsync.when(
        data: (addressList) {
          if (addressList.isEmpty) {
            return Center(child: Text('등록된 자료가 없습니다.'));
          }
          return ListView.builder(
            itemCount: addressList.length,
            itemBuilder: (context, index) {
              final address = addressList[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPlace(
                      lat: address.lat,
                      lng: address.lng,
                    ),
                  ),
                ),
                child: Slidable(
                  startActionPane: ActionPane(
                    motion: BehindMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Colors.green,
                        icon: Icons.edit,
                        label: '수정',
                        onPressed: (context) {
                          imageHandler
                              .clearImage(); //메모리 이미지 삭제
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditPlace(
                                    id: address.id!,
                                    name: address.name,
                                    phone: address.phone,
                                    estimate:
                                        address.estimate,
                                    lat: address.lat,
                                    lng: address.lng,
                                    image: address.image,
                                  ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: BehindMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                        label: '삭제',
                        onPressed: (context) async {
                          await vm_handler.deleteAddress(
                            address.id!,
                          );
                        },
                      ),
                    ],
                  ),
                  child: Card(
                    child: Row(
                      children: [
                        Image.memory(
                          address.image,
                          width: 100,
                          height: 80,
                        ),
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              '명칭 : ${address.name}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text("전화번호 : ${address.phone}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },

        error: (error, stackTrace) =>
            Center(child: Text('오류:$error')),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
