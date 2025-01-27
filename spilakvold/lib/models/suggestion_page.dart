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
    "Epli", "Banani", "Appelsína", "Vínber", "Bíll", "Hús", "Köttur", "Hundur",
    "Ljón", "Tígrisdýr", "Fugl", "Fiskur", "Sól", "Tungl", "Stjarna", "Tré",
    "Blóm", "Stóll", "Borð", "Bolti", "Bók", "Klukka", "Píanó",
    "Tromma", "Hákarl", "Hvalur", "Björn", "Froskur", "Hestur", "Kýr", "Svín",
    "Önd", "Geit", "Refur", "Kanína", "Slanga", "Fíll", "Prinsessa",
    "Flugdrek", "Flugvél", "Lest", "Rúta", "Bátur", "Eldflaug", "Á",
    "Strönd", "Fjall", "Kastali", "Kóróna", "Drottning", "Konungur", "Riddari",
    "Einhyrningur", "Dreki", "Vélmenni", "Fartölva", "Sími", "Myndavél",
    "Regnbogi", "Ský", "Snjókarl", "Smákaka", "Kaka", "Pizza", "Hamborgari",
    "Mjólk", "Ís", "Hlaup", "Panda", "Api", "Mörgæs",
    "Blaðra", "Stigi", "Brú", "Bál", "Vasaljós", "Tjald",
    "Fjársjóður", "Risaeðla", "Stafur", "Andi", "Eldfjall", "Fiðrildi",
    "Maríuhæna", "Bollakaka", "Sítróna", "Gíraffi", "Gulrót", "Kaktus",
    "Ferskja", "Krít", "Sjónauki", "Snigill", "Seglbátur", "Hjálmur",
    "Áttaviti", "Reiðhjól", "Trommukjuði", "Gítar", "Karfa", "Súkkulaði","Fjall"
  ];

  static final List<String> pictionarySuggestions = [
    "Köttur", "Hundur", "Hús", "Bíll", "Tré", "Strönd", "Eldflaug",
    "Bátur", "Vélmenni", "Fjall", "Hestur", "Reiðhjól", "Ljón",
    "Tígrisdýr", "Fugl", "Blóm", "Sól", "Stjarna", "Pláneta", "Fiskur",
    "Fiðrildi", "Lest", "Sími", "Myndavél", "Ský", "Á",
    "Fótbolti", "Körfubolti", "Klukka", "Píanó", "Gítar",
    "Einhyrningur", "Dreki", "Töframaður", "Álfkona", "Kastali", "Konungur",
    "Drottning", "Riddari", "Skrímsli", "Risaeðla", "Andi", "Kerti",
    "Bál", "Geimskip", "Brú", "Stigi", "Tölva",
    "Regnbogi", "Bók", "Tréhús", "Broskarl", "Bollakaka",
    "Smákaka", "Hvalur", "Hákarl", "Flugvél", "Þyrla",
    "Snjókarl", "Sjóræningjaskip", "Körfuboltahringur", "Bangsi",
    "Flugdrek", "Tromma", "Fótbolti", "Sundlaug", "Hamborgari",
    "Pizza", "Kleina", "Mjólkurhristingur", "Rússíbani", "Tjald",
    "Vasaljós", "Fjársjóðskista", "Kaktus", "Ís",
    "Myndavél", "Sólgleraugu", "Súkkulaðistykki", "Hamar",
    "Bakpoki", "Regnbogafiskur", "Vindmylla", "Seglbátur", "Snigill",
    "Tungl", "Vatnsmelóna", "Trésveif", "Fuglahús",
    "Panda", "Kengúra", "Mörgæs", "Körfuboltavöllur",
    "Eldfjall", "Krókódíll", "Bollakaka með stráum", "karfa",
    "Snjókorn", "Kirsuberjatré", "Töfrastafur", "klukka",
    "Fjársjóðskort", "Köfunargríma", "Geimskip sem lendir á tunglinu",
    "Súkkulaðikaka", "Bangsi með blöðrum", "Sebri",
    "Viti", "Seglbátur á hafinu", "Umferðarljós",
    "sandalar", "Límonaðisölubás", "Skráargat",
    "Sjónauki", "Froskur", "Páfagaukur",
    "Snjóþakið tré", "Kengúra"
  ];


  static final List<String> charadesSuggestions = [
    "Dansa", "Synda", "Elda", "Syngja", "Hlaupa", "Hjóla",
    "Veiða", "Sofa", "Keyra", "Fljúga", "Ganga", "Stökkva",
    "Klifra", "Slá inn texta", "Mála", "Þrífa", "Versla", "Veiða",
    "Grenja", "Hlæja", "Hnerra", "Geispa", "Fara í gönguferð", "Boxa",
    "Skauta", "Skíða", "Brimreiða", "Róa", "Keila", "Kasta",
    "Grípa", "Ríða hesti", "Hjóla", "Lesa", "Skrifa",
    "Binda skó", "Teigja sig", "Falla", "Halda jafnvægi", "Hrjóta",
    "Vinka", "Senda skilaboð", "Borða", "Drekka", "Bursta tennur",
    "Þvo hendur", "Biðja", "Banka", "Prjóna", "Dansa ballett",
    "Hoppa á einum fæti", "Þykjast vera köttur", "Þykjast vera hundur",
    "Þykjast vera kjúklingur", "Þykjast vera api", "Skoppa",
    "Spila körfubolta", "Spila fótbolta", "Róla sér",
    "Renna sér niður rennibraut", "Keyra kappakstursbíl", "Fljúga eins og fugl",
    "Róa bát", "Jöggla", "Mjólka kú", "Þykjast vera vélmenni",
    "Marsera", "Stökkva á staðnum", "Snúast í hringi", "Þykjast vera feimin",
    "Þykjast veiða fisk", "Þykjast spila á trommur",
    "Þykjast spila á gítar", "Þykjast baka smákökur", "Grafa",
    "Þykjast skjóta ör", "Þykjast vökva plöntur",
    "Þykjast tína blóm", "Þykjast planta tré",
    "Þykjast kasta frisbí", "Þykjast ganga með hund",
    "Þykjast snúa húlahring", "Þykjast borða spaghettí",
    "Þykjast spila tölvuleiki", "Þykjast vera stytta",
    "Þykjast skjóta körfubolta", "Þykjast vera á hjólabretti",
    "Þykjast vera froskur", "Þykjast klifra stiga",
    "Þykjast blása á kerti", "Þykjast opna gjöf",
    "Þykjast bera þunga kassa", "Þykjast þrífa glugga",
    "Þykjast spila fótbolta", "Þykjast hoppa yfir poll",
    "Þykjast strjúka hund", "Þykjast gefa barni að borða", "Þykjast fljúga flugdrek",
    "Þykjast vera á skautum", "Þykjast veiða fiðrildi",
    "Þykjast afhenda pizzu", "Þykjast kafa undir vatni",
    "Þykjast kasta snjóbolta", "Þykjast moka snjó",
    "Þykjast veifa frá skipi", "Þykjast taka sjálfsmynd",
    "Þykjast binda slaufu", "Þykjast greiða hárið"
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
                'Hérna eru uppástungur:',
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
                  child: const Text('Aftur í Leikinn'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
