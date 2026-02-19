import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  const DigitalPetApp({super.key});

  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  Timer? _winTimer;
  bool _hasWon = false;
  bool _isGameOver = false;
  String petName = "Your Pet";
  int happinessLevel = 10;
  int hungerLevel = 50;
  
  Color _contColor = Colors.redAccent;
  Timer? _hungerTimer;

  void _changeColor() {
    setState(() {
      if (hungerLevel < 50 && happinessLevel > 80) {
        _contColor = Colors.greenAccent;
      } else if (hungerLevel < 90 && happinessLevel > 30) {
        _contColor = Colors.orangeAccent;
      } else {
        _contColor = Colors.redAccent;
      }
    });
  }

  void _playWithPet() {
    setState(() {
      happinessLevel += 10;
      _updateHunger();
      _changeColor();
      _checkGameOver();
      _checkWinCondition();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10;
      _updateHappiness();
      _changeColor();
      _checkGameOver();
      _checkWinCondition();
    });
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel -= 20;
    } else {
      happinessLevel += 10;
    }
  }

  void _updateHunger() {
    setState(() {
      hungerLevel += 5;
      if (hungerLevel > 100) {
        hungerLevel = 100;
        happinessLevel -= 20;
      }
    });
  }

  void _renamePet() {
    TextEditingController controller = TextEditingController(text: petName);
    //pop up dialog to rename pet
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Rename Your Pet'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter pet name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  petName = controller.text.isEmpty ? petName : controller.text;
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    hungerLevel = hungerLevel.clamp(0, 100);
    happinessLevel = happinessLevel.clamp(0, 100);

    _hungerTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {
        hungerLevel += 5;

        if (hungerLevel > 100) {
          hungerLevel = 100;
          happinessLevel -= 10;
        }
      
        _changeColor();
        _checkGameOver();
        _checkWinCondition();
      });
    });
  }

  @override
  void dispose() {
    _hungerTimer?.cancel();
    super.dispose();
  }

  String get petMood {
    if (happinessLevel >= 70 && hungerLevel < 50) {
      return "🙂 Happy";
    } else if (happinessLevel >= 30) {
      return "😐 Neutral";
    } else {
      return "🙁 Unhappy";
    }
  }

  void _checkGameOver() {
    if (!_isGameOver && happinessLevel <= 10 && hungerLevel >= 100) {
      _isGameOver = true;

      _hungerTimer?.cancel();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Game Over"),
            content: Text("Your pet was neglected and ran away 😢"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _restartGame();
                },
                child: Text("Restart"),
              ),
            ],
          );
        },
      );
    }
  }

  void _checkWinCondition() {
    if (_hasWon || _isGameOver) return;

    if (happinessLevel > 80) {
      if (_winTimer == null) {
        _winTimer = Timer(Duration(minutes: 3), () {
          _showWinDialog();
        });
      }
    } else {
      _winTimer?.cancel();
      _winTimer = null;
    }
  }

  void _showWinDialog() {
    _hasWon = true;
    _hungerTimer?.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("You Win 🎉"),
          content: Text("Your pet is thriving and loves you!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _restartGame();
              },
              child: Text("Play Again"),
            ),
          ],
        );
      },
    );
  }



  void _restartGame() {
    setState(() {
      happinessLevel = 50;
      hungerLevel = 50;
      _isGameOver = false;
    });

    _hungerTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {
        hungerLevel += 5;
        hungerLevel = hungerLevel.clamp(0, 100);
        happinessLevel = happinessLevel.clamp(0, 100);
        _checkGameOver();
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: _renamePet,
              child: Text(
                '$petName',
                style: TextStyle(
                  fontSize: 20.0,
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                ),
              ),
            ),

            SizedBox(height: 8.0),
            Text(
              'Mood: $petMood',
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 16.0),

            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _contColor,
              ),
              child: Image.asset(
                'assets/fox.png',
                fit: BoxFit.scaleDown,
              ),
            ),

            Text('Happiness Level: $happinessLevel', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 16.0),
            Text('Hunger Level: $hungerLevel', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
