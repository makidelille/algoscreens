import 'package:algoscreens/algos/algo_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const AlgoScreen(),
    );
  }
}

class AlgoScreen extends StatelessWidget {
  const AlgoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AlgoWidget();
  }
}
