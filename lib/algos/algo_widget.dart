import 'package:algoscreens/algos/algo_visualiser_widget.dart';
import 'package:algoscreens/algos/physics_balls.dart';
import 'package:flutter/material.dart';

class AlgoWidget extends StatefulWidget {
  const AlgoWidget({super.key});

  @override
  State<AlgoWidget> createState() => _AlgoWidgetState();
}

class _AlgoWidgetState extends State<AlgoWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: AlgoVisualiserWidget<dynamic>(
        painter: (state, paint) => PhysicsBalls2(state: state, repaint: paint),
      ),
    );
  }
}
