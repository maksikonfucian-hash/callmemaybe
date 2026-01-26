# Call Me Maybe

Flutter MVP для 1-на-1 аудио/видео звонков с WebRTC Mesh P2P и LiveKit SFU fallback.

## Обзор проекта

Monorepo Flutter приложение с поддержкой видео/аудио звонков. Использует Clean Architecture + MVVM паттерн с модульной структурой через Melos.

## Структура проекта

```
├── apps/
│   └── mobile/                    # Основное Flutter приложение
│       ├── lib/
│       │   ├── main.dart          # Точка входа
│       │   ├── screens/           # UI экраны
│       │   │   ├── home_screen.dart
│       │   │   ├── settings_tab.dart
│       │   │   └── active_call_screen.dart
│       │   ├── providers/         # Провайдеры состояния
│       │   │   └── app_provider.dart
│       │   └── services/          # Сервисы приложения
│       │       ├── webrtc_service.dart   # WebRTC P2P
│       │       ├── livekit_service.dart  # LiveKit SFU
│       │       └── supabase_service.dart # Supabase backend
│       └── build/web/             # Собранное веб-приложение
├── packages/
│   ├── core/                      # Общие сущности и ошибки
│   │   ├── entities/user.dart
│   │   └── failures/failure.dart
│   ├── signaling/                 # WebRTC сигнализация
│   │   ├── models/signaling_message.dart
│   │   └── repositories/signaling_repository.dart
│   ├── webrtc_engine/             # WebRTC интеграция
│   └── contacts/                  # Модуль контактов
├── js/webrtc/                     # JavaScript WebRTC логика
└── melos.yaml                     # Конфигурация monorepo
```

## Технологический стек

- **Framework**: Flutter 3.32.0 / Dart 3.8.0
- **State Management**: Provider
- **WebRTC**: flutter_webrtc + LiveKit client
- **Архитектура**: Clean Architecture + MVVM
- **Error Handling**: fpdart (Either pattern)
- **Backend**: Supabase (Realtime для сигнализации)
- **Локализация**: ru/en через flutter_localizations

## Функциональность

### Режимы звонков
- **P2P Mesh** (по умолчанию) - прямое WebRTC соединение
- **LiveKit SFU** - через медиа-сервер для лучшей стабильности

### Настройки
- Тема: светлая/тёмная/системная
- Язык: русский/английский
- Качество видео: низкое (320p) / среднее (480p) / высокое (720p)
- Уведомления: вкл/выкл

### Экраны
- Друзья - список контактов
- Звонки - история вызовов
- Настройки - персонализация
- Активный звонок - видео с контролами

## Запуск приложения

### Веб (разработка)
```bash
cd apps/mobile
flutter pub get
flutter build web --base-href "/"
cd build/web && python3 -m http.server 5000 --bind 0.0.0.0
```

### Сборка и тесты
```bash
# Зависимости
cd apps/mobile && flutter pub get

# Сборка веб
flutter build web --release

# Анализ кода
flutter analyze

# Тесты
flutter test
```

## Зависимости

### Основные
- `livekit_client` - LiveKit SFU клиент
- `flutter_webrtc` - WebRTC для Flutter
- `provider` - State management
- `fpdart` - Функциональное программирование
- `supabase_flutter` - Supabase SDK
- `shared_preferences` - Локальное хранилище

### Для разработки
- `json_annotation` / `json_serializable` - JSON сериализация
- `build_runner` - Кодогенерация
- `equatable` - Сравнение объектов

## Окружение

- Dart SDK: ^3.8.0
- Flutter: 3.32.0
- Платформы: Web, iOS, Android, Linux, macOS, Windows

## Важные решения

1. **fpdart Either** - все сервисы возвращают Either<Failure, T> для обработки ошибок
2. **Supabase Realtime** - используется для сигнализации вместо отдельного WebSocket сервера
3. **Анонимная аутентификация** - для MVP без необходимости регистрации
4. **Комментарии на русском** - dartdoc документация на русском языке

## Последние изменения

- 2026-01-26: Добавлены WebRTC и LiveKit сервисы
- 2026-01-26: Обновлены настройки с режимом звонков и качеством видео
- 2026-01-26: Исправлены конфликты импортов User между core и supabase
- 2026-01-26: Добавлены unit-тесты для core и signaling модулей
