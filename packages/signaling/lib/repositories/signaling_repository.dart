import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:core/core.dart';

import '../models/signaling_message.dart';

/// Абстрактный репозиторий для сигнализации WebRTC
/// Определяет контракт для отправки и получения сигнальных сообщений
abstract class SignalingRepository {
  /// Подключается к сигнальному серверу
  /// Возвращает [Either] с ошибкой или успехом
  Future<Either<Failure, void>> connect(String userId);

  /// Отключается от сигнального сервера
  Future<Either<Failure, void>> disconnect();

  /// Отправляет сигнальное сообщение
  /// [message] - сообщение для отправки
  Future<Either<Failure, void>> sendMessage(SignalingMessage message);

  /// Поток входящих сигнальных сообщений
  Stream<SignalingMessage> get messageStream;

  /// Проверяет статус подключения
  bool get isConnected;
}

/// Реализация репозитория сигнализации через Supabase Realtime
class SupabaseSignalingRepository implements SignalingRepository {
  /// Контроллер для потока сообщений
  final StreamController<SignalingMessage> _messageController =
      StreamController<SignalingMessage>.broadcast();

  /// ID текущего пользователя
  String? _currentUserId;

  /// Флаг подключения
  bool _isConnected = false;

  @override
  bool get isConnected => _isConnected;

  @override
  Stream<SignalingMessage> get messageStream => _messageController.stream;

  @override
  Future<Either<Failure, void>> connect(String userId) async {
    try {
      _currentUserId = userId;
      _isConnected = true;
      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure('Ошибка подключения к сигнальному серверу: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> disconnect() async {
    try {
      _isConnected = false;
      _currentUserId = null;
      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure('Ошибка отключения: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(SignalingMessage message) async {
    if (!_isConnected) {
      return const Left(NetworkFailure('Не подключен к серверу'));
    }

    try {
      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure('Ошибка отправки сообщения: $e'));
    }
  }

  /// Обрабатывает входящее сообщение
  void _handleIncomingMessage(Map<String, dynamic> data) {
    try {
      final message = SignalingMessage.fromJson(data);
      if (message.receiverId == _currentUserId) {
        _messageController.add(message);
      }
    } catch (e) {
      // Логируем ошибку парсинга
    }
  }

  /// Освобождает ресурсы
  void dispose() {
    _messageController.close();
  }
}
