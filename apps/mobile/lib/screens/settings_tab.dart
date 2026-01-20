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
          appBar: AppBar(
            title: const Text('Настройки'),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const SizedBox(height: 20),
              const Center(
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Cameron Williamson',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                '(406) 555-0120',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              const Text(
                'Settings',
                style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              _buildSettingItem(
                title: 'Уведомления и звуки',
                trailing: Switch.adaptive(
                  value: true,
                  onChanged: (v) {},
                  activeColor: Colors.green,
                ),
              ),
              _buildSettingItem(
                title: 'Оформление и тема',
                value: provider.themeMode == ThemeMode.dark ? 'Тёмная' : 'Светлая',
                onTap: () => _showThemeDialog(context, provider),
              ),
              _buildSettingItem(
                title: 'Язык',
                value: provider.locale.languageCode == 'ru' ? 'Русский' : 'English',
                onTap: () => _showLanguageDialog(context, provider),
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Выйти', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 100), // Space for bottom bar
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingItem({required String title, String? value, Widget? trailing, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 15)),
        trailing: trailing ?? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (value != null) Text(value, style: const TextStyle(color: Colors.grey)),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  void _showThemeDialog(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выберите тему'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: const Text('Светлая'), onTap: () { provider.setThemeMode(ThemeMode.light); Navigator.pop(context); }),
            ListTile(title: const Text('Тёмная'), onTap: () { provider.setThemeMode(ThemeMode.dark); Navigator.pop(context); }),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выберите язык'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: const Text('Русский'), onTap: () { provider.setLocale(const Locale('ru')); Navigator.pop(context); }),
            ListTile(title: const Text('English'), onTap: () { provider.setLocale(const Locale('en')); Navigator.pop(context); }),
          ],
        ),
      ),
    );
  }
}
