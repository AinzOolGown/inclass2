import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

void main() => runApp(const ValentineApp());

class ValentineApp extends StatelessWidget {
  const ValentineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ValentineHome(),
      theme: ThemeData(useMaterial3: true),
    );
  }
}

class ValentineHome extends StatefulWidget {
  const ValentineHome({super.key});

  @override
  State<ValentineHome> createState() => _ValentineHomeState();
}

class _ValentineHomeState extends State<ValentineHome> with TickerProviderStateMixin {
  final List<String> emojiOptions = ['Sweet Heart', 'Party Heart'];
  String selectedEmoji = 'Sweet Heart';
  
  late ConfettiController _controllerCenter;
  final Random _rng = Random();

  // Confetti particle count that increases each click
  int _confettiCount = 20;

  // Balloons
  final List<_Balloon> _balloons = [];

  // Timer for continuous balloon generation
  Timer? _balloonTimer;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _controllerCenter = ConfettiController(duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    _balloonTimer?.cancel();
    for (final balloon in _balloons) {
      balloon.controller.dispose();
    }
    super.dispose();
  }

  void _showConfetti() {
    _controllerCenter.play();
  }

  void _addBalloons(int count) {
    for (var i = 0; i < count; i++) {
      final id = DateTime.now().microsecondsSinceEpoch + i;
      final duration = Duration(milliseconds: 3000 + _rng.nextInt(3000));
      final controller = AnimationController(vsync: this, duration: duration);
      final animation = Tween<double>(begin: -0.2, end: 1.2).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));
      final left = _rng.nextDouble();
      
      // Red and pink shades
      final redPinkColors = const [
        Color(0xFFFF0000), // bright red
        Color(0xFFFF1744), // red accent
        Color(0xFFFF4444), // light red
        Color(0xFFCC0000), // dark red
        Color(0xFFFF69B4), // hot pink
        Color(0xFFFF1493), // deep pink
        Color(0xFFFFC0CB), // light pink
        Color(0xFFFFB6C1), // light pink2
        Color(0xFF990000), // maroon
        Color(0xFFFF99CC), // pale pink
      ];
      final color = redPinkColors[_rng.nextInt(redPinkColors.length)];

      final balloon = _Balloon(id: id, controller: controller, animation: animation, left: left, color: color);
      setState(() => _balloons.add(balloon));

      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.dispose();
          setState(() => _balloons.removeWhere((b) => b.id == id));
        }
      });

      controller.forward();
    }
  }

  void _startContinuousGeneration() {
    if (_isGenerating) return;
    _isGenerating = true;

    // Start confetti and restart every 6 seconds (duration of controller)
    _controllerCenter.play();
    Timer.periodic(const Duration(seconds: 6), (timer) {
      if (_isGenerating) {
        _controllerCenter.play();
      } else {
        timer.cancel();
      }
    });

    // Generate 20 balloons every 500ms
    _balloonTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_isGenerating) {
        _addBalloons(20);
      }
    });
  }

  void _stopContinuousGeneration() {
    _isGenerating = false;
    _balloonTimer?.cancel();
    _balloonTimer = null;
    _controllerCenter.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cupid\'s Canvas')),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: selectedEmoji,
                items: emojiOptions
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => selectedEmoji = value ?? selectedEmoji),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Center(
                  child: CustomPaint(
                    size: const Size(300, 300),
                    painter: HeartEmojiPainter(type: selectedEmoji),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (_isGenerating) {
                    _stopContinuousGeneration();
                  } else {
                    _startContinuousGeneration();
                  }
                },
                child: Text(_isGenerating ? 'Stop Party!' : 'Drop Balloons!'),
              ),
              const SizedBox(height: 24),
            ],
          ),

          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controllerCenter,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.5,
              numberOfParticles: _confettiCount,
              maxBlastForce: 20,
              minBlastForce: 5,
              gravity: 0.1,
              // Metallic / shiny tones (gold, silver, bronze, platinum, rose)
              colors: const [
                Color(0xFFFFD700), // gold
                Color(0xFFC0C0C0), // silver
                Color(0xFFB87333), // copper/bronze
                Color(0xFFE5E4E2), // platinum
                Color(0xFFB76E79), // rose gold
              ],
            ),
          ),

          // Balloons layer
          ..._balloons.map((b) {
            return AnimatedBuilder(
              animation: b.controller,
              builder: (context, child) {
                return Align(
                  alignment: FractionalOffset(b.left, b.animation.value),
                  child: Transform.translate(
                    offset: const Offset(0, 0),
                    child: SizedBox(
                      width: 72,
                      height: 96,
                      child: CustomPaint(
                        painter: _BalloonPainter(color: b.color),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}

class HeartEmojiPainter extends CustomPainter {
  HeartEmojiPainter({required this.type});
  final String type;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;

    // Heart base
    final heartPath = Path()
      ..moveTo(center.dx, center.dy + 60)
      ..cubicTo(center.dx + 110, center.dy - 10, center.dx + 60, center.dy - 120, center.dx, center.dy - 40)
      ..cubicTo(center.dx - 60, center.dy - 120, center.dx - 110, center.dy - 10, center.dx, center.dy + 60)
      ..close();

    paint.color = type == 'Party Heart' ? const Color(0xFFF48FB1) : const Color(0xFFE91E63);
    canvas.drawPath(heartPath, paint);

    // Face features (starter)
    final eyePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(center.dx - 30, center.dy - 10), 10, eyePaint);
    canvas.drawCircle(Offset(center.dx + 30, center.dy - 10), 10, eyePaint);

    final mouthPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawArc(Rect.fromCircle(center: Offset(center.dx, center.dy + 20), radius: 30), 0, 3.14, false, mouthPaint);

    // Party hat placeholder (expand for confetti)
    if (type == 'Party Heart') {
      final hatPaint = Paint()..color = const Color(0xFFFFD54F);
      final hatPath = Path()
        ..moveTo(center.dx, center.dy - 110)
        ..lineTo(center.dx - 40, center.dy - 40)
        ..lineTo(center.dx + 40, center.dy - 40)
        ..close();
      canvas.drawPath(hatPath, hatPaint);
    }
  }

  @override
  bool shouldRepaint(covariant HeartEmojiPainter oldDelegate) => oldDelegate.type != type;
}

class _Balloon {
  final int id;
  final AnimationController controller;
  final Animation<double> animation;
  final double left; // fraction 0..1
  final Color color;

  _Balloon({required this.id, required this.controller, required this.animation, required this.left, required this.color});
}

class _BalloonPainter extends CustomPainter {
  final Color color;
  _BalloonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 0.8);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(18));
    canvas.drawRRect(rrect, paint);

    // string
    final path = Path()
      ..moveTo(size.width / 2, size.height * 0.8)
      ..lineTo(size.width / 2, size.height);
    final linePaint = Paint()
      ..color = Colors.black26
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _BalloonPainter oldDelegate) => oldDelegate.color != color;
}

