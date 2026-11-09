// Import Dart's math library to generate random numbers.
import 'dart:math';

// Import english_words to generate random word combinations.
import 'package:english_words/english_words.dart';

// Import Flutter's Material Design widgets and system services.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Import Provider for application-wide state management.
import 'package:provider/provider.dart';

// Import Google Fonts to use different font styles.
import 'package:google_fonts/google_fonts.dart';

// The entry point of the Flutter application.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Enable edge-to-edge support for modern Android status and navigation bars.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const Namer());
}

// Root widget of the application.
class Namer extends StatelessWidget {
  const Namer({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NamerState(),
      child: MaterialApp(
        title: 'Namer App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueGrey,
            brightness: Brightness.light,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueGrey,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.system,
        home: const HomePage(),
      ),
    );
  }
}

// Manages the application's data and business logic.
class NamerState extends ChangeNotifier {
  // Generate an initial random word pair when the app starts.
  var current = WordPair.random();

  // List of fonts that users can switch between.
  final List<String> fonts = [
    'Pacifico',
    'Roboto Mono',
    'Cinzel',
    'Bungee',
    'Montserrat',
  ];

  // The font currently being used.
  var currentFont = 'Pacifico';

  // Generates a new random word pair.
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  // Randomly selects a font from the available font list.
  void getFont() {
    currentFont = fonts[Random().nextInt(fonts.length)];
    notifyListeners();
  }

  // Stores the word pairs that the user has favourited.
  var favorites = <WordPair>[];

  // Adds or removes the current word pair from favourites.
  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  // Removes a specific word pair from favourites.
  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }
}

// HomePage controls the main application layout and navigation.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const GeneratorPage();
      case 1:
        page = const FavoritesPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;

        return Scaffold(
          body: Row(
            children: [
              if (isWide)
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 800,
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite),
                        label: Text('Favorites'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: SafeArea(
                    top: true,
                    bottom: true,
                    child: page,
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: !isWide
              ? NavigationBar(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.favorite),
                      label: 'Favorites',
                    ),
                  ],
                )
              : null,
        );
      },
    );
  }
}

// GeneratorPage displays the generated name and user interaction buttons.
class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<NamerState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigCard(pair: pair, fontFamily: appState.currentFont),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: const Text('Like'),
                ),
                ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: const Text('Next'),
                ),
                ElevatedButton(
                  onPressed: () {
                    appState.getFont();
                  },
                  child: const Text('Font'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// BigCard displays the generated word pair inside a styled Card widget.
class BigCard extends StatelessWidget {
  const BigCard({super.key, required this.pair, required this.fontFamily});

  final WordPair pair;
  final String fontFamily;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    TextStyle baseStyle;
    switch (fontFamily) {
      case 'Roboto Mono':
        baseStyle = GoogleFonts.robotoMono(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        );
      case 'Cinzel':
        baseStyle = GoogleFonts.cinzel(
          fontSize: 26,
          fontWeight: FontWeight.w900,
        );
      case 'Bungee':
        baseStyle = GoogleFonts.bungee(fontSize: 22);
      case 'Montserrat':
        baseStyle = GoogleFonts.montserrat(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        );
      case 'Pacifico':
      default:
        baseStyle = GoogleFonts.pacifico(fontSize: 30);
    }

    var style = baseStyle.copyWith(color: theme.colorScheme.onPrimary);

    return Card(
      color: theme.colorScheme.primary,
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}

// FavoritesPage displays all word pairs saved by the user.
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<NamerState>();
    var theme = Theme.of(context);

    if (appState.favorites.isEmpty) {
      return const Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'You have ${appState.favorites.length} favorites:',
            style: theme.textTheme.titleMedium,
          ),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: Text(pair.asLowerCase),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                appState.removeFavorite(pair);
              },
            ),
          ),
      ],
    );
  }
}
