
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Velkomin í Spilakvöld!'),
      ),
      body: PageView(
        children: [
          _buildPage(
            title: 'Bæta við Spilara',
            content: 'Byrjaðu á að skrá nöfnin á öllum leikmönnum sem munu spila.',
            icon: Icons.group,
            hint: 'notaðu mismunandi nöfn til að geta fylgst betur með stigunum.',
          ),
          _buildPage(
            title: 'Velja Leik',
            content: 'Veldu Leikina sem þú villt spila frá listanum.',
            icon: Icons.games,
            hint: 'Þú getur flokkað leikina eftir erfiðleikastigi eða fjölda spilara.',
          ),
          _buildPage(
            title: 'Stilltu Lotur',
            content: 'Veldu hversu margar lotur þú villt spila í einum leik',
            icon: Icons.repeat,
            hint: 'Fáar lotur virka best fyrir stutta leiki!',
          ),
          _buildPage(
            title: 'fylgstu með Stigum',
            content: 'Forritið tekur niður sjálfkrafa stigafjölda spilara.',
            icon: Icons.score,
            hint: 'Kíktu á Upplýsinga síðuna til að sjá stigafjölda og upplýsingar um leikmenn.',
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
            'Byrjum að spila!',
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
