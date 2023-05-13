import 'package:flutter/material.dart';

class GlobalListScreen extends StatefulWidget {
  const GlobalListScreen({super.key});

  @override
  State<GlobalListScreen> createState() => _GlobalListScreenState();
}

class _GlobalListScreenState extends State<GlobalListScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Global Screen'),
    );
  }
}
