import 'package:flutter/material.dart';
import 'package:grese/screens/saved_folders/saved_folders_screen.dart';
import 'package:grese/screens/saved_lists/saved_lists_screen.dart';

class MyListsScreen extends StatefulWidget {
  const MyListsScreen({super.key});

  @override
  State<MyListsScreen> createState() => _MyListsScreenState();
}

class _MyListsScreenState extends State<MyListsScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // _tabController.animateTo(2);
  }

  @override
  Widget build(BuildContext context) {
    // var currentUser = ref.watch(currentUserProvider);

    return SafeArea(
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).primaryColor,
            tabs: const [
              Tab(icon: Icon(Icons.view_day_outlined)),
              Tab(icon: Icon(Icons.folder_outlined)),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                SavedListsScreen(),
                SavedFoldersScreen(),
              ],
            ),
          )
        ],
      ),
    );

  }
}
