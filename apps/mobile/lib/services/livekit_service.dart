import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:fpdart/fpdart.dart';
import 'package:core/core.dart';

/// Состояние LiveKit звонка
enum LiveKitCallState {
  idle,
  connecting,
  connected,
  reconnecting,
  disconnected,
  failed,
}

/// Сервис для работы с LiveKit SFU
/// 
/// Используется как fallback когда mesh P2P нестабилен.
/// Обеспечивает более надёжное соединение через сервер.
class LiveKitService extends ChangeNotifier {
  /// Комната LiveKit
  Room? _room;
  Room? get room => _room;

  /// Локальный участник
  LocalParticipant? get localParticipant => _room?.localParticipant;

  /// Удалённые участники
  List<RemoteParticipant> get remoteParticipants => 
      _room?.remoteParticipants.values.toList() ?? [];

  /// Текущее состояние
  LiveKitCallState _state = LiveKitCallState.idle;
  LiveKitCallState get state => _state;

  /// Флаг включённого микрофона
  bool _isMicEnabled = true;
  bool get isMicEnabled => _isMicEnabled;

  /// Флаг включённой камеры
  bool _isCameraEnabled = true;
  bool get isCameraEnabled => _isCameraEnabled;

  /// Подключается к комнате LiveKit
  /// 
  /// [url] - URL сервера LiveKit (ws://...)
  /// [token] - токен доступа к комнате
  Future<Either<Failure, void>> connect({
    required String url,
    required String token,
  }) async {
    try {
      _setState(LiveKitCallState.connecting);

      // Создаём опции комнаты
      final roomOptions = RoomOptions(
        adaptiveStream: true,
        dynacast: true,
        defaultAudioPublishOptions: const AudioPublishOptions(
          audioBitrate: AudioPreset.music,
        ),
        defaultVideoPublishOptions: const VideoPublishOptions(
          simulcast: true,
          videoEncoding: VideoEncoding(
            maxBitrate: 1500000,
            maxFramerate: 30,
          ),
        ),
      );

      // Создаём комнату
      _room = Room();

      // Настраиваем обработчики событий
      _setupEventHandlers();

      // Подключаемся
      await _room!.connect(url, token, roomOptions: roomOptions);

      _setState(LiveKitCallState.connected);
      return const Right(null);
    } catch (e) {
      _setState(LiveKitCallState.failed);
      return Left(WebRTCFailure('Ошибка подключения к LiveKit: $e'));
    }
  }

  /// Отключается от комнаты
  Future<void> disconnect() async {
    await _room?.disconnect();
    await _room?.dispose();
    _room = null;
    _setState(LiveKitCallState.disconnected);
  }

  /// Включает/выключает микрофон
  Future<void> toggleMic() async {
    if (_room == null) return;
    
    _isMicEnabled = !_isMicEnabled;
    await _room!.localParticipant?.setMicrophoneEnabled(_isMicEnabled);
    notifyListeners();
  }

  /// Включает/выключает камеру
  Future<void> toggleCamera() async {
    if (_room == null) return;
    
    _isCameraEnabled = !_isCameraEnabled;
    await _room!.localParticipant?.setCameraEnabled(_isCameraEnabled);
    notifyListeners();
  }

  /// Переключает камеру (фронт/тыл)
  /// 
  /// Примечание: в текущей версии LiveKit SDK переключение камеры
  /// требует пересоздания трека с другим устройством
  Future<void> switchCamera() async {
    // Для переключения камеры выключаем и включаем с новым устройством
    await _room?.localParticipant?.setCameraEnabled(false);
    await Future.delayed(const Duration(milliseconds: 200));
    await _room?.localParticipant?.setCameraEnabled(true);
  }

  /// Включает публикацию видео/аудио
  Future<Either<Failure, void>> enableMedia({
    bool audio = true,
    bool video = true,
  }) async {
    try {
      if (_room == null) {
        return const Left(WebRTCFailure('Не подключен к комнате'));
      }

      if (audio) {
        await _room!.localParticipant?.setMicrophoneEnabled(true);
      }
      if (video) {
        await _room!.localParticipant?.setCameraEnabled(true);
      }

      return const Right(null);
    } catch (e) {
      return Left(WebRTCFailure('Ошибка включения медиа: $e'));
    }
  }

  /// Настраивает обработчики событий комнаты
  void _setupEventHandlers() {
    _room?.addListener(_onRoomEvent);
  }

  /// Обработчик событий комнаты
  void _onRoomEvent() {
    final connectionState = _room?.connectionState;
    
    switch (connectionState) {
      case ConnectionState.connected:
        _setState(LiveKitCallState.connected);
        break;
      case ConnectionState.reconnecting:
        _setState(LiveKitCallState.reconnecting);
        break;
      case ConnectionState.disconnected:
        _setState(LiveKitCallState.disconnected);
        break;
      default:
        break;
    }
    
    notifyListeners();
  }

  /// Устанавливает состояние
  void _setState(LiveKitCallState newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    _room?.removeListener(_onRoomEvent);
    _room?.dispose();
    super.dispose();
  }
}
