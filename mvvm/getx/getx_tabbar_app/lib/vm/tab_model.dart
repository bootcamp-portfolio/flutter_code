import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class TabModel extends GetxController
    with GetSingleTickerProviderStateMixin {
  //홈대신 가져옴 스테이트풀 대신 리스
  late TabController tabController;
  RxInt currentIndex = 0.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      currentIndex.value = tabController.index;
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}//currentindex순서