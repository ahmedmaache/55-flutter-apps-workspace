import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  runApp(const EmojiStoryApp());
}

class EmojiStoryApp extends StatelessWidget {
  const EmojiStoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emoji Story Creator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFB347),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFB347),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const EmojiStoryHome(),
    );
  }
}

class EmojiStoryHome extends StatefulWidget {
  const EmojiStoryHome({super.key});

  @override
  State<EmojiStoryHome> createState() => _EmojiStoryHomeState();
}

class _EmojiStoryHomeState extends State<EmojiStoryHome> with SingleTickerProviderStateMixin {
  final List<String> _storyEmojis = [];
  final TextEditingController _textController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final Random _random = Random();

  final Map<String, List<String>> _emojiCategories = {
    'Faces': ['😀', '😃', '😄', '😁', '😆', '😅', '🤣', '😂', '🙂', '🙃', '😉', '😊', '😇', '🥰', '😍', '🤩', '😘', '😗', '😚', '😙'],
    'Animals': ['🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼', '🐨', '🐯', '🦁', '🐮', '🐷', '🐸', '🐵', '🐔', '🐧', '🐦', '🐤', '🦆'],
    'Food': ['🍎', '🍌', '🍇', '🍊', '🍋', '🍉', '🍓', '🍑', '🍒', '🍐', '🍕', '🍔', '🍟', '🌭', '🍿', '🧂', '🥓', '🥞', '🧇', '🥯'],
    'Travel': ['🚗', '🚕', '🚙', '🚌', '🚎', '🏎️', '🚓', '🚑', '🚒', '🚐', '✈️', '🚀', '🚁', '⛵', '🚤', '🛥️', '🛳️', '🚢', '🚂', '🚆'],
    'Activities': ['⚽', '🏀', '🏈', '⚾', '🎾', '🏐', '🏉', '🎱', '🏓', '🏸', '🥊', '🏋️', '🤸', '🤾', '🏌️', '🏇', '🧘', '🏄', '🏊', '🚴'],
    'Objects': ['📱', '💻', '⌚', '📷', '📹', '🎥', '📺', '📻', '🎙️', '🎚️', '🎛️', '⏱️', '⏲️', '⏰', '🕰️', '⌛', '⏳', '📡', '🔋', '💡'],
    'Nature': ['🌱', '🌲', '🌳', '🌴', '🌵', '🌷', '🌹', '🌺', '🌻', '🌼', '🌸', '🌾', '🌿', '🍀', '🍁', '🍂', '🍃', '🌍', '🌎', '🌏'],
    'Weather': ['☀️', '🌤️', '⛅', '🌥️', '☁️', '🌦️', '🌧️', '⛈️', '🌩️', '⚡', '❄️', '☃️', '⛄', '🌬️', '💨', '💧', '💦', '☔', '☂️', '🌈'],
  };

  String _selectedCategory = 'Faces';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _addEmoji(String emoji) {
    HapticFeedback.lightImpact();
    _animationController.forward().then((_) => _animationController.reverse());
    setState(() {
      _storyEmojis.add(emoji);
    });
  }

  void _removeLastEmoji() {
    if (_storyEmojis.isNotEmpty) {
      HapticFeedback.lightImpact();
      setState(() {
        _storyEmojis.removeLast();
      });
    }
  }

  void _clearStory() {
    HapticFeedback.mediumImpact();
    setState(() {
      _storyEmojis.clear();
      _textController.clear();
    });
  }

  void _generateRandomStory() {
    HapticFeedback.mediumImpact();
    setState(() {
      _storyEmojis.clear();
      final allEmojis = _emojiCategories.values.expand((list) => list).toList();
      for (int i = 0; i < 15; i++) {
        _storyEmojis.add(allEmojis[_random.nextInt(allEmojis.length)]);
      }
    });
  }

  void _shareStory() {
    final emojiText = _storyEmojis.join(' ');
    final fullText = _textController.text.isNotEmpty
        ? '${_textController.text}\n\n$emojiText'
        : emojiText;
    final shareText = '$fullText\n\n- Emoji Story Creator by Giggle Game';
    
    Clipboard.setData(ClipboardData(text: shareText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Story copied to clipboard!'),
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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.orange.shade200,
              Colors.yellow.shade200,
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
                      child: const Text('📖', style: TextStyle(fontSize: 28)),
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emoji Story',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Create visual stories!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _shareStory,
                      icon: const Icon(Icons.share, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Story display area
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text input
                      TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: 'Add a caption or story text...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(fontSize: 16),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 15),
                      
                      // Emoji story
                      Expanded(
                        child: _storyEmojis.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '📝',
                                      style: TextStyle(
                                        fontSize: 60,
                                        color: Colors.grey.withOpacity(0.3),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Start adding emojis!',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SingleChildScrollView(
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  alignment: WrapAlignment.start,
                                  children: _storyEmojis.map((emoji) {
                                    return Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        emoji,
                                        style: const TextStyle(fontSize: 32),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Category selector
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: _emojiCategories.keys.length,
                  itemBuilder: (context, index) {
                    final category = _emojiCategories.keys.elementAt(index);
                    final isSelected = category == _selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
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

              const SizedBox(height: 15),

              // Emoji grid
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _emojiCategories[_selectedCategory]!.length,
                    itemBuilder: (context, index) {
                      final emoji = _emojiCategories[_selectedCategory]![index];
                      return ScaleTransition(
                        scale: _scaleAnimation,
                        child: GestureDetector(
                          onTap: () => _addEmoji(emoji),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.orange.shade200,
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                emoji,
                                style: const TextStyle(fontSize: 28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Action buttons
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _removeLastEmoji,
                        icon: const Icon(Icons.backspace),
                        label: const Text('Undo'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Colors.white, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _clearStory,
                        icon: const Icon(Icons.clear_all),
                        label: const Text('Clear'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Colors.white, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: _generateRandomStory,
                        icon: const Icon(Icons.casino),
                        label: const Text('Random'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 8,
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
