import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grese/features/auth/providers/auth_provider.dart';
import 'package:grese/features/auth/repository/auth_repository.dart';
import 'package:grese/services/shared_pref_service.dart';

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
            tabs: const [
              Tab(icon: Icon(Icons.directions_car)),
              Tab(icon: Icon(Icons.directions_transit)),
            ],
        ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                Icon(Icons.directions_car),
                Icon(Icons.directions_transit),
              ],
            ),
        )
      ],
      ),
    );

    // SafeArea(
    //   child: DefaultTabController(
    //     length: 2,
    //     child: Scaffold(
    //       appBar: AppBar(
    //         elevation: 1.0,
    //         bottom: const TabBar(
    //           tabs: [
    //             Tab(icon: Icon(Icons.directions_car)),
    //             Tab(icon: Icon(Icons.directions_transit)),
    //           ],
    //         ),
    //         title: const Text('Tabs Demo'),
    //       ),
    //       body: const TabBarView(
    //         children: [
    //           Icon(Icons.directions_car),
    //           Icon(Icons.directions_transit),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
