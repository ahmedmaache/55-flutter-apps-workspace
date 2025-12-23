import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const FocusTimerApp());
}

class FocusTimerApp extends StatelessWidget {
  const FocusTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'olaf Focus Timer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5C8DB8),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5C8DB8),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const FocusTimerHome(),
    );
  }
}

class FocusTimerHome extends StatefulWidget {
  const FocusTimerHome({super.key});

  @override
  State<FocusTimerHome> createState() => _FocusTimerHomeState();
}

class _FocusTimerHomeState extends State<FocusTimerHome> with TickerProviderStateMixin {
  int _focusDuration = 25; // minutes
  int _breakDuration = 5; // minutes
  int _remainingSeconds = 25 * 60;
  bool _isRunning = false;
  bool _isFocusMode = true;
  int _completedSessions = 0;
  Timer? _timer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _onTimerComplete();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _remainingSeconds = _isFocusMode ? _focusDuration * 60 : _breakDuration * 60;
    });
  }

  void _onTimerComplete() {
    if (_isFocusMode) {
      setState(() {
        _completedSessions++;
        _isFocusMode = false;
        _remainingSeconds = _breakDuration * 60;
      });
      _showNotification('Focus complete! Time for a break.');
    } else {
      setState(() {
        _isFocusMode = true;
        _remainingSeconds = _focusDuration * 60;
      });
      _showNotification('Break over! Ready to focus again?');
    }
    setState(() {
      _isRunning = false;
    });
  }

  void _showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _isFocusMode ? Icons.coffee : Icons.psychology,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  double get _progress {
    final total = _isFocusMode ? _focusDuration * 60 : _breakDuration * 60;
    return 1 - (_remainingSeconds / total);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mainColor = _isFocusMode ? const Color(0xFF5C8DB8) : const Color(0xFF6BBF8A);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('❄️', style: TextStyle(fontSize: 24)),
                          const SizedBox(width: 10),
                          Text(
                            'olaf Focus',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w300,
                              color: colorScheme.onSurface,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Minimalist Pomodoro Timer',
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => _showSettingsDialog(),
                    icon: Icon(Icons.tune, color: colorScheme.onSurface.withOpacity(0.6)),
                  ),
                ],
              ),
            ),

            // Mode indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isFocusMode ? Icons.psychology : Icons.coffee,
                      color: mainColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isFocusMode ? 'Focus Time' : 'Break Time',
                      style: TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Timer display
            Expanded(
              child: Center(
                child: ScaleTransition(
                  scale: _isRunning ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Progress ring
                      SizedBox(
                        width: 280,
                        height: 280,
                        child: CircularProgressIndicator(
                          value: _progress,
                          strokeWidth: 8,
                          backgroundColor: mainColor.withOpacity(0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                        ),
                      ),
                      // Time display
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _formatTime(_remainingSeconds),
                            style: TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.w200,
                              color: colorScheme.onSurface,
                              letterSpacing: 4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isFocusMode ? 'minutes of focus' : 'minutes of rest',
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Controls
            Padding(
              padding: const EdgeInsets.all(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Reset button
                  IconButton(
                    onPressed: _resetTimer,
                    icon: const Icon(Icons.refresh),
                    iconSize: 32,
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(width: 20),
                  // Play/Pause button
                  GestureDetector(
                    onTap: _isRunning ? _pauseTimer : _startTimer,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: mainColor,
                        boxShadow: [
                          BoxShadow(
                            color: mainColor.withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        _isRunning ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Skip button
                  IconButton(
                    onPressed: () {
                      _timer?.cancel();
                      _onTimerComplete();
                    },
                    icon: const Icon(Icons.skip_next),
                    iconSize: 32,
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                ],
              ),
            ),

            // Sessions completed
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Sessions', _completedSessions.toString(), Icons.check_circle_outline),
                  Container(
                    width: 1,
                    height: 40,
                    color: colorScheme.outline.withOpacity(0.2),
                  ),
                  _buildStatItem('Focus', '${_completedSessions * _focusDuration}m', Icons.access_time),
                  Container(
                    width: 1,
                    height: 40,
                    color: colorScheme.outline.withOpacity(0.2),
                  ),
                  _buildStatItem('Streak', '${_completedSessions > 0 ? 1 : 0}', Icons.local_fire_department),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Icon(icon, color: colorScheme.primary.withOpacity(0.7), size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  void _showSettingsDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Timer Settings',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 25),
              Text('Focus Duration: $_focusDuration minutes'),
              Slider(
                value: _focusDuration.toDouble(),
                min: 5,
                max: 60,
                divisions: 11,
                onChanged: (value) {
                  setModalState(() {
                    _focusDuration = value.toInt();
                  });
                  setState(() {
                    if (_isFocusMode && !_isRunning) {
                      _remainingSeconds = _focusDuration * 60;
                    }
                  });
                },
              ),
              const SizedBox(height: 15),
              Text('Break Duration: $_breakDuration minutes'),
              Slider(
                value: _breakDuration.toDouble(),
                min: 1,
                max: 30,
                divisions: 29,
                onChanged: (value) {
                  setModalState(() {
                    _breakDuration = value.toInt();
                  });
                  setState(() {
                    if (!_isFocusMode && !_isRunning) {
                      _remainingSeconds = _breakDuration * 60;
                    }
                  });
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
