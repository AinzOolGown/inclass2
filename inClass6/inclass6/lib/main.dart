import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rocket Launch Controller',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CounterWidget(),
    );
  }
}

class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  // set counter value
  int _counter = 0;
  Color _contColor = Colors.red;

  void _changeColor() {
    setState(() {
      if (_counter == 0) {
        _contColor = Colors.red;
      } else if (_counter < 50 && _counter > 1) {
        _contColor = Colors.orange;
      } else if (_counter >= 50 && _counter < 100){
        _contColor = Colors.green;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rocket Launch Controller'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              color: Colors.blue,
              child: Text(
                '$_counter',
                style: const TextStyle(fontSize: 50.0),
              ),
            ),
          ),
          SliderTheme(
            data: SliderThemeData(
              valueIndicatorTextStyle: TextStyle(
                color: _contColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Slider(
              min: 0,
              max: 100,
              value: _counter.toDouble(),
              onChanged: (double value) {
                setState(() {
                  _counter = value.toInt();
                });
                _changeColor();
              },
              activeColor: Colors.blue,
              inactiveColor: Colors.red,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _counter = 0;
                  });
                },
                child: const Text('Abort'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _counter -= 5;
                  });
                },
                child: const Text('Throttle Down'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _counter += 1;
                  });
                },
                child: const Text('Ignite'),
              ),
            ]
          ),
        ],
      ),
    );
  }
}