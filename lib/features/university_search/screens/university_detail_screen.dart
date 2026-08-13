import 'package:flutter/material.dart';

class UniversityDetailScreen extends StatelessWidget {
  const UniversityDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('University Detail')),
      body: Center(
        child: Text(
          'Viewing university ID: $id\n(Full detail build is in a future task)',
        ),
      ),
    );
  }
}
