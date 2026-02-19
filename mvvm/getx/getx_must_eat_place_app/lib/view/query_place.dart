import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:getx_must_eat_place_app/view/edit_place.dart';
import 'package:getx_must_eat_place_app/view/insert_place.dart';
import 'package:getx_must_eat_place_app/view/map_place.dart';
import 'package:getx_must_eat_place_app/vm/vm_handler.dart';

class QueryPlace extends StatelessWidget {
  const QueryPlace({super.key});

  @override
  Widget build(BuildContext context) {
    //쿼리 모델
    final vmHandler = Get.find<VmHandler>();
    vmHandler.queryAddress();

    return Scaffold(
      appBar: AppBar(
        title: Text('내가 경험한 맛집'),
        actions: [
          IconButton(
            onPressed: () => Get.to(InsertPlace()),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Obx(
        () => vmHandler.addresses.isEmpty
            ? Center(child: Text('등록한 자료가 없습니다.'))
            : ListView.builder(
                itemCount: vmHandler.addresses.length,
                itemBuilder: (context, index) {
                  final address =
                      vmHandler.addresses[index]; //
                  return GestureDetector(
                    onTap: () => Get.to(
                      MapPlace(),
                      arguments: [address.lat, address.lng],
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
                              Get.to(
                                EditPlace(),
                                arguments: [
                                  address.id,
                                  address.name,
                                  address.phone,
                                  address.estimate,
                                  address.lat,
                                  address.lng,
                                  address.image,
                                ],
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
                              int? idNum = address.id;
                              await vmHandler.deleteAddress(
                                idNum!,
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
                                Text(
                                  '전화번호:${address.phone}',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
