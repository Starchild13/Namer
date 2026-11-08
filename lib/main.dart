// Import Dart's math library to generate random numbers.
import 'dart:math';

// Import english_words to generate random word combinations.
import 'package:english_words/english_words.dart';

// Import Flutter's Material Design widgets.
import 'package:flutter/material.dart';

// Import Provider for application-wide state management.
import 'package:provider/provider.dart';

// Import Google Fonts to use different font styles.
import 'package:google_fonts/google_fonts.dart';

// The entry point of the Flutter application.
void main() {
  runApp(const Namer());
}

// Root widget of the application.
// StatelessWidget means this widget does not manage its own changing state.
class Namer extends StatelessWidget {
  const Namer({super.key});

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider makes NamerState available
    // to all child widgets in the application.
    return ChangeNotifierProvider(
      create: (context) => NamerState(),

      child: MaterialApp(
        title: 'Namer App',

        // Defines the application's overall theme.
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        ),

        // Sets the first screen users see.
        home: const HomePage(),
      ),
    );
  }
}

// Manages the application's data and business logic.
// ChangeNotifier allows widgets to listen for changes and update automatically.
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

    // Notify listening widgets that the data has changed.
    notifyListeners();
  }

  // Randomly selects a font from the available font list.
  void getFont() {
    currentFont = fonts[Random().nextInt(fonts.length)];

    // Update widgets listening to NamerState.
    notifyListeners();
  }

  // Stores the word pairs that the user has favourited.
  var favorites = <WordPair>[];

  // Adds or removes the current word pair from favourites.
  void toggleFavorite() {
    // Check whether the current word pair is already saved.
    if (favorites.contains(current)) {
      // Remove it if it is already a favourite.
      favorites.remove(current);
    } else {
      // Otherwise, add it to the favourites list.
      favorites.add(current);
    }

    // Notify the UI to refresh the favourite icon and list.
    notifyListeners();
  }
}

// HomePage controls the main application layout and navigation.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// StatefulWidget is used because the selected navigation page can change.
class _HomePageState extends State<HomePage> {
  // Keeps track of the currently selected navigation destination.
  // 0 = Home, 1 = Favorites.
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // This variable holds the page that will be displayed.
    Widget page;

    // Select which page to display based on the navigation selection.
    switch (selectedIndex) {
      case 0:
        page = const GeneratorPage();

      case 1:
        page = const FavoritesPage();

      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // LayoutBuilder provides the available screen dimensions.
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              // NavigationRail provides navigation between app sections.
              SafeArea(
                child: NavigationRail(
                  // Show navigation labels when the screen is wide enough.
                  extended: constraints.maxWidth >= 600,

                  destinations: const [
                    // Home navigation destination.
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),

                    // Favorites navigation destination.
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],

                  // Highlights the currently selected destination.
                  selectedIndex: selectedIndex,

                  // Update the selected page when a destination is tapped.
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),

              // Expanded makes the selected page occupy the remaining space.
              Expanded(
                child: Container(
                  // Uses the theme's primary container background colour.
                  color: Theme.of(context).colorScheme.primaryContainer,

                  // Displays the selected page.
                  child: page,
                ),
              ),
            ],
          ),
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
    // Listen to NamerState so this page rebuilds when its data changes.
    var appState = context.watch<NamerState>();

    // Get the current random word pair.
    var pair = appState.current;

    // Determine which favourite icon should be displayed.
    IconData icon;

    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Displays the generated word pair.
          // Passes the currently selected font to BigCard.
          BigCard(pair: pair, fontFamily: appState.currentFont),

          const SizedBox(height: 10),

          // Row places the action buttons horizontally.
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Button for adding or removing a favourite.
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: const Text('Like'),
              ),

              const SizedBox(width: 10),

              // Button for generating another random word pair.
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: const Text('Next'),
              ),

              const SizedBox(width: 10),

              // Button for randomly changing the displayed font.
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
    );
  }
}

// BigCard displays the generated word pair inside a styled Card widget.
class BigCard extends StatelessWidget {
  const BigCard({super.key, required this.pair, required this.fontFamily});

  // The word pair received from GeneratorPage.
  final WordPair pair;

  // The font selected by the user.
  final String fontFamily;

  @override
  Widget build(BuildContext context) {
    // Access the application's current theme.
    var theme = Theme.of(context);

    // Holds the selected font's text styling.
    TextStyle baseStyle;

    // Select the Google Font based on the current font family.
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

      // Pacifico is the default font.
      case 'Pacifico':
      default:
        baseStyle = GoogleFonts.pacifico(fontSize: 30);
    }

    // Copy the selected font style and apply the theme's text colour.
    var style = baseStyle.copyWith(color: theme.colorScheme.onPrimary);

    // Card provides a container with elevation and padding.
    return Card(
      color: theme.colorScheme.primary,
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),

        // Display the generated word pair in lowercase.
        child: Text(
          pair.asLowerCase,
          style: style,

          // Provides an accessible label for screen readers.
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
    // Listen for changes to the favourites list.
    var appState = context.watch<NamerState>();

    // Display a message if the user has not saved any favourites.
    if (appState.favorites.isEmpty) {
      return const Center(child: Text('No favorites yet.'));
    }

    // ListView allows the favourites list to scroll.
    return ListView(
      children: [
        // Display the total number of saved favourites.
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have ${appState.favorites.length} favorites:'),
        ),

        // Loop through every saved word pair.
        // Create a ListTile for each favourite.
        for (var pair in appState.favorites)
          ListTile(
            leading: const Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}
