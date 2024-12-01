class Game {
  final String name;
  final String explanation;
  final String image;

  Game({required this.name, required this.explanation, required this.image});

  static List<Game> getMiniGames() {
    return [
      Game(
        name: 'Charades',
        explanation: 'One player acts out a word or phrase without speaking, and others guess it!',
        image: 'assets/charades.png',
      ),
      Game(
        name: 'Treasure Hunt',
        explanation: 'Hide an item and give clues to find it, either indoors or outdoors.',
        image: 'assets/treasure_hunt.png',
      ),
      Game(
        name: 'Simon Says',
        explanation: 'Players follow the leader’s commands only when prefixed with "Simon says."',
        image: 'assets/simon_says.png',
      ),
      Game(
        name: 'Rock Paper Scissors',
        explanation: 'A quick hand game where Rock beats Scissors, Scissors beats Paper, and Paper beats Rock.',
        image: 'assets/rock_paper_scissors.png',
      ),
      Game(
        name: 'Memory Game',
        explanation: 'Lay out cards face down. Players take turns flipping over two cards to find matches.',
        image: 'assets/memory_game.png',
      ),
      Game(
        name: 'Drawing Challenge',
        explanation: 'One player draws an object, and the others try to guess what it is.',
        image: 'assets/drawing_challenge.png',
      ),
    ];
  }
}
