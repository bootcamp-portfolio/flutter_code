import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_tabbar_app/view/first_page.dart';
import 'package:provider_tabbar_app/view/seconds_page.dart';
import 'package:provider_tabbar_app/view/third_page.dart';
import 'package:provider_tabbar_app/vm/tab_model.dart';

class Home extends StatefulWidget {
  // Provider의 TabBar는 Stateful로 제어한다.
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<Widget> _pages = [
    FirstPage(),
    SecondsPage(),
    ThirdPage(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _pages.length,
      vsync: this,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<TabModel>().changeTab(
          _tabController.index,
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = context
        .watch<TabModel>()
        .currentIndex;
    return Scaffold(
      appBar: AppBar(
        title: Text('Provider TabBar Example'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.home), text: "홈"),
            Tab(icon: Icon(Icons.business), text: "비즈니스"),
            Tab(icon: Icon(Icons.school), text: "학교"),
          ],
          onTap: (value) {
            context.read<TabModel>().changeTab(value);
            _tabController.animateTo(value);
          },
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          context.read<TabModel>().changeTab(value);
          _tabController.animateTo(value);
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
    );
  }
}
