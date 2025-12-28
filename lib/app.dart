import 'package:flutter/material.dart';
import 'screens/main_shell.dart';

class CartoApp extends StatelessWidget {
  const CartoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainShell(),
    );
  }
}
