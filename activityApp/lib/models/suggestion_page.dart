import 'package:flutter/material.dart';

class SuggestionPage extends StatelessWidget {
  final String playerName;
  final List<String> suggestions;
  final VoidCallback onDone;

  const SuggestionPage({
    required this.playerName,
    required this.suggestions,
    required this.onDone,
    super.key,
  });

  static final List<String> pictionarySuggestions = [
    "A cat", "A dog", "A house", "A car", "A tree", "A beach", "A rocket",
    "A boat", "A robot", "A mountain", "A horse", "A bike", "A lion",
    "A tiger", "A bird", "A flower", "A sun", "A star", "A planet", "A fish",
    "A butterfly", "A train", "A phone", "A camera", "A cloud", "A river",
    "A football", "A basketball", "A clock", "A piano", "A guitar",
    "A unicorn", "A dragon", "A wizard", "A fairy", "A castle", "A king",
    "A queen", "A knight", "A monster", "A dinosaur", "A genie", "A candle",
    "A campfire", "A spaceship", "A bridge", "A ladder", "A computer",
    "A rainbow", "A book", "A treehouse"
  ];

  static final List<String> charadesSuggestions = [
    "Dancing", "Swimming", "Cooking", "Singing", "Running", "Cycling",
    "Fishing", "Sleeping", "Driving", "Flying", "Walking", "Jumping",
    "Climbing", "Typing", "Painting", "Cleaning", "Shopping", "Hunting",
    "Crying", "Laughing", "Sneezing", "Yawning", "Hiking", "Boxing",
    "Skating", "Skiing", "Surfing", "Rowing", "Bowling", "Throwing",
    "Catching", "Riding a horse", "Riding a bike", "Reading", "Writing",
    "Tying shoes", "Stretching", "Falling", "Balancing", "Snoring",
    "Waving", "Texting", "Eating", "Drinking", "Brushing teeth",
    "Washing hands", "Praying", "Knocking", "Knitting", "Dancing ballet"
  ];

  @override
  Widget build(BuildContext context) {
    final randomSuggestions = (List.from(suggestions)..shuffle()).take(5).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('$playerName\'s Suggestions'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.grey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Here are your suggestions:',
                style:  TextStyle(color: Colors.white, fontSize: 22),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: randomSuggestions.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.grey[800],
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      elevation: 3,
                      child: ListTile(
                        title: Text(
                          randomSuggestions[index],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: onDone,
                  child: const Text('Back to Game'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
