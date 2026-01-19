import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // User Profile
              const CircleAvatar(
                radius: 40,
                child: Icon(Icons.person, size: 40),
              ),
              const SizedBox(height: 16),
              const Text(
                'John Doe', // Placeholder
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                '+1 234 567 890', // Placeholder
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Settings
              const Text('Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Уведомления и звуки'),
                value: true, // Placeholder
                onChanged: (value) {
                  // TODO: Handle notifications
                },
              ),
              ListTile(
                title: const Text('Оформление и тема'),
                subtitle: Text(provider.themeMode == ThemeMode.dark ? 'Тёмная' : 'Светлая'),
                onTap: () {
                  // TODO: Theme selection
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Выберите тему'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: const Text('Светлая'),
                            onTap: () {
                              provider.setThemeMode(ThemeMode.light);
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            title: const Text('Тёмная'),
                            onTap: () {
                              provider.setThemeMode(ThemeMode.dark);
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            title: const Text('Как в системе'),
                            onTap: () {
                              provider.setThemeMode(ThemeMode.system);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Язык'),
                subtitle: const Text('Русский'),
                onTap: () {
                  // TODO: Language selection
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Выберите язык'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: const Text('Русский'),
                            onTap: () {
                              provider.setLocale(const Locale('ru'));
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            title: const Text('English'),
                            onTap: () {
                              provider.setLocale(const Locale('en'));
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              // Logout
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Вы действительно хотите выйти?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Отмена'),
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: Logout logic
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Logged out')),
                            );
                          },
                          child: const Text('Выйти'),
                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Выйти'),
              ),
            ],
          ),
        );
      },
    );
  }
}