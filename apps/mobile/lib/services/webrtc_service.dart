import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:core/core.dart';
import 'package:signaling/signaling.dart';

/// Конфигурация ICE серверов для WebRTC
/// 
/// Включает STUN серверы Google и опционально TURN для NAT traversal
class IceServerConfig {
  /// Список ICE серверов по умолчанию
  static const List<Map<String, dynamic>> defaultServers = [
    {'urls': 'stun:stun.l.google.com:19302'},
    {'urls': 'stun:stun1.l.google.com:19302'},
    {'urls': 'stun:stun2.l.google.com:19302'},
  ];

  /// Добавляет TURN сервер в конфигурацию
  static List<Map<String, dynamic>> withTurn({
    required String url,
    required String username,
    required String credential,
  }) {
    return [
      ...defaultServers,
      {
        'urls': url,
        'username': username,
        'credential': credential,
      },
    ];
  }
}

/// Ограничения качества видео для стабильности соединения
class VideoQualityConstraints {
  final int width;
  final int height;
  final int frameRate;

  const VideoQualityConstraints({
    required this.width,
    required this.height,
    required this.frameRate,
  });

  /// Низкое качество (для слабого соединения)
  static const low = VideoQualityConstraints(width: 320, height: 240, frameRate: 15);
  
  /// Среднее качество (по умолчанию)
  static const medium = VideoQualityConstraints(width: 640, height: 480, frameRate: 24);
  
  /// Высокое качество
  static const high = VideoQualityConstraints(width: 1280, height: 720, frameRate: 30);

  Map<String, dynamic> toConstraints() => {
    'width': width,
    'height': height,
    'frameRate': frameRate,
  };
}

/// Состояние WebRTC звонка
enum WebRTCCallState {
  idle,
  connecting,
  ringing,
  connected,
  reconnecting,
  ended,
  failed,
}

/// Сервис для управления WebRTC соединениями
/// 
/// Реализует P2P mesh соединение с поддержкой:
/// - Множественных ICE серверов с fallback на TURN
/// - Ограничения качества видео
/// - Переключения между аудио/видео
class WebRTCService extends ChangeNotifier {
  /// Локальный рендерер для превью камеры
  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  
  /// Удалённый рендерер для видео собеседника
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  
  /// Текущее состояние звонка
  WebRTCCallState _state = WebRTCCallState.idle;
  WebRTCCallState get state => _state;

  /// Peer connection для WebRTC
  RTCPeerConnection? _peerConnection;
  
  /// Локальный медиа-поток
  MediaStream? _localStream;
  
  /// Удалённый медиа-поток
  MediaStream? _remoteStream;

  /// Флаг включённого микрофона
  bool _isMicEnabled = true;
  bool get isMicEnabled => _isMicEnabled;

  /// Флаг включённой камеры
  bool _isCameraEnabled = true;
  bool get isCameraEnabled => _isCameraEnabled;

  /// Текущие ограничения качества
  VideoQualityConstraints _quality = VideoQualityConstraints.medium;

  /// Репозиторий сигнализации
  final SupabaseSignalingRepository _signaling = SupabaseSignalingRepository();

  /// ID текущего пользователя
  String? _userId;

  /// ID собеседника
  String? _peerId;

  /// Инициализирует рендереры
  Future<void> initialize() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
  }

  /// Освобождает ресурсы
  @override
  void dispose() {
    _cleanup();
    localRenderer.dispose();
    remoteRenderer.dispose();
    super.dispose();
  }

  /// Устанавливает ID пользователя и подключается к сигнализации
  Future<Either<Failure, void>> connect(String userId) async {
    _userId = userId;
    final result = await _signaling.connect(userId);
    
    if (result.isRight()) {
      _signaling.messageStream.listen(_handleSignalingMessage);
    }
    
    return result;
  }

  /// Начинает исходящий звонок
  /// 
  /// [peerId] - ID собеседника
  /// [isVideo] - видеозвонок или аудио
  Future<Either<Failure, void>> startCall({
    required String peerId,
    bool isVideo = true,
  }) async {
    try {
      _peerId = peerId;
      _setState(WebRTCCallState.connecting);

      // Получаем локальный медиа-поток
      await _getUserMedia(isVideo: isVideo);

      // Создаём peer connection
      await _createPeerConnection();

      // Добавляем локальные треки
      _localStream?.getTracks().forEach((track) {
        _peerConnection?.addTrack(track, _localStream!);
      });

      // Создаём и отправляем offer
      final offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);

      await _signaling.sendMessage(SignalingMessage.offer(
        senderId: _userId!,
        receiverId: peerId,
        sdp: offer.toMap(),
      ));

      _setState(WebRTCCallState.ringing);
      return const Right(null);
    } catch (e) {
      _setState(WebRTCCallState.failed);
      return Left(WebRTCFailure('Ошибка начала звонка: $e'));
    }
  }

  /// Принимает входящий звонок
  Future<Either<Failure, void>> answerCall({
    required String peerId,
    required Map<String, dynamic> offerSdp,
    bool isVideo = true,
  }) async {
    try {
      _peerId = peerId;
      _setState(WebRTCCallState.connecting);

      await _getUserMedia(isVideo: isVideo);
      await _createPeerConnection();

      _localStream?.getTracks().forEach((track) {
        _peerConnection?.addTrack(track, _localStream!);
      });

      // Устанавливаем remote description из offer
      await _peerConnection!.setRemoteDescription(
        RTCSessionDescription(offerSdp['sdp'], offerSdp['type']),
      );

      // Создаём и отправляем answer
      final answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);

      await _signaling.sendMessage(SignalingMessage.answer(
        senderId: _userId!,
        receiverId: peerId,
        sdp: answer.toMap(),
      ));

      _setState(WebRTCCallState.connected);
      return const Right(null);
    } catch (e) {
      _setState(WebRTCCallState.failed);
      return Left(WebRTCFailure('Ошибка принятия звонка: $e'));
    }
  }

  /// Завершает звонок
  Future<void> endCall() async {
    if (_peerId != null && _userId != null) {
      await _signaling.sendMessage(SignalingMessage.hangup(
        senderId: _userId!,
        receiverId: _peerId!,
      ));
    }
    await _cleanup();
    _setState(WebRTCCallState.ended);
  }

  /// Переключает микрофон
  void toggleMic() {
    _isMicEnabled = !_isMicEnabled;
    _localStream?.getAudioTracks().forEach((track) {
      track.enabled = _isMicEnabled;
    });
    notifyListeners();
  }

  /// Переключает камеру
  void toggleCamera() {
    _isCameraEnabled = !_isCameraEnabled;
    _localStream?.getVideoTracks().forEach((track) {
      track.enabled = _isCameraEnabled;
    });
    notifyListeners();
  }

  /// Переключает на фронтальную/заднюю камеру
  Future<void> switchCamera() async {
    final videoTrack = _localStream?.getVideoTracks().first;
    if (videoTrack != null) {
      await Helper.switchCamera(videoTrack);
    }
  }

  /// Устанавливает качество видео
  Future<void> setVideoQuality(VideoQualityConstraints quality) async {
    _quality = quality;
    if (_localStream != null && _isCameraEnabled) {
      await _getUserMedia(isVideo: true);
    }
  }

  /// Обрабатывает входящее сигнальное сообщение
  void _handleSignalingMessage(SignalingMessage message) async {
    switch (message.type) {
      case SignalingType.offer:
        // Уведомляем UI о входящем звонке
        _peerId = message.senderId;
        _setState(WebRTCCallState.ringing);
        break;

      case SignalingType.answer:
        await _peerConnection?.setRemoteDescription(
          RTCSessionDescription(
            message.payload['sdp'],
            message.payload['type'],
          ),
        );
        _setState(WebRTCCallState.connected);
        break;

      case SignalingType.candidate:
        await _peerConnection?.addCandidate(
          RTCIceCandidate(
            message.payload['candidate'],
            message.payload['sdpMid'],
            message.payload['sdpMLineIndex'],
          ),
        );
        break;

      case SignalingType.hangup:
        await _cleanup();
        _setState(WebRTCCallState.ended);
        break;
    }
  }

  /// Получает локальный медиа-поток
  Future<void> _getUserMedia({required bool isVideo}) async {
    final constraints = {
      'audio': true,
      'video': isVideo ? _quality.toConstraints() : false,
    };

    _localStream = await navigator.mediaDevices.getUserMedia(constraints);
    localRenderer.srcObject = _localStream;
  }

  /// Создаёт peer connection
  Future<void> _createPeerConnection() async {
    final config = {
      'iceServers': IceServerConfig.defaultServers,
      'sdpSemantics': 'unified-plan',
    };

    _peerConnection = await createPeerConnection(config);

    // Обработка ICE кандидатов
    _peerConnection!.onIceCandidate = (candidate) {
      if (_peerId != null && _userId != null) {
        _signaling.sendMessage(SignalingMessage.candidate(
          senderId: _userId!,
          receiverId: _peerId!,
          candidate: candidate.toMap(),
        ));
      }
    };

    // Обработка состояния соединения
    _peerConnection!.onConnectionState = (state) {
      switch (state) {
        case RTCPeerConnectionState.RTCPeerConnectionStateConnected:
          _setState(WebRTCCallState.connected);
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateDisconnected:
          _setState(WebRTCCallState.reconnecting);
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateFailed:
          _setState(WebRTCCallState.failed);
          break;
        default:
          break;
      }
    };

    // Обработка входящего трека
    _peerConnection!.onTrack = (event) {
      if (event.streams.isNotEmpty) {
        _remoteStream = event.streams.first;
        remoteRenderer.srcObject = _remoteStream;
        notifyListeners();
      }
    };
  }

  /// Очищает ресурсы соединения
  Future<void> _cleanup() async {
    _localStream?.getTracks().forEach((track) => track.stop());
    _localStream?.dispose();
    _localStream = null;

    _remoteStream?.getTracks().forEach((track) => track.stop());
    _remoteStream?.dispose();
    _remoteStream = null;

    await _peerConnection?.close();
    _peerConnection = null;

    localRenderer.srcObject = null;
    remoteRenderer.srcObject = null;

    _peerId = null;
  }

  /// Устанавливает состояние звонка
  void _setState(WebRTCCallState newState) {
    _state = newState;
    notifyListeners();
  }
}
