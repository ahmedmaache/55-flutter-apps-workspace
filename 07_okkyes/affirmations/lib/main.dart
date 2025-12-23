import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  runApp(const DailyAffirmationsApp());
}

class DailyAffirmationsApp extends StatelessWidget {
  const DailyAffirmationsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Affirmations',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9C89B8),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const AffirmationHome(),
    );
  }
}

class AffirmationHome extends StatefulWidget {
  const AffirmationHome({super.key});

  @override
  State<AffirmationHome> createState() => _AffirmationHomeState();
}

class _AffirmationHomeState extends State<AffirmationHome> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final Random _random = Random();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Affirmation> _affirmations = [
    Affirmation(
      text: "I am worthy of love and respect.",
      category: "Self-Worth",
      gradient: [const Color(0xFFE8D5E9), const Color(0xFFF3E5F5)],
    ),
    Affirmation(
      text: "I embrace my unique qualities and celebrate who I am.",
      category: "Self-Love",
      gradient: [const Color(0xFFFFE0B2), const Color(0xFFFFF3E0)],
    ),
    Affirmation(
      text: "Every challenge is an opportunity for growth.",
      category: "Growth",
      gradient: [const Color(0xFFC8E6C9), const Color(0xFFE8F5E9)],
    ),
    Affirmation(
      text: "I trust the journey, even when I do not understand it.",
      category: "Trust",
      gradient: [const Color(0xFFB3E5FC), const Color(0xFFE1F5FE)],
    ),
    Affirmation(
      text: "I am capable of achieving my goals.",
      category: "Success",
      gradient: [const Color(0xFFFFCDD2), const Color(0xFFFFEBEE)],
    ),
    Affirmation(
      text: "I choose peace over anxiety.",
      category: "Peace",
      gradient: [const Color(0xFFD1C4E9), const Color(0xFFEDE7F6)],
    ),
    Affirmation(
      text: "I am grateful for this moment.",
      category: "Gratitude",
      gradient: [const Color(0xFFFFE082), const Color(0xFFFFF8E1)],
    ),
    Affirmation(
      text: "I release all fears and embrace positivity.",
      category: "Positivity",
      gradient: [const Color(0xFFB2EBF2), const Color(0xFFE0F7FA)],
    ),
    Affirmation(
      text: "I am surrounded by abundance.",
      category: "Abundance",
      gradient: [const Color(0xFFF8BBD0), const Color(0xFFFCE4EC)],
    ),
    Affirmation(
      text: "I believe in myself and my abilities.",
      category: "Confidence",
      gradient: [const Color(0xFFDCEDC8), const Color(0xFFF1F8E9)],
    ),
    Affirmation(
      text: "Today, I choose happiness.",
      category: "Happiness",
      gradient: [const Color(0xFFFFCC80), const Color(0xFFFFF3E0)],
    ),
    Affirmation(
      text: "I am enough, just as I am.",
      category: "Acceptance",
      gradient: [const Color(0xFFCE93D8), const Color(0xFFF3E5F5)],
    ),
    Affirmation(
      text: "I attract positive energy and people into my life.",
      category: "Energy",
      gradient: [const Color(0xFF80DEEA), const Color(0xFFE0F7FA)],
    ),
    Affirmation(
      text: "I forgive myself and others.",
      category: "Forgiveness",
      gradient: [const Color(0xFFA5D6A7), const Color(0xFFE8F5E9)],
    ),
    Affirmation(
      text: "My potential is limitless.",
      category: "Potential",
      gradient: [const Color(0xFF90CAF9), const Color(0xFFE3F2FD)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = _random.nextInt(_affirmations.length);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _nextAffirmation() {
    HapticFeedback.lightImpact();
    _controller.reset();
    setState(() {
      _currentIndex = (_currentIndex + 1) % _affirmations.length;
    });
    _controller.forward();
  }

  void _randomAffirmation() {
    HapticFeedback.mediumImpact();
    _controller.reset();
    setState(() {
      int newIndex;
      do {
        newIndex = _random.nextInt(_affirmations.length);
      } while (newIndex == _currentIndex && _affirmations.length > 1);
      _currentIndex = newIndex;
    });
    _controller.forward();
  }

  void _shareAffirmation() {
    final affirmation = _affirmations[_currentIndex];
    final text = '"${affirmation.text}"\n\n- Daily Affirmations by Okkyes';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check, color: Colors.white),
            SizedBox(width: 10),
            Text('Affirmation copied to clipboard'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final affirmation = _affirmations[_currentIndex];

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: affirmation.gradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('✨', style: TextStyle(fontSize: 24)),
                            SizedBox(width: 8),
                            Text(
                              'Daily Affirmations',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Start your day with positivity',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: _shareAffirmation,
                      icon: const Icon(Icons.share, color: Colors.black54),
                    ),
                  ],
                ),
              ),

              // Main affirmation card
              Expanded(
                child: Center(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          padding: const EdgeInsets.all(35),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Category badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: affirmation.gradient[0].withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  affirmation.category,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              
                              // Quote marks
                              Text(
                                '"',
                                style: TextStyle(
                                  fontSize: 60,
                                  height: 0.5,
                                  fontFamily: 'Georgia',
                                  color: affirmation.gradient[0],
                                ),
                              ),
                              const SizedBox(height: 10),
                              
                              // Affirmation text
                              Text(
                                affirmation.text,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                  height: 1.5,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 30),
                              
                              // Affirmation actions
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildActionButton(
                                    icon: Icons.favorite_border,
                                    label: 'Save',
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Text('Saved to favorites!'),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 20),
                                  _buildActionButton(
                                    icon: Icons.share,
                                    label: 'Share',
                                    onTap: _shareAffirmation,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom controls
              Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    // Next button
                    GestureDetector(
                      onTap: _randomAffirmation,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shuffle, color: Colors.black87),
                            SizedBox(width: 12),
                            Text(
                              'New Affirmation',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Page indicator
                    Text(
                      '${_currentIndex + 1} of ${_affirmations.length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.4),
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

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.black54),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Affirmation {
  final String text;
  final String category;
  final List<Color> gradient;

  Affirmation({
    required this.text,
    required this.category,
    required this.gradient,
  });
}
