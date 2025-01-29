import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_animations_updates.dart';
import '../services/theme_notifier.dart';


class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _tips = [
    {
      'title': 'Bæta við Leikmönnum',
      'content': 'Byrjaðu á því að skrá niður nöfnin á öllum sem taka þátt í leiknum.',
      'icon': Icons.group,
      'hint': 'notaðu mismunandi nöfn til að fylgjast betur með stigagjöfinni.',
    },
    {
      'title': 'Velja Leiki ',
      'content': 'Veldu úr leikjunum á listanum þá leiki sem þið viljið spila.',
      'icon': Icons.games,
      'hint': 'þú getur filterað leikina á listanum eftir erfiðleikastigi eða fjölda Leikmanna.',
    },
    {
      'title': 'Stilla Lotur ',
      'content': 'ákveðið hversu margar lotur af mismunandi leikjum þið viljið spila.',
      'icon': Icons.repeat,
      'hint': 'fáar lotur virka best fyrir stutt spilakvöld!',
    },
    {
      'title': 'Fylgstu með stigunum',
      'content': 'Forritið fylgist með stigunum og sigrunum hjá Leikmönnum en leikmenn þurfa að skrá niður stigin sjálfir eftir hvern leik.',
      'icon': Icons.score,
      'hint': 'þú getur heimsótt upplýsingar síðuna til að sjá nánari upplýsingar um leikmenn og stig .',
    },
    {
      'title': 'Tilbúin að spila?',
      'content': 'Byrjaðu fyrsta Leikinn þinn og njóttu með vinum og fjölskyldu!',
      'icon': Icons.play_arrow,
      'hint': 'Hafið gaman og megi besti leikmaðurinn sigra!',
    },
  ];

  void _nextPage() {
    if (_currentPage < _tips.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage++);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final BoxDecoration backgroundGradient = themeNotifier.isDarkTheme
        ? AppThemes.darkBackgroundGradient
        : themeNotifier.isCustomTheme
        ? AppThemes.customBackgroundGradient
        : AppThemes.lightBackgroundGradient;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Velkomin í Spilakvöld!'),
      ),
      body: Container(
        decoration: backgroundGradient,
        child: PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _tips.length,
          itemBuilder: (context, index) {
            return _buildPage(
              title: _tips[index]['title'],
              content: _tips[index]['content'],
              icon: _tips[index]['icon'],
              hint: _tips[index]['hint'],
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _nextPage,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            backgroundColor: Colors.greenAccent,
          ),
          child: Text(
            _currentPage < _tips.length - 1 ? 'Næsta' : 'Byrjum!',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String content,
    required IconData icon,
    required String hint,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: Colors.blue),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            hint,
            style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
