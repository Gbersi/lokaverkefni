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
  static final List<String> hangmanSuggestions = [
    "Apple", "Banana", "Orange", "Grape", "Car", "House", "Cat", "Dog",
    "Lion", "Tiger", "Bird", "Fish", "Sun", "Moon", "Star", "Tree",
    "Flower", "Chair", "Table", "Ball", "Book", "Clock", "Piano",
    "Drum", "Shark", "Whale", "Bear", "Frog", "Horse", "Cow", "Pig",
    "Duck", "Goat", "Fox", "Rabbit", "Snake", "Elephant", "Zebra",
    "Kite", "Plane", "Train", "Bus", "Boat", "Rocket", "River",
    "Beach", "Mountain", "Castle", "Crown", "Queen", "King", "Knight",
    "Unicorn", "Dragon", "Robot", "Laptop", "Phone", "Camera",
    "Rainbow", "Cloud", "Snowman", "Cookie", "Cake", "Pizza", "Burger",
    "Milk", "Ice Cream", "Jelly", "Panda", "Monkey", "Penguin",
    "Balloon", "Ladder", "Bridge", "Campfire", "Flashlight", "Tent",
    "Treasure", "Dinosaur", "Wand", "Genie", "Volcano", "Butterfly",
    "Ladybug", "Cupcake", "Lemon", "Giraffe", "Carrot", "Cactus",
    "Peach", "Chalk", "Telescope", "Snail", "Sailboat", "Helmet",
    "Compass", "Bicycle", "Drumstick", "Guitar", "Basket", "Chocolate"
  ];

  static final List<String> pictionarySuggestions = [
    "A cat", "A dog", "A house", "A car", "A tree", "A beach", "A rocket",
    "A boat", "A robot", "A mountain", "A horse", "A bike", "A lion",
    "A tiger", "A bird", "A flower", "A sun", "A star", "A planet", "A fish",
    "A butterfly", "A train", "A phone", "A camera", "A cloud", "A river",
    "A football", "A basketball", "A clock", "A piano", "A guitar",
    "A unicorn", "A dragon", "A wizard", "A fairy", "A castle", "A king",
    "A queen", "A knight", "A monster", "A dinosaur", "A genie", "A candle",
    "A campfire", "A spaceship", "A bridge", "A ladder", "A computer",
    "A rainbow", "A book", "A treehouse", "A smiley face", "A cupcake",
    "A cookie", "A whale", "A shark", "An airplane", "A helicopter",
    "A snowman", "A pirate ship", "A basketball hoop", "A teddy bear",
    "A kite", "A drum", "A soccer ball", "A swimming pool", "A burger",
    "A pizza", "A donut", "A milkshake", "A roller coaster", "A tent",
    "A flashlight", "A treasure chest", "A cactus", "An ice cream cone",
    "A camera", "A pair of sunglasses", "A chocolate bar", "A hammer",
    "A backpack", "A rainbow fish", "A windmill", "A sailboat", "A snail",
    "A moon", "A watermelon slice", "A tree swing", "A birdhouse",
    "A panda", "A kangaroo", "A penguin", "A basketball court",
    "A volcano", "A crocodile", "A cupcake with sprinkles", "A picnic basket",
    "A snowflake", "A cherry blossom tree", "A magic wand", "A stopwatch",
    "A treasure map", "A diving mask", "A spaceship landing on the moon",
    "A chocolate cake", "A teddy bear holding balloons", "A zebra",
    "A lighthouse", "A sailboat on the ocean", "A traffic light",
    "A pair of flip-flops", "A lemonade stand", "A carnival ride",
    "A telescope", "A frog on a lily pad", "A parrot on a branch",
    "A snow-covered tree", "A kangaroo with a baby in its pouch"
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
    "Washing hands", "Praying", "Knocking", "Knitting", "Dancing ballet",
    "Hopping on one foot", "Pretending to be a cat", "Pretending to be a dog",
    "Pretending to be a chicken", "Pretending to be a monkey", "Skipping",
    "Playing basketball", "Playing soccer", "Swinging on a swing",
    "Sliding down a slide", "Driving a race car", "Flying like a bird",
    "Rowing a boat", "Juggling", "Milking a cow", "Pretending to be a robot",
    "Marching", "Doing jumping jacks", "Spinning in circles", "Acting shy",
    "Pretending to catch a fish", "Pretending to play the drums",
    "Pretending to play guitar", "Pretending to bake cookies", "Digging",
    "Pretending to shoot an arrow", "Pretending to water plants",
    "Pretending to pick flowers", "Pretending to plant a tree",
    "Pretending to throw a frisbee", "Pretending to walk a dog",
    "Pretending to hula hoop", "Pretending to eat spaghetti",
    "Pretending to play video games", "Pretending to be a statue",
    "Pretending to shoot a basketball", "Pretending to skateboard",
    "Pretending to be a frog", "Pretending to climb a ladder",
    "Pretending to blow out candles", "Pretending to open a gift",
    "Pretending to carry a heavy box", "Pretending to clean a window",
    "Pretending to play soccer", "Pretending to jump over a puddle",
    "Pretending to pet a dog", "Pretending to feed a baby", "Pretending to fly a kite",
    "Pretending to ice skate", "Pretending to catch a butterfly",
    "Pretending to deliver a pizza", "Pretending to swim underwater",
    "Pretending to throw a snowball", "Pretending to shovel snow",
    "Pretending to wave from a ship", "Pretending to take a selfie",
    "Pretending to tie a bowtie", "Pretending to comb your hair"
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
