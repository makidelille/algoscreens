import 'package:flutter/widgets.dart';

abstract class AlgoVisualiserPainter<T> extends CustomPainter {
  String get name;
  Duration get duration;

  AlgoVisualiserPainter({required this.state, super.repaint});

  T? state;

  T onUpdate(BuildContext context);

  T initState();

  @override
  void paint(Canvas canvas, Size size);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

typedef AlgoVisualiserPainterBuilder<T> =
    AlgoVisualiserPainter<T> Function(T? state, Listenable? repaint);

class AlgoVisualiserWidget<T> extends StatefulWidget {
  final AlgoVisualiserPainterBuilder<T> painter;

  const AlgoVisualiserWidget({super.key, required this.painter});

  @override
  State<AlgoVisualiserWidget> createState() => _AlgoVisualiserWidgetState();
}

class _AlgoVisualiserWidgetState<T> extends State<AlgoVisualiserWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late T state;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.painter(null, null).duration,
    );
    _controller.addListener(() {
      setState(() {
        state = widget.painter(state, null).onUpdate(context);
      });
    });
    _controller.repeat();

    state = widget.painter(null, null).initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: widget.painter(state, _controller));
  }
}
