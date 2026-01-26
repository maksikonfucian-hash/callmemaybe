import 'package:flutter_test/flutter_test.dart';
import 'package:core/entities/user.dart';

void main() {
  group('User', () {
    test('создаёт пользователя с корректными данными', () {
      final user = User(
        id: '123',
        name: 'Иван Петров',
        photoUrl: 'https://example.com/avatar.jpg',
      );

      expect(user.id, '123');
      expect(user.name, 'Иван Петров');
      expect(user.photoUrl, 'https://example.com/avatar.jpg');
    });

    test('создаёт пользователя без аватара', () {
      const user = User(
        id: '456',
        name: 'Анна',
      );

      expect(user.id, '456');
      expect(user.name, 'Анна');
      expect(user.photoUrl, isNull);
    });

    test('isOnline по умолчанию false', () {
      const user = User(
        id: '123',
        name: 'Иван',
      );

      expect(user.isOnline, false);
    });

    test('lastSeen по умолчанию null', () {
      const user = User(
        id: '123',
        name: 'Иван',
      );

      expect(user.lastSeen, isNull);
    });

    test('создаёт онлайн пользователя', () {
      const user = User(
        id: '123',
        name: 'Иван',
        isOnline: true,
      );

      expect(user.isOnline, true);
    });

    test('сравнение двух одинаковых пользователей', () {
      const user1 = User(id: '123', name: 'Иван');
      const user2 = User(id: '123', name: 'Иван');

      expect(user1, equals(user2));
    });

    test('разные пользователи не равны', () {
      const user1 = User(id: '123', name: 'Иван');
      const user2 = User(id: '456', name: 'Пётр');

      expect(user1, isNot(equals(user2)));
    });

    test('props содержит все поля', () {
      final now = DateTime.now();
      final user = User(
        id: '123',
        name: 'Иван',
        photoUrl: 'https://example.com',
        isOnline: true,
        lastSeen: now,
      );

      expect(user.props, contains('123'));
      expect(user.props, contains('Иван'));
      expect(user.props, contains('https://example.com'));
      expect(user.props, contains(true));
      expect(user.props, contains(now));
    });
  });
}
