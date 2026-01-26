import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';

import '../services/webrtc_service.dart';

/// Экран активного звонка
/// 
/// Отображает видео локального и удалённого пользователей,
/// а также элементы управления звонком (mute, camera, hangup)
class ActiveCallScreen extends StatefulWidget {
  /// ID собеседника
  final String peerId;
  
  /// Имя собеседника для отображения
  final String peerName;
  
  /// Входящий звонок (true) или исходящий (false)
  final bool isIncoming;
  
  /// SDP offer для входящего звонка
  final Map<String, dynamic>? incomingOffer;

  const ActiveCallScreen({
    super.key,
    required this.peerId,
    required this.peerName,
    this.isIncoming = false,
    this.incomingOffer,
  });

  @override
  State<ActiveCallScreen> createState() => _ActiveCallScreenState();
}

class _ActiveCallScreenState extends State<ActiveCallScreen> {
  late WebRTCService _webrtcService;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _webrtcService = context.read<WebRTCService>();
    _initializeCall();
  }

  /// Инициализирует звонок
  Future<void> _initializeCall() async {
    await _webrtcService.initialize();
    
    if (widget.isIncoming && widget.incomingOffer != null) {
      await _webrtcService.answerCall(
        peerId: widget.peerId,
        offerSdp: widget.incomingOffer!,
      );
    } else {
      await _webrtcService.startCall(peerId: widget.peerId);
    }
    
    setState(() => _isInitialized = true);
  }

  /// Завершает звонок и возвращается назад
  Future<void> _endCall() async {
    await _webrtcService.endCall();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<WebRTCService>(
        builder: (context, service, child) {
          return Stack(
            children: [
              _buildRemoteVideo(service),
              _buildLocalVideoPreview(service),
              _buildCallStatus(service),
              _buildControlPanel(service),
            ],
          );
        },
      ),
    );
  }

  /// Виджет удалённого видео
  Widget _buildRemoteVideo(WebRTCService service) {
    if (service.state != WebRTCCallState.connected) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade800,
              child: Text(
                widget.peerName.isNotEmpty ? widget.peerName[0].toUpperCase() : '?',
                style: const TextStyle(fontSize: 48, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.peerName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return RTCVideoView(
      service.remoteRenderer,
      objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
    );
  }

  /// Превью локального видео
  Widget _buildLocalVideoPreview(WebRTCService service) {
    if (!_isInitialized || !service.isCameraEnabled) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      right: 16,
      child: GestureDetector(
        onTap: () => service.switchCamera(),
        child: Container(
          width: 120,
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white, width: 2),
          ),
          clipBehavior: Clip.hardEdge,
          child: RTCVideoView(
            service.localRenderer,
            mirror: true,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          ),
        ),
      ),
    );
  }

  /// Статус звонка
  Widget _buildCallStatus(WebRTCService service) {
    String statusText;
    switch (service.state) {
      case WebRTCCallState.connecting:
        statusText = 'Подключение...';
        break;
      case WebRTCCallState.ringing:
        statusText = widget.isIncoming ? 'Входящий звонок...' : 'Вызов...';
        break;
      case WebRTCCallState.connected:
        statusText = 'Соединено';
        break;
      case WebRTCCallState.reconnecting:
        statusText = 'Переподключение...';
        break;
      case WebRTCCallState.failed:
        statusText = 'Ошибка соединения';
        break;
      default:
        statusText = '';
    }

    if (statusText.isEmpty) return const SizedBox.shrink();

    return Positioned(
      top: MediaQuery.of(context).padding.top + 80,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            statusText,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }

  /// Панель управления звонком
  Widget _buildControlPanel(WebRTCService service) {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 40,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: service.isCameraEnabled ? Icons.videocam : Icons.videocam_off,
            label: 'Камера',
            isActive: service.isCameraEnabled,
            onTap: () => service.toggleCamera(),
          ),
          _buildControlButton(
            icon: service.isMicEnabled ? Icons.mic : Icons.mic_off,
            label: 'Микрофон',
            isActive: service.isMicEnabled,
            onTap: () => service.toggleMic(),
          ),
          _buildControlButton(
            icon: Icons.call_end,
            label: 'Завершить',
            backgroundColor: Colors.red,
            onTap: _endCall,
          ),
          _buildControlButton(
            icon: Icons.cameraswitch,
            label: 'Камера',
            onTap: () => service.switchCamera(),
          ),
        ],
      ),
    );
  }

  /// Кнопка управления
  Widget _buildControlButton({
    required IconData icon,
    required String label,
    bool isActive = true,
    Color? backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: backgroundColor ?? (isActive ? Colors.white24 : Colors.white),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: backgroundColor != null ? Colors.white : (isActive ? Colors.white : Colors.black),
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
