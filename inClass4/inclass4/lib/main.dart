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
  List<int> _history = [0];
  int _historyIndex = 0;

  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void updateCounter(int newValue) {
    newValue = newValue.clamp(0, 100);

    setState(() {
      // Remove future history if we changed after undo
      _history = _history.sublist(0, _historyIndex + 1);

      _history.add(newValue);
      _historyIndex++;

      _counter = newValue;
    });
  }

  void undo() {
    if (_historyIndex > 0) {
      setState(() {
        _historyIndex--;
        _counter = _history[_historyIndex];
      });
    }
  }

  void redo() {
    if (_historyIndex < _history.length - 1) {
      setState(() {
        _historyIndex++;
        _counter = _history[_historyIndex];
      });
    }
  }

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
                    _counter = (_counter - 1).clamp(0, 100); // Decrement counter
                  });
                },
                child: Text('-'),
              ),
              ElevatedButton(
                onPressed: _historyIndex > 0 ? undo : null,
                child: Text('Undo'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _counter = 0; // Reset counter
                  });
                },
                child: Text('Reset'),
              ),
              ElevatedButton(
                onPressed: _historyIndex < _history.length - 1 ? redo : null,
                child: Text('Redo'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _counter = (_counter + 1).clamp(0, 100); // Increment counter
                  });
                },
                child: Text('+'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) {
                      int? newValue = int.tryParse(value);

                      if (newValue != null) {
                        newValue = newValue.clamp(0, 100);

                        setState(() {
                          _counter = newValue!;
                        });
                      }

                      _textController.clear(); //clear after enter/submit
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter a number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ],
          ), 
        ],
      ),
    );
  }
}