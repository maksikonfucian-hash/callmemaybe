import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/home_screen.dart';
import 'providers/app_provider.dart';
import 'services/webrtc_service.dart';
import 'services/livekit_service.dart';
import 'package:contacts/contacts.dart';

/// Точка входа приложения Call Me Maybe
/// 
/// Инициализирует необходимые сервисы и запускает приложение
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyApp());
}

/// Главный виджет приложения
/// 
/// Настраивает провайдеры, темы и локализацию
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Провайдер настроек приложения
        ChangeNotifierProvider(create: (_) => AppProvider()),
        
        // Провайдер контактов
        ChangeNotifierProvider(create: (_) => ContactsProvider()),
        
        // Провайдер WebRTC для P2P звонков
        ChangeNotifierProvider(create: (_) => WebRTCService()),
        
        // Провайдер LiveKit для SFU fallback
        ChangeNotifierProvider(create: (_) => LiveKitService()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, provider, child) => MaterialApp(
          title: 'Call Me Maybe',
          debugShowCheckedModeBanner: false,
          
          // Светлая тема
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF007AFF),
              primary: const Color(0xFF007AFF),
            ),
            scaffoldBackgroundColor: const Color(0xFFF2F2F7),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Тёмная тема
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF007AFF),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          
          themeMode: provider.themeMode,
          locale: provider.locale,
          
          // Делегаты локализации
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          
          // Поддерживаемые языки
          supportedLocales: const [
            Locale('ru', ''),
            Locale('en', ''),
          ],
          
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
