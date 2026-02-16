import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stateful Lab',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CounterWidget(),
    );
  }
}

class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0; // This is our STATE

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Interactive Counter')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              color: Colors.blue.shade100,
              padding: EdgeInsets.all(20),
              child: Text(
                '$_counter',
                style: TextStyle(fontSize: 50.0, color: _counter > 50 ? Colors.green : _counter == 0 ? Colors.red : Colors.black),
              ),
            ),
          ),
          SizedBox(height: 20),
          Slider(
            min: 0, max: 100,
            value: _counter.toDouble(),
            onChanged: (double value) {
              // 👇 This triggers the UI rebuild
              setState(() {
                _counter = value.toInt();
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _counter -= 1; // Decrement counter
                  });
                },
                child: Text('-'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _counter = 0; // Reset counter
                  });
                },
                child: Text('Reset'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _counter += 1; // Increment counter
                  });
                },
                child: Text('+'),
              ),
            ],
          )
        ],
      ),
    );
  }
}