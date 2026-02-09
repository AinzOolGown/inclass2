import 'package:flutter/material.dart';

void main() {
  runApp(const RunMyApp());
}

class RunMyApp extends StatefulWidget {
  const RunMyApp({super.key});

  @override
  State<RunMyApp> createState() => _RunMyAppState();
}

class _RunMyAppState extends State<RunMyApp> {
  // Variable to manage the current theme mode
  ThemeMode _themeMode = ThemeMode.system;

  // Method to toggle the theme
  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Theme Demo',
      
      // TODO: Customize these themes further if desired
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.grey[200], // Light mode background
      ),
      darkTheme: ThemeData.dark(), // Dark mode configuration
      
      themeMode: _themeMode, // Connects the state to the app

      home: Scaffold(
        appBar: AppBar(
          title: const Text('Theme Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // PART 1 TASK: Container and Text
              Container(
                width: 300,
                height: 200,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  // Use a ternary operator to check theme brightness
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.white 
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Mobile App Development Testing',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 20),
              
              const Text('Choose the Theme:', style: TextStyle(fontSize: 16)),
              
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Switch(
                    value: _themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      changeTheme(value ? ThemeMode.dark : ThemeMode.light);
                    },
                    //minor bug: switch does not work properly for the first swtich, fine afterwards
                  ),
                  
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconTheme(
                    data: IconThemeData(
                      color: _themeMode.name == "dark" ? Colors.white : Colors.black,
                    ),
                    child: Icon(_themeMode.name == "dark" ? Icons.dark_mode : Icons.light_mode),
                    //same bug as the switch, very probable that its the switch causing the issue
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
        