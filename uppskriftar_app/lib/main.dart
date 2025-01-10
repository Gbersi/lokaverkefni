import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './screens/tabs.dart';
import './utils/hive_setup.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './utils/localization.dart';

final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
final languageProvider = StateProvider<String>((ref) => 'en');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Error handling for debugging
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  try {
    // Initialize Hive and other services
    await initializeHive();

    // Run the app in the main zone
    runApp(const ProviderScope(child: MyApp()));
  } catch (error, stackTrace) {
    print('Initialization Error: $error\nStackTrace: $stackTrace');
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final currentLanguage = ref.watch(languageProvider);

    return MaterialApp(
      title: 'Your Recipes App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: themeMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizationDelegate(), // Custom localization delegate
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('es', ''), // Spanish
        Locale('fr', ''), // French
        Locale('de', ''), // German
        Locale('is', ''), // Icelandic
      ],
      locale: Locale(currentLanguage),
      home: const TabsScreen(availableMeals: []),
    );
  }
}
