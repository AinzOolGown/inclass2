import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: _TabsNonScrollableDemo(),
      ),
    );
  }
}

class _TabsNonScrollableDemo extends StatefulWidget {
  @override
  __TabsNonScrollableDemoState createState() =>
      __TabsNonScrollableDemoState();
}

class __TabsNonScrollableDemoState extends State<_TabsNonScrollableDemo>
    with SingleTickerProviderStateMixin, RestorationMixin {
  late TabController _tabController;
  final RestorableInt tabIndex = RestorableInt(0);

  @override
  String get restorationId => 'tab_non_scrollable_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController.index = tabIndex.value;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );

    _tabController.addListener(() {
      setState(() {
        tabIndex.value = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4'];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Tabs Demo'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          tabs: [
            for (final tab in tabs) Tab(text: tab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 1 — Icons (Red background)
          Container(
            color: Colors.red,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Icon(Icons.favorite, color: Colors.white, size: 32),
                  Icon(Icons.audiotrack, color: Colors.white, size: 32),
                  Icon(Icons.beach_access, color: Colors.white, size: 32),
                  Icon(Icons.calculate, color: Colors.white, size: 32),
                ],
              ),
            ),
          ),

          // TAB 2 — Card (Green background)
          Container(
            color: Colors.green,
            child: Center(
              child: Card(
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'This is a Card widget',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ),

          // TAB 3 — Text Input (Blue background)
          Container(
            color: Colors.blue,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Enter some text',
                  ),
                ),
              ),
            ),
          ),

          // TAB 4 — Button (Orange background)
          Container(
            color: Colors.orange,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // Button action
                },
                child: Text('Press Me'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
