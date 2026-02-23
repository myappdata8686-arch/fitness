import 'package:flutter/material.dart';

class PhysicalScreen extends StatelessWidget {
  const PhysicalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Physical screen placeholder'),
        ),
      ),
    );
  }
}
