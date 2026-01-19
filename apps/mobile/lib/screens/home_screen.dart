import 'package:flutter/material.dart';

import 'settings_tab.dart';
import 'contacts_tab.dart';

/// Home screen with bottom navigation for main features.
/// Provides navigation between Friends, Calls, and Settings.
/// Includes a floating action button for sharing the app with friends.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    ContactsTab(),
    Center(child: Text('Calls Tab')),   // Placeholder
    SettingsTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call Me Maybe'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Calls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Share app logic
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Share app with friends')),
          );
        },
        tooltip: 'Share App',
        child: const Icon(Icons.share),
      ),
    );
  }
}