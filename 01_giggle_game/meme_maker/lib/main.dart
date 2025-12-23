import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  runApp(const MemeMakerApp());
}

class MemeMakerApp extends StatelessWidget {
  const MemeMakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meme Maker Lite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B9D),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B9D),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MemeMakerHome(),
    );
  }
}

class MemeMakerHome extends StatefulWidget {
  const MemeMakerHome({super.key});

  @override
  State<MemeMakerHome> createState() => _MemeMakerHomeState();
}

class _MemeMakerHomeState extends State<MemeMakerHome> {
  final TextEditingController _topTextController = TextEditingController();
  final TextEditingController _bottomTextController = TextEditingController();
  int _selectedTemplateIndex = 0;
  final Random _random = Random();

  final List<MemeTemplate> _templates = [
    MemeTemplate(
      name: 'Drake',
      emoji: '👋',
      topColor: Colors.blue.shade300,
      bottomColor: Colors.blue.shade600,
    ),
    MemeTemplate(
      name: 'Distracted',
      emoji: '🤔',
      topColor: Colors.orange.shade300,
      bottomColor: Colors.orange.shade600,
    ),
    MemeTemplate(
      name: 'Woman Yelling',
      emoji: '😤',
      topColor: Colors.pink.shade300,
      bottomColor: Colors.pink.shade600,
    ),
    MemeTemplate(
      name: 'Success Kid',
      emoji: '👶',
      topColor: Colors.green.shade300,
      bottomColor: Colors.green.shade600,
    ),
    MemeTemplate(
      name: 'Change My Mind',
      emoji: '💭',
      topColor: Colors.purple.shade300,
      bottomColor: Colors.purple.shade600,
    ),
    MemeTemplate(
      name: 'This is Fine',
      emoji: '🔥',
      topColor: Colors.red.shade300,
      bottomColor: Colors.red.shade600,
    ),
  ];

  final List<String> _topTextSuggestions = [
    'When you find money in your pocket',
    'Me: I\'ll just check my phone for a second',
    'When someone says "it\'s not that hard"',
    'Me trying to be productive',
    'When the WiFi is working perfectly',
    'Me explaining why I\'m late',
  ];

  final List<String> _bottomTextSuggestions = [
    'Me 3 hours later still on my phone',
    'Also me: *hasn\'t moved in 5 hours*',
    'Me: *crying internally*',
    'My brain: *watching cat videos*',
    'Me: *still late*',
    'Me: *still procrastinating*',
  ];

  @override
  void dispose() {
    _topTextController.dispose();
    _bottomTextController.dispose();
    super.dispose();
  }

  void _randomMeme() {
    HapticFeedback.mediumImpact();
    setState(() {
      _selectedTemplateIndex = _random.nextInt(_templates.length);
      _topTextController.text = _topTextSuggestions[_random.nextInt(_topTextSuggestions.length)];
      _bottomTextController.text = _bottomTextSuggestions[_random.nextInt(_bottomTextSuggestions.length)];
    });
  }

  void _shareMeme() {
    final text = '${_topTextController.text}\n\n${_bottomTextController.text}\n\n- Meme Maker Lite';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Meme text copied to clipboard!'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _clearMeme() {
    HapticFeedback.lightImpact();
    setState(() {
      _topTextController.clear();
      _bottomTextController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final template = _templates[_selectedTemplateIndex];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              template.topColor.withOpacity(0.3),
              template.bottomColor.withOpacity(0.3),
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
                      child: Text(template.emoji, style: const TextStyle(fontSize: 28)),
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Meme Maker',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Create and share memes!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _shareMeme,
                      icon: const Icon(Icons.share, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Template selector
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: _templates.length,
                  itemBuilder: (context, index) {
                    final t = _templates[index];
                    final isSelected = index == _selectedTemplateIndex;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            _selectedTemplateIndex = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? template.bottomColor : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(t.emoji, style: const TextStyle(fontSize: 20)),
                              const SizedBox(width: 6),
                              Text(
                                t.name,
                                style: TextStyle(
                                  color: isSelected ? Colors.black87 : Colors.white,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Meme preview
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Column(
                        children: [
                          // Top text area
                          Expanded(
                            flex: 1,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [template.topColor, template.topColor.withOpacity(0.7)],
                                ),
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Center(
                                child: TextField(
                                  controller: _topTextController,
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(2, 2),
                                        blurRadius: 4,
                                        color: Colors.black54,
                                      ),
                                    ],
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Top text...',
                                    hintStyle: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          // Divider
                          Container(
                            height: 4,
                            color: Colors.black12,
                          ),
                          
                          // Bottom text area
                          Expanded(
                            flex: 1,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [template.bottomColor.withOpacity(0.7), template.bottomColor],
                                ),
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Center(
                                child: TextField(
                                  controller: _bottomTextController,
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(2, 2),
                                        blurRadius: 4,
                                        color: Colors.black54,
                                      ),
                                    ],
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Bottom text...',
                                    hintStyle: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Action buttons
              Padding(
                padding: const EdgeInsets.all(30),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _clearMeme,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Colors.white, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Clear',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _randomMeme,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: template.bottomColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 8,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.casino, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Random Meme',
                              style: TextStyle(
                                fontSize: 16,
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
            ],
          ),
        ),
      ),
    );
  }
}

class MemeTemplate {
  final String name;
  final String emoji;
  final Color topColor;
  final Color bottomColor;

  MemeTemplate({
    required this.name,
    required this.emoji,
    required this.topColor,
    required this.bottomColor,
  });
}
