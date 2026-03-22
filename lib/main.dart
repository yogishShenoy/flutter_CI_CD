import 'package:flutter/material.dart';
import 'features/animation/RepeatingAnimation.dart';
import 'features/isolate/isolate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(home: RepeatingAnimation());
}
