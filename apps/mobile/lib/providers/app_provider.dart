import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Режим звонков: P2P mesh или SFU через LiveKit
enum CallMode {
  /// P2P mesh соединение (по умолчанию)
  mesh,
  /// SFU через LiveKit сервер
  livekit,
}

/// Качество видео для звонков
enum VideoQuality {
  /// Низкое качество (320x240)
  low,
  /// Среднее качество (640x480)
  medium,
  /// Высокое качество (1280x720)
  high,
}

/// Провайдер глобального состояния приложения
/// 
/// Управляет настройками темы, языка, качества видео и режима звонков
class AppProvider extends ChangeNotifier {
  /// Текущий режим темы
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  /// Текущая локаль
  Locale _locale = const Locale('ru');
  Locale get locale => _locale;

  /// Режим звонков (mesh или LiveKit)
  CallMode _callMode = CallMode.mesh;
  CallMode get callMode => _callMode;

  /// Качество видео
  VideoQuality _videoQuality = VideoQuality.medium;
  VideoQuality get videoQuality => _videoQuality;

  /// Включены ли уведомления
  bool _notificationsEnabled = true;
  bool get notificationsEnabled => _notificationsEnabled;

  /// ID текущего пользователя
  String? _userId;
  String? get userId => _userId;

  /// Конструктор - загружает сохранённые настройки
  AppProvider() {
    _loadSettings();
  }

  /// Загружает настройки из SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Загрузка темы
    final themeIndex = prefs.getInt('themeMode') ?? 0;
    _themeMode = ThemeMode.values[themeIndex];
    
    // Загрузка языка
    final langCode = prefs.getString('locale') ?? 'ru';
    _locale = Locale(langCode);
    
    // Загрузка режима звонков
    final callModeIndex = prefs.getInt('callMode') ?? 0;
    _callMode = CallMode.values[callModeIndex];
    
    // Загрузка качества видео
    final qualityIndex = prefs.getInt('videoQuality') ?? 1;
    _videoQuality = VideoQuality.values[qualityIndex];
    
    // Загрузка уведомлений
    _notificationsEnabled = prefs.getBool('notifications') ?? true;
    
    // Загрузка ID пользователя
    _userId = prefs.getString('userId');
    
    notifyListeners();
  }

  /// Сохраняет настройку в SharedPreferences
  Future<void> _savePreference(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    }
  }

  /// Устанавливает режим темы
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _savePreference('themeMode', mode.index);
    notifyListeners();
  }

  /// Устанавливает локаль
  void setLocale(Locale locale) {
    _locale = locale;
    _savePreference('locale', locale.languageCode);
    notifyListeners();
  }

  /// Устанавливает режим звонков
  void setCallMode(CallMode mode) {
    _callMode = mode;
    _savePreference('callMode', mode.index);
    notifyListeners();
  }

  /// Устанавливает качество видео
  void setVideoQuality(VideoQuality quality) {
    _videoQuality = quality;
    _savePreference('videoQuality', quality.index);
    notifyListeners();
  }

  /// Переключает уведомления
  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
    _savePreference('notifications', _notificationsEnabled);
    notifyListeners();
  }

  /// Устанавливает ID пользователя
  void setUserId(String? id) {
    _userId = id;
    if (id != null) {
      _savePreference('userId', id);
    }
    notifyListeners();
  }
}
