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
      'title': 'Add Players',
      'content': 'Start by adding the names of all the players who will participate.',
      'icon': Icons.group,
      'hint': 'Use unique names to track scores accurately.',
    },
    {
      'title': 'Select Games',
      'content': 'Choose the games you want to play from the available list.',
      'icon': Icons.games,
      'hint': 'You can filter games by difficulty or number of players.',
    },
    {
      'title': 'Set Rounds',
      'content': 'Decide how many rounds you want to play for this session.',
      'icon': Icons.repeat,
      'hint': 'Short sessions work great for a quick game night!',
    },
    {
      'title': 'Track Your Scores',
      'content': 'The app will automatically track scores for each player.',
      'icon': Icons.score,
      'hint': 'Visit the dashboard to see the leaderboard and stats.',
    },
    {
      'title': 'Achievements',
      'content': 'Earn rewards for high scores, streaks, and other milestones.',
      'icon': Icons.emoji_events,
      'hint': 'Try to beat the highest single game score in the dashboard!',
    },
    {
      'title': 'Ready to Play?',
      'content': 'Start your game session and enjoy with friends and family!',
      'icon': Icons.play_arrow,
      'hint': 'Have fun and let the best player win!',
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
        title: const Text('Welcome to Activity App!'),
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
            _currentPage < _tips.length - 1 ? 'Next' : 'Get Started!',
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
