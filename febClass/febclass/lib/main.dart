import 'dart:async';

import 'package:flutter/material.dart';

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

class ValentineHome extends StatefulWidget  {
  const ValentineHome({super.key});

  @override
  State<ValentineHome> createState() => _ValentineHomeState();
}

class _ValentineHomeState extends State<ValentineHome>  {
  Timer? _timer;
  bool _isTimerActive = false;

  @override
  void initState() {
    super.initState();
    _isTimerActive = false;
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  void _toggleTimer() {
    if (_isTimerActive) {
      _timer?.cancel(); // Stop the timer
    } else {
      // Start a periodic timer that switches the value every second
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) {
          setState(() {
            // Toggle between "Value A" and "Value B"
            _modifier = (_modifier == 1.0) ? 1.2 : 1.0;
          });
        },
      );
    }
    setState(() {
      _isTimerActive = !_isTimerActive; // Update the button state
    });
  }

  final List<String> emojiOptions = ['Sweet Heart', 'Party Heart'];
  String selectedEmoji = 'Sweet Heart';
  double _modifier = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFC1E3), Color.fromARGB(255, 251, 61, 61)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              title: const Text('Cupid\'s Canvas'),
              backgroundColor: Colors.transparent,
            ),
          body: Column(
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
                    size: Size(300, 300),
                    painter: HeartEmojiPainter(type: selectedEmoji, mod: _modifier),
                  ),
                ),
              ),
        
              ElevatedButton(
                onPressed: _toggleTimer, 
                child: Text("Resize!"),
              ),
        
            ],
          ),
        ),
      ),
    );
  }
}

class HeartEmojiPainter extends CustomPainter {
  HeartEmojiPainter({required this.type, double this.mod=1});
  final String type;
  final double mod;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;

    // Heart base
    final heartPath = Path()
      ..moveTo(center.dx, center.dy + 60)
      ..cubicTo(center.dx + 110*mod, center.dy - 10*mod, center.dx + 60*mod, center.dy - 120*mod, center.dx, center.dy - 40*mod)
      ..cubicTo(center.dx - 60*mod, center.dy - 120*mod, center.dx - 110*mod, center.dy - 10*mod, center.dx, center.dy + 60*mod)
      ..close();

    paint.color = type == 'Party Heart' ? const Color(0xFFF48FB1) : const Color(0xFFE91E63);
    canvas.drawPath(heartPath, paint);

    // Face features (starter)
    final eyePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(center.dx - 30, center.dy - 10), 10*mod, eyePaint);
    canvas.drawCircle(Offset(center.dx + 30, center.dy - 10), 10*mod, eyePaint);

    final mouthPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawArc(Rect.fromCircle(center: Offset(center.dx, center.dy + 20), radius: 30*mod), 0, 3.14, false, mouthPaint);

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
  bool shouldRepaint(covariant HeartEmojiPainter oldDelegate) => oldDelegate.type != type || oldDelegate.mod != mod;
}