// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signaling_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignalingMessage _$SignalingMessageFromJson(Map<String, dynamic> json) =>
    SignalingMessage(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      type: $enumDecode(_$SignalingTypeEnumMap, json['type']),
      payload: json['payload'] as Map<String, dynamic>,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$SignalingMessageToJson(SignalingMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'type': _$SignalingTypeEnumMap[instance.type]!,
      'payload': instance.payload,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$SignalingTypeEnumMap = {
  SignalingType.offer: 'offer',
  SignalingType.answer: 'answer',
  SignalingType.candidate: 'candidate',
  SignalingType.hangup: 'hangup',
};
