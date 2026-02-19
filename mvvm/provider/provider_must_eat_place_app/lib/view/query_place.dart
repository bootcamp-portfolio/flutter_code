import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:provider_must_eat_place_app/view/edit_place.dart';
import 'package:provider_must_eat_place_app/view/insert_place.dart';
import 'package:provider_must_eat_place_app/view/map_place.dart';
import 'package:provider_must_eat_place_app/vm/image_handler.dart';
import 'package:provider_must_eat_place_app/vm/vm_handler.dart';

class QueryPlace extends StatelessWidget {
  const QueryPlace({super.key});

  @override
  Widget build(BuildContext context) {
    //쿼리 모델
    final vm = context.watch<VMModel>();
    final addressList = vm.address;
    return Scaffold(
      appBar: AppBar(
        title: Text('내가 경험한 맛집'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<ImageModel>().clearImage();
              Navigator.push(
                //기존 입력 이미지 삭제
                context,
                MaterialPageRoute(
                  builder: (context) => InsertPlace(),
                ),
              ).then((value) => vm.loadAddress());
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: addressList.isEmpty
          ? Center(child: Text('등록한 자료가 없습니다.'))
          : ListView.builder(
              itemCount: addressList.length,
              itemBuilder: (context, index) {
                final address = addressList[index]; //
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
                            context
                                .read<ImageModel>()
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
                            await context
                                .read<VMModel>()
                                .deleteAddressAll(
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
                                CrossAxisAlignment.center,
                            children: [
                              Text(
                                "명칭: ${address.name}",
                                style: TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                              Text('전화번호:${address.phone}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
