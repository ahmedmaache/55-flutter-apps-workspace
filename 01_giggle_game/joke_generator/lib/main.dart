import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  runApp(const JokeGeneratorApp());
}

class JokeGeneratorApp extends StatelessWidget {
  const JokeGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joke Generator Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B35),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B35),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const JokeHomePage(),
    );
  }
}

class JokeHomePage extends StatefulWidget {
  const JokeHomePage({super.key});

  @override
  State<JokeHomePage> createState() => _JokeHomePageState();
}

class _JokeHomePageState extends State<JokeHomePage> with SingleTickerProviderStateMixin {
  final Random _random = Random();
  int _currentJokeIndex = 0;
  String _selectedCategory = 'All';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> _categories = ['All', 'Puns', 'Tech', 'Dad Jokes', 'One-liners', 'Animals'];

  final Map<String, List<Joke>> _jokesByCategory = {
    'Puns': [
      Joke('Why don\'t scientists trust atoms?', 'Because they make up everything!', '🔬'),
      Joke('I\'m reading a book about anti-gravity.', 'It\'s impossible to put down!', '📚'),
      Joke('Why do bees have sticky hair?', 'Because they use honeycombs!', '🐝'),
      Joke('I used to hate facial hair.', 'But then it grew on me!', '🧔'),
      Joke('What do you call a fake noodle?', 'An impasta!', '🍝'),
      Joke('Why don\'t eggs tell jokes?', 'They\'d crack each other up!', '🥚'),
      Joke('I used to be a banker.', 'But I lost interest!', '💰'),
    ],
    'Tech': [
      Joke('Why do programmers prefer dark mode?', 'Because light attracts bugs!', '💻'),
      Joke('Why was the JavaScript developer sad?', 'Because he didn\'t Node how to Express himself!', '📦'),
      Joke('How many programmers does it take to change a light bulb?', 'None, that\'s a hardware problem!', '💡'),
      Joke('A SQL query walks into a bar, walks up to two tables and asks...', '"Can I join you?"', '🗄️'),
      Joke('Why do Java developers wear glasses?', 'Because they can\'t C#!', '👓'),
      Joke('What\'s a computer\'s favorite snack?', 'Microchips!', '🍟'),
      Joke('Why was the computer cold?', 'It left its Windows open!', '🖥️'),
    ],
    'Dad Jokes': [
      Joke('I\'m afraid for the calendar.', 'Its days are numbered!', '📅'),
      Joke('What do you call a fish without eyes?', 'A fsh!', '🐟'),
      Joke('I only know 25 letters of the alphabet.', 'I don\'t know Y!', '🔤'),
      Joke('What did the ocean say to the beach?', 'Nothing, it just waved!', '🌊'),
      Joke('Why couldn\'t the bicycle stand up by itself?', 'It was two tired!', '🚲'),
      Joke('What do you call cheese that isn\'t yours?', 'Nacho cheese!', '🧀'),
      Joke('I used to play piano by ear.', 'Now I use my hands!', '🎹'),
    ],
    'One-liners': [
      Joke('I told my wife she was drawing her eyebrows too high.', 'She looked surprised!', '😲'),
      Joke('I have a joke about construction.', 'I\'m still working on it!', '🏗️'),
      Joke('Parallel lines have so much in common.', 'It\'s a shame they\'ll never meet!', '📐'),
      Joke('I have a joke about time travel.', 'But you didn\'t like it.', '⏰'),
      Joke('I\'m on a seafood diet.', 'I see food and I eat it!', '🍽️'),
      Joke('I would avoid the sushi if I were you.', 'It\'s a little fishy!', '🍣'),
    ],
    'Animals': [
      Joke('What do you call a bear with no teeth?', 'A gummy bear!', '🧸'),
      Joke('Why don\'t oysters donate to charity?', 'Because they\'re shellfish!', '🐚'),
      Joke('What do you call an alligator in a vest?', 'An investigator!', '🐊'),
      Joke('Why do cows wear bells?', 'Because their horns don\'t work!', '🐄'),
      Joke('What do you call a sleeping dinosaur?', 'A dino-snore!', '🦕'),
      Joke('Why are frogs so happy?', 'They eat whatever bugs them!', '🐸'),
      Joke('What do you call a fish wearing a bowtie?', 'So-fish-ticated!', '🐠'),
    ],
  };

  List<Joke> get _currentJokes {
    if (_selectedCategory == 'All') {
      return _jokesByCategory.values.expand((jokes) => jokes).toList();
    }
    return _jokesByCategory[_selectedCategory] ?? [];
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _generateNewJoke() {
    HapticFeedback.mediumImpact();
    _animationController.reset();
    setState(() {
      _currentJokeIndex = _random.nextInt(_currentJokes.length);
    });
    _animationController.forward();
  }

  void _shareJoke(Joke joke) {
    final text = '${joke.setup}\n\n${joke.punchline}\n\n- Joke Generator Pro';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Joke copied to clipboard!'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jokes = _currentJokes;
    final currentJoke = jokes.isNotEmpty ? jokes[_currentJokeIndex % jokes.length] : null;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
              Theme.of(context).colorScheme.secondary.withOpacity(0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Text('😂', style: TextStyle(fontSize: 28)),
                    ),
                    const SizedBox(width: 15),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Joke Generator',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Laugh out loud!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Category selector
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = category == _selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                            _currentJokeIndex = 0;
                          });
                          _animationController.reset();
                          _animationController.forward();
                        },
                        backgroundColor: Colors.white.withOpacity(0.2),
                        selectedColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.black87 : Colors.white,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        showCheckmark: false,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              // Joke card
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: currentJoke != null
                      ? FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: JokeCard(
                              joke: currentJoke,
                              onShare: () => _shareJoke(currentJoke),
                            ),
                          ),
                        )
                      : const Center(
                          child: Text(
                            'No jokes available',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ),
              ),

              // Generate button
              Padding(
                padding: const EdgeInsets.all(30),
                child: ElevatedButton(
                  onPressed: _generateNewJoke,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                    shadowColor: Colors.black38,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.casino, size: 26),
                      SizedBox(width: 12),
                      Text(
                        'Generate Joke',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Joke {
  final String setup;
  final String punchline;
  final String emoji;

  Joke(this.setup, this.punchline, this.emoji);
}

class JokeCard extends StatefulWidget {
  final Joke joke;
  final VoidCallback onShare;

  const JokeCard({
    super.key,
    required this.joke,
    required this.onShare,
  });

  @override
  State<JokeCard> createState() => _JokeCardState();
}

class _JokeCardState extends State<JokeCard> {
  bool _showPunchline = false;

  @override
  void didUpdateWidget(JokeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.joke != widget.joke) {
      _showPunchline = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showPunchline = !_showPunchline;
        });
        HapticFeedback.lightImpact();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Emoji
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                widget.joke.emoji,
                style: const TextStyle(fontSize: 50),
              ),
            ),
            const SizedBox(height: 25),
            
            // Setup
            Text(
              widget.joke.setup,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Punchline (revealed on tap)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _showPunchline
                  ? Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            widget.joke.punchline,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: widget.onShare,
                              icon: const Icon(Icons.share),
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.favorite_border),
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.touch_app, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            'Tap to reveal punchline',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
