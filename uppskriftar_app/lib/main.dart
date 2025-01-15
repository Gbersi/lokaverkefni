import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/tabs.dart';
import './utils/hive_setup.dart';
import './utils/localization.dart';

final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
final languageProvider = StateProvider<String>((ref) => 'en');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  final prefs = await SharedPreferences.getInstance();
  final initialLanguage = prefs.getString('language') ?? 'en';


  await initializeHive();


  runApp(
    ProviderScope(
      overrides: [
        languageProvider.overrideWith((ref) => initialLanguage),
      ],
      child: const MyApp(),
    ),
  );
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
        AppLocalizationDelegate(),
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

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final currentLanguage = ref.watch(languageProvider);
        final languageNotifier = ref.read(languageProvider.notifier);

        return DropdownButton<String>(
          value: currentLanguage,
          items: const [
            DropdownMenuItem(value: 'en', child: Text('English')),
            DropdownMenuItem(value: 'es', child: Text('Español')),
            DropdownMenuItem(value: 'fr', child: Text('Français')),
            DropdownMenuItem(value: 'de', child: Text('Deutsch')),
            DropdownMenuItem(value: 'is', child: Text('Íslenska')),
          ],
          onChanged: (String? newLanguage) async {
            if (newLanguage != null) {
              languageNotifier.state = newLanguage;
              final prefs = await SharedPreferences.getInstance();
              prefs.setString('language', newLanguage);
            }
          },
        );
      },
    );
  }
}
