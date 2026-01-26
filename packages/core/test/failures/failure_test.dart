import 'package:flutter_test/flutter_test.dart';
import 'package:core/failures/failure.dart';

void main() {
  group('Failure', () {
    group('NetworkFailure', () {
      test('создаётся с сообщением', () {
        const failure = NetworkFailure('Нет подключения к интернету');

        expect(failure.message, 'Нет подключения к интернету');
      });

      test('props содержит сообщение', () {
        const failure = NetworkFailure('Timeout');

        expect(failure.props, contains('Timeout'));
      });
    });

    group('ServerFailure', () {
      test('создаётся с сообщением', () {
        const failure = ServerFailure('Ошибка сервера 500');

        expect(failure.message, 'Ошибка сервера 500');
      });

      test('сравнение двух одинаковых ошибок', () {
        const failure1 = ServerFailure('Ошибка');
        const failure2 = ServerFailure('Ошибка');

        expect(failure1, equals(failure2));
      });
    });

    group('CacheFailure', () {
      test('создаётся с сообщением', () {
        const failure = CacheFailure('Кэш повреждён');

        expect(failure.message, 'Кэш повреждён');
      });
    });

    group('PermissionFailure', () {
      test('создаётся с сообщением', () {
        const failure = PermissionFailure('Нет доступа к камере');

        expect(failure.message, 'Нет доступа к камере');
      });
    });

    group('WebRTCFailure', () {
      test('создаётся с сообщением', () {
        const failure = WebRTCFailure('Ошибка ICE соединения');

        expect(failure.message, 'Ошибка ICE соединения');
      });

      test('используется для WebRTC ошибок', () {
        const failure = WebRTCFailure('Не удалось получить медиа');

        expect(failure, isA<Failure>());
        expect(failure.message, contains('медиа'));
      });

      test('разные ошибки не равны', () {
        const failure1 = WebRTCFailure('Ошибка 1');
        const failure2 = WebRTCFailure('Ошибка 2');

        expect(failure1, isNot(equals(failure2)));
      });
    });
  });
}
