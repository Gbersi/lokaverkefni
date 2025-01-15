
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Activity App!'),
      ),
      body: PageView(
        children: [
          _buildPage(
            title: 'Add Players',
            content: 'Start by adding the names of all the players who will participate.',
            icon: Icons.group,
            hint: 'Use unique names to track scores accurately.',
          ),
          _buildPage(
            title: 'Select Games',
            content: 'Choose the games you want to play from the available list.',
            icon: Icons.games,
            hint: 'You can filter games by difficulty or number of players.',
          ),
          _buildPage(
            title: 'Set Rounds',
            content: 'Decide how many rounds you want to play for this session.',
            icon: Icons.repeat,
            hint: 'Short sessions work great for a quick game night!',
          ),
          _buildPage(
            title: 'Track Your Scores',
            content: 'The app will automatically track scores for each player.',
            icon: Icons.score,
            hint: 'Visit the dashboard to see the leaderboard and stats.',
          ),
          _buildPage(
            title: 'Achievements',
            content: 'Earn rewards for high scores, streaks, and other milestones.',
            icon: Icons.emoji_events,
            hint: 'Try to beat the highest single game score in the dashboard!',
          ),
          _buildPage(
            title: 'Ready to Play?',
            content: 'Start your game session and enjoy with friends and family!',
            icon: Icons.play_arrow,
            hint: 'Have fun and let the best player win!',
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            backgroundColor: Colors.greenAccent,
          ),
          child: const Text(
            'Get Started!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
