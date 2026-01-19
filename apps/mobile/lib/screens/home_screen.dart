import 'package:flutter/material.dart';

import 'settings_tab.dart';

/// Home screen with TabBar for main features.
/// Provides navigation between Friends, Calls, and Settings tabs.
/// Includes a floating action button for sharing the app with friends.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Call Me Maybe'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.people), text: 'Friends'),
              Tab(icon: Icon(Icons.call), text: 'Calls'),
              Tab(icon: Icon(Icons.settings), text: 'Settings'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // Placeholder for FriendsTab from contacts feature
            Center(child: Text('Friends Tab')),
            // Placeholder for CallsTab from recents feature
            Center(child: Text('Calls Tab')),
            // SettingsTab
            SettingsTab(),
          ],
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
      ),
    );
  }
}