import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';

/// Экран настроек приложения
/// 
/// Позволяет управлять профилем, темой, языком,
/// уведомлениями и настройками звонков
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
              
              // Профиль пользователя
              _buildProfileSection(provider),
              
              const SizedBox(height: 30),
              _buildSectionTitle('Основные'),
              const SizedBox(height: 10),
              
              // Уведомления
              _buildSettingItem(
                title: 'Уведомления и звуки',
                trailing: Switch.adaptive(
                  value: provider.notificationsEnabled,
                  onChanged: (v) => provider.toggleNotifications(),
                  activeColor: Colors.green,
                ),
              ),
              
              // Тема
              _buildSettingItem(
                title: 'Оформление и тема',
                value: _getThemeName(provider.themeMode),
                onTap: () => _showThemeDialog(context, provider),
              ),
              
              // Язык
              _buildSettingItem(
                title: 'Язык',
                value: provider.locale.languageCode == 'ru' ? 'Русский' : 'English',
                onTap: () => _showLanguageDialog(context, provider),
              ),
              
              const SizedBox(height: 30),
              _buildSectionTitle('Звонки'),
              const SizedBox(height: 10),
              
              // Режим звонков (Mesh / LiveKit)
              _buildSettingItem(
                title: 'Режим соединения',
                value: provider.callMode == CallMode.mesh ? 'P2P Mesh' : 'LiveKit SFU',
                onTap: () => _showCallModeDialog(context, provider),
              ),
              
              // Качество видео
              _buildSettingItem(
                title: 'Качество видео',
                value: _getQualityName(provider.videoQuality),
                onTap: () => _showVideoQualityDialog(context, provider),
              ),
              
              const SizedBox(height: 30),
              _buildSectionTitle('Информация'),
              const SizedBox(height: 10),
              
              // ID пользователя
              if (provider.userId != null)
                _buildSettingItem(
                  title: 'Ваш ID',
                  value: provider.userId!.substring(0, 8) + '...',
                  trailing: IconButton(
                    icon: const Icon(Icons.copy, size: 20),
                    onPressed: () {
                      // Копирование ID в буфер
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ID скопирован')),
                      );
                    },
                  ),
                ),
              
              // Версия
              _buildSettingItem(
                title: 'Версия',
                value: '1.0.0',
              ),
              
              const SizedBox(height: 40),
              
              // Кнопка выхода
              SizedBox(
                width: double.infinity,
                height: 56,
                child: TextButton(
                  onPressed: () => _showLogoutConfirmation(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Выйти',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              
              const SizedBox(height: 100),
            ],
          ),
        );
      },
    );
  }

  /// Секция профиля пользователя
  Widget _buildProfileSection(AppProvider provider) {
    return Column(
      children: [
        // Аватар
        Stack(
          children: [
            const CircleAvatar(
              radius: 45,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Имя
        const Text(
          'Пользователь',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        
        // ID
        Text(
          provider.userId != null 
              ? 'ID: ${provider.userId!.substring(0, 8)}...'
              : 'Анонимный пользователь',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  /// Заголовок секции
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.grey,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// Элемент настройки
  Widget _buildSettingItem({
    required String title,
    String? value,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
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
            if (value != null)
              Text(value, style: const TextStyle(color: Colors.grey)),
            if (onTap != null)
              const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  /// Получает название темы
  String _getThemeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Светлая';
      case ThemeMode.dark:
        return 'Тёмная';
      case ThemeMode.system:
        return 'Системная';
    }
  }

  /// Получает название качества видео
  String _getQualityName(VideoQuality quality) {
    switch (quality) {
      case VideoQuality.low:
        return 'Низкое (320p)';
      case VideoQuality.medium:
        return 'Среднее (480p)';
      case VideoQuality.high:
        return 'Высокое (720p)';
    }
  }

  /// Диалог выбора темы
  void _showThemeDialog(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Выберите тему'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogOption(
              'Светлая',
              provider.themeMode == ThemeMode.light,
              () {
                provider.setThemeMode(ThemeMode.light);
                Navigator.pop(context);
              },
            ),
            _buildDialogOption(
              'Тёмная',
              provider.themeMode == ThemeMode.dark,
              () {
                provider.setThemeMode(ThemeMode.dark);
                Navigator.pop(context);
              },
            ),
            _buildDialogOption(
              'Системная',
              provider.themeMode == ThemeMode.system,
              () {
                provider.setThemeMode(ThemeMode.system);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Диалог выбора языка
  void _showLanguageDialog(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Выберите язык'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogOption(
              'Русский',
              provider.locale.languageCode == 'ru',
              () {
                provider.setLocale(const Locale('ru'));
                Navigator.pop(context);
              },
            ),
            _buildDialogOption(
              'English',
              provider.locale.languageCode == 'en',
              () {
                provider.setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Диалог выбора режима звонков
  void _showCallModeDialog(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Режим соединения'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'P2P Mesh - прямое соединение между устройствами.\n'
              'LiveKit SFU - через сервер (стабильнее).',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            _buildDialogOption(
              'P2P Mesh (по умолчанию)',
              provider.callMode == CallMode.mesh,
              () {
                provider.setCallMode(CallMode.mesh);
                Navigator.pop(context);
              },
            ),
            _buildDialogOption(
              'LiveKit SFU',
              provider.callMode == CallMode.livekit,
              () {
                provider.setCallMode(CallMode.livekit);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Диалог выбора качества видео
  void _showVideoQualityDialog(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Качество видео'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Низкое качество экономит трафик и батарею.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            _buildDialogOption(
              'Низкое (320p)',
              provider.videoQuality == VideoQuality.low,
              () {
                provider.setVideoQuality(VideoQuality.low);
                Navigator.pop(context);
              },
            ),
            _buildDialogOption(
              'Среднее (480p)',
              provider.videoQuality == VideoQuality.medium,
              () {
                provider.setVideoQuality(VideoQuality.medium);
                Navigator.pop(context);
              },
            ),
            _buildDialogOption(
              'Высокое (720p)',
              provider.videoQuality == VideoQuality.high,
              () {
                provider.setVideoQuality(VideoQuality.high);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Подтверждение выхода
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Выход'),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Логика выхода
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
  }

  /// Опция в диалоге
  Widget _buildDialogOption(String title, bool isSelected, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      trailing: isSelected 
          ? const Icon(Icons.check, color: Colors.blue) 
          : null,
      onTap: onTap,
    );
  }
}
