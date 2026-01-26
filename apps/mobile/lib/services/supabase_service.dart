import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:fpdart/fpdart.dart';
import 'package:core/core.dart';

/// Сервис для работы с Supabase
/// 
/// Предоставляет инициализацию и доступ к клиенту Supabase
/// для работы с базой данных, аутентификацией и Realtime
class SupabaseService {
  static SupabaseService? _instance;
  
  /// Singleton экземпляр сервиса
  static SupabaseService get instance {
    _instance ??= SupabaseService._();
    return _instance!;
  }

  SupabaseService._();

  /// Клиент Supabase
  supabase.SupabaseClient get client => supabase.Supabase.instance.client;

  /// Текущий пользователь Supabase
  supabase.User? get currentUser => client.auth.currentUser;

  /// Проверяет авторизован ли пользователь
  bool get isAuthenticated => currentUser != null;

  /// Инициализирует Supabase
  /// 
  /// [url] - URL проекта Supabase
  /// [anonKey] - анонимный ключ проекта
  static Future<Either<Failure, void>> initialize({
    required String url,
    required String anonKey,
  }) async {
    try {
      await supabase.Supabase.initialize(
        url: url,
        anonKey: anonKey,
        authOptions: const supabase.FlutterAuthClientOptions(
          authFlowType: supabase.AuthFlowType.pkce,
        ),
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Ошибка инициализации Supabase: $e'));
    }
  }

  /// Анонимный вход (для MVP без аккаунтов)
  /// 
  /// Генерирует уникальный ID устройства и сохраняет его
  Future<Either<Failure, String>> signInAnonymously() async {
    try {
      final response = await client.auth.signInAnonymously();
      if (response.user != null) {
        return Right(response.user!.id);
      }
      return const Left(ServerFailure('Не удалось создать анонимного пользователя'));
    } catch (e) {
      return Left(ServerFailure('Ошибка анонимного входа: $e'));
    }
  }

  /// Выход из аккаунта
  Future<Either<Failure, void>> signOut() async {
    try {
      await client.auth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Ошибка выхода: $e'));
    }
  }

  /// Подписывается на канал Realtime для сигнализации
  /// 
  /// [channelName] - имя канала
  /// [onMessage] - callback для входящих сообщений
  supabase.RealtimeChannel subscribeToChannel(
    String channelName, {
    required void Function(Map<String, dynamic>) onMessage,
  }) {
    return client.channel(channelName).onBroadcast(
      event: 'signaling',
      callback: (payload) => onMessage(payload),
    ).subscribe();
  }

  /// Отправляет сообщение в канал Realtime
  /// 
  /// [channel] - канал для отправки
  /// [data] - данные сообщения
  Future<Either<Failure, void>> sendToChannel(
    supabase.RealtimeChannel channel,
    Map<String, dynamic> data,
  ) async {
    try {
      await channel.sendBroadcastMessage(
        event: 'signaling',
        payload: data,
      );
      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure('Ошибка отправки сообщения: $e'));
    }
  }
}
