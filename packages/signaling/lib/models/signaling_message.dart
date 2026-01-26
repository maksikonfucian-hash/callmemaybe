import 'package:json_annotation/json_annotation.dart';

part 'signaling_message.g.dart';

/// Типы сигнальных сообщений для WebRTC
/// [offer] - предложение соединения
/// [answer] - ответ на предложение
/// [candidate] - ICE кандидат для установки соединения
/// [hangup] - завершение звонка
enum SignalingType {
  @JsonValue('offer')
  offer,
  @JsonValue('answer')
  answer,
  @JsonValue('candidate')
  candidate,
  @JsonValue('hangup')
  hangup,
}

/// Модель сигнального сообщения для WebRTC
/// Используется для обмена SDP и ICE кандидатами между пирами
@JsonSerializable()
class SignalingMessage {
  /// Уникальный идентификатор сообщения
  final String id;

  /// ID отправителя сообщения
  final String senderId;

  /// ID получателя сообщения
  final String receiverId;

  /// Тип сигнального сообщения
  final SignalingType type;

  /// Полезная нагрузка (SDP или ICE candidate)
  final Map<String, dynamic> payload;

  /// Временная метка создания
  final DateTime timestamp;

  const SignalingMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.type,
    required this.payload,
    required this.timestamp,
  });

  /// Создаёт объект из JSON
  factory SignalingMessage.fromJson(Map<String, dynamic> json) =>
      _$SignalingMessageFromJson(json);

  /// Преобразует объект в JSON
  Map<String, dynamic> toJson() => _$SignalingMessageToJson(this);

  /// Создаёт offer сообщение
  factory SignalingMessage.offer({
    required String senderId,
    required String receiverId,
    required Map<String, dynamic> sdp,
  }) {
    return SignalingMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: senderId,
      receiverId: receiverId,
      type: SignalingType.offer,
      payload: sdp,
      timestamp: DateTime.now(),
    );
  }

  /// Создаёт answer сообщение
  factory SignalingMessage.answer({
    required String senderId,
    required String receiverId,
    required Map<String, dynamic> sdp,
  }) {
    return SignalingMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: senderId,
      receiverId: receiverId,
      type: SignalingType.answer,
      payload: sdp,
      timestamp: DateTime.now(),
    );
  }

  /// Создаёт candidate сообщение
  factory SignalingMessage.candidate({
    required String senderId,
    required String receiverId,
    required Map<String, dynamic> candidate,
  }) {
    return SignalingMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: senderId,
      receiverId: receiverId,
      type: SignalingType.candidate,
      payload: candidate,
      timestamp: DateTime.now(),
    );
  }

  /// Создаёт hangup сообщение
  factory SignalingMessage.hangup({
    required String senderId,
    required String receiverId,
  }) {
    return SignalingMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: senderId,
      receiverId: receiverId,
      type: SignalingType.hangup,
      payload: {},
      timestamp: DateTime.now(),
    );
  }
}
