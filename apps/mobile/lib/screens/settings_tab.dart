import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text('Theme', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Toggle between light and dark theme'),
              value: provider.themeMode == ThemeMode.dark,
              onChanged: (value) {
                provider.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
              },
            ),
            const SizedBox(height: 20),
            const Text('Language', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<Locale>(
              value: provider.locale,
              items: const [
                DropdownMenuItem(value: Locale('en'), child: Text('English')),
                DropdownMenuItem(value: Locale('ru'), child: Text('Русский')),
              ],
              onChanged: (locale) {
                if (locale != null) {
                  provider.setLocale(locale);
                }
              },
            ),
          ],
        );
      },
    );
  }
}