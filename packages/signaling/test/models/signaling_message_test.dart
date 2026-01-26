import 'package:flutter_test/flutter_test.dart';
import 'package:signaling/models/signaling_message.dart';

void main() {
  group('SignalingMessage', () {
    test('создаёт сообщение с корректными данными', () {
      final message = SignalingMessage(
        id: '123',
        type: SignalingType.offer,
        senderId: 'user1',
        receiverId: 'user2',
        payload: {'sdp': 'test_sdp'},
        timestamp: DateTime(2024, 1, 1),
      );

      expect(message.id, '123');
      expect(message.type, SignalingType.offer);
      expect(message.senderId, 'user1');
      expect(message.receiverId, 'user2');
      expect(message.payload['sdp'], 'test_sdp');
    });

    test('offer factory создаёт корректное сообщение', () {
      final message = SignalingMessage.offer(
        senderId: 'user1',
        receiverId: 'user2',
        sdp: {'sdp': 'offer_sdp', 'type': 'offer'},
      );

      expect(message.type, SignalingType.offer);
      expect(message.senderId, 'user1');
      expect(message.receiverId, 'user2');
      expect(message.id, isNotEmpty);
      expect(message.timestamp, isNotNull);
    });

    test('answer factory создаёт корректное сообщение', () {
      final message = SignalingMessage.answer(
        senderId: 'user2',
        receiverId: 'user1',
        sdp: {'sdp': 'answer_sdp', 'type': 'answer'},
      );

      expect(message.type, SignalingType.answer);
      expect(message.senderId, 'user2');
    });

    test('candidate factory создаёт ICE candidate сообщение', () {
      final message = SignalingMessage.candidate(
        senderId: 'user1',
        receiverId: 'user2',
        candidate: {
          'candidate': 'candidate_string',
          'sdpMid': 'audio',
          'sdpMLineIndex': 0,
        },
      );

      expect(message.type, SignalingType.candidate);
      expect(message.payload['candidate'], 'candidate_string');
      expect(message.payload['sdpMid'], 'audio');
    });

    test('hangup factory создаёт пустой payload', () {
      final message = SignalingMessage.hangup(
        senderId: 'user1',
        receiverId: 'user2',
      );

      expect(message.type, SignalingType.hangup);
      expect(message.payload, isEmpty);
    });
  });

  group('SignalingType', () {
    test('offer', () {
      expect(SignalingType.offer.name, 'offer');
    });

    test('answer', () {
      expect(SignalingType.answer.name, 'answer');
    });

    test('candidate', () {
      expect(SignalingType.candidate.name, 'candidate');
    });

    test('hangup', () {
      expect(SignalingType.hangup.name, 'hangup');
    });
  });
}
