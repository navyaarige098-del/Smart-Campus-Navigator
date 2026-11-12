import 'package:flutter/material.dart';
import '../data/campus_data.dart';
import '../models/place.dart';

/// Offline, zoomable campus map drawn with CustomPainter.
class CampusMap extends StatelessWidget {
  const CampusMap({super.key, this.highlight, this.route = const [], this.onBuildingTap});

  final String? highlight; // building id to highlight
  final List<Offset> route; // route polyline
  final ValueChanged<Building>? onBuildingTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final scale = c.maxWidth / CampusData.mapSize.width;
      return InteractiveViewer(
        maxScale: 4,
        child: GestureDetector(
          onTapUp: (d) {
            final p = d.localPosition / scale;
            for (final b in CampusData.buildings) {
              if (b.rect.contains(p)) onBuildingTap?.call(b);
            }
          },
          child: CustomPaint(
            size: Size(c.maxWidth, CampusData.mapSize.height * scale),
            painter: _MapPainter(scale, highlight, route, Theme.of(context).brightness == Brightness.dark),
          ),
        ),
      );
    });
  }
}

class _MapPainter extends CustomPainter {
  _MapPainter(this.scale, this.highlight, this.route, this.dark);
  final double scale;
  final String? highlight;
  final List<Offset> route;
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(scale);
    canvas.drawRect(Offset.zero & CampusData.mapSize, Paint()..color = dark ? const Color(0xFF1E2A22) : const Color(0xFFE8F5E9));

    final road = Paint()
      ..color = dark ? const Color(0xFF555555) : Colors.white
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;
    for (final r in CampusData.roads) {
      canvas.drawLine(CampusData.nodes[r[0]]!, CampusData.nodes[r[1]]!, road);
    }

    for (final b in CampusData.buildings) {
      final rr = RRect.fromRectAndRadius(b.rect, const Radius.circular(6));
      final hl = b.id == highlight;
      canvas.drawRRect(rr, Paint()..color = hl ? Colors.redAccent : b.color);
      _label(canvas, b.name, b.rect.center, hl ? Colors.white : Colors.black87);
    }

    if (route.length > 1) {
      final path = Path()..moveTo(route.first.dx, route.first.dy);
      for (final p in route.skip(1)) {
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(path, Paint()
        ..color = const Color(0xFF1565C0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeJoin = StrokeJoin.round);
      canvas.drawCircle(route.first, 8, Paint()..color = Colors.green);
      canvas.drawCircle(route.last, 8, Paint()..color = Colors.red);
    }

    // main gate marker
    final gate = CampusData.nodes['m0']!;
    _label(canvas, 'MAIN GATE', gate + const Offset(0, 20), dark ? Colors.white70 : Colors.black54);
  }

  void _label(Canvas canvas, String text, Offset center, Color color) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: 100);
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(_MapPainter old) => old.highlight != highlight || old.route != route || old.dark != dark;
}
