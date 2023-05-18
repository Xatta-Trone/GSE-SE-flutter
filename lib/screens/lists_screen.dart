import 'package:flutter/material.dart';
import 'package:grese/screens/global_folder/global_folder_screen.dart';
import 'package:grese/screens/global_list_screen.dart';

class ListsScreen extends StatefulWidget {
  const ListsScreen({super.key});

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // _tabController.animateTo(2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            labelColor: Theme.of(context).primaryColor,
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.view_day_outlined)),
              Tab(icon: Icon(Icons.folder_outlined)),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                GlobalListScreen(),
                GlobalFolderScreen(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
