/// Пакет сигнализации для WebRTC
/// 
/// Обеспечивает обмен SDP offer/answer и ICE кандидатами
/// между пирами через Supabase Realtime.
/// 
/// Основные компоненты:
/// - [SignalingMessage] - модель сигнального сообщения
/// - [SignalingRepository] - репозиторий для работы с сигнализацией
/// - [SupabaseSignalingRepository] - реализация через Supabase
library signaling;

/// Репозитории для работы с сигнализацией
export 'repositories/signaling_repository.dart';

/// Модели данных для сигнальных сообщений
export 'models/signaling_message.dart';