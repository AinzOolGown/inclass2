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
  String petName = "Your Pet";
  int happinessLevel = 10;
  int hungerLevel = 50;
  
  Color _contColor = Colors.redAccent;
  Timer? _hungerTimer;

  void _changeColor() {
    setState(() {
      _contColor = happinessLevel > 70 ? Colors.greenAccent : happinessLevel > 30 ? Colors.orangeAccent : Colors.redAccent;
    });
  }

  void _playWithPet() {
    setState(() {
      happinessLevel += 10;
      _updateHunger();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10;
      _updateHappiness();
    });
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel -= 20;
    } else {
      happinessLevel += 10;
    }
    _changeColor();
  }

  void _updateHunger() {
    setState(() {
      hungerLevel += 5;
      if (hungerLevel > 100) {
        hungerLevel = 100;
        happinessLevel -= 20;
      }
    });
    _changeColor();
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

    _hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        hungerLevel += 10;

        if (hungerLevel > 100) {
          hungerLevel = 100;
          happinessLevel -= 10;
        }
      
        _changeColor();
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
