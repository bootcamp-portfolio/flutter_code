import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_tabbar_app/view/first_page.dart';
import 'package:getx_tabbar_app/view/seconds_page.dart';
import 'package:getx_tabbar_app/view/third_page.dart';
import 'package:getx_tabbar_app/vm/tab_model.dart';

class Home extends StatelessWidget {
  // Provider의 TabBar는 Stateful로 제어한다.
  Home({super.key}); //const지움
  final TabModel controller = Get.find<TabModel>();
  final List<Widget> pages = [
    FirstPage(),
    SecondsPage(),
    ThirdPage(),
  ];
  //중간 지우면 ful->less
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TabBar Example'),
        bottom: TabBar(
          controller: controller.tabController, //tabmodel
          tabs: [
            Tab(icon: Icon(Icons.home), text: "홈"),
            Tab(icon: Icon(Icons.business), text: "비즈니스"),
            Tab(icon: Icon(Icons.school), text: "학교"),
          ],
          //온탭제거
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: pages,
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          //함수
          currentIndex: controller.currentIndex.value,
          onTap: (value) {
            controller.tabController.index = value;
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "홈",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: "비즈니스",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: "학교",
            ),
          ],
        ),
      ),
    );
  }
}
