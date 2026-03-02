import 'package:flutter/material.dart';

enum MurshidSummonType { envelope, calling }

class MurshidPopupController {
  OverlayEntry buildSummon({
    required BuildContext context,
    required MurshidSummonType type,
    required VoidCallback onTap,
  }) {
    return OverlayEntry(
      builder: (_) => _PigeonSummon(type: type, onTap: onTap),
    );
  }
}

class _PigeonSummon extends StatefulWidget {
  const _PigeonSummon({required this.type, required this.onTap});

  final MurshidSummonType type;
  final VoidCallback onTap;

  @override
  State<_PigeonSummon> createState() => _PigeonSummonState();
}

class _PigeonSummonState extends State<_PigeonSummon> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          final t = _controller.value;
          final dx = -120 + (MediaQuery.of(context).size.width - 60) * t;
          final dy = -80 + (MediaQuery.of(context).size.height - 120) * (t * t);
          return Stack(
            children: [
              Positioned(
                left: dx,
                top: dy,
                child: GestureDetector(
                  onTap: widget.onTap,
                  child: Column(
                    children: [
                      const Icon(Icons.flutter_dash, size: 44, color: Colors.white),
                      Text(widget.type == MurshidSummonType.calling ? 'Murshid is calling you' : 'Message from Murshid'),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
