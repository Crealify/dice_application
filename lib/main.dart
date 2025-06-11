import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DiceApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DiceApp extends StatelessWidget {
  const DiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0f2027), Color(0xFF2c5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(child: DiceRoller()),
      ),
    );
  }
}

class DiceRoller extends StatefulWidget {
  const DiceRoller({super.key});

  @override
  State<DiceRoller> createState() => _DiceRollerState();
}

class _DiceRollerState extends State<DiceRoller>
    with SingleTickerProviderStateMixin {
  final Random _random = Random();
  int _currentDice = 1;
  late final AnimationController _controller;
  late final Animation<double> _animation;
  bool _isRolling = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _rollDice() async {
    if (_isRolling) return;
    setState(() => _isRolling = true);
    await _controller.forward(from: 0);
    setState(() {
      _currentDice = _random.nextInt(6) + 1;
      _isRolling = false;
    });
  }

  void _resetDice() {
    setState(() => _currentDice = 1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _animation.value,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Image.asset(
                  "assets/imagesDice/dice-$_currentDice.png",
                  key: ValueKey(_currentDice),
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                  color: Colors.white,
                  colorBlendMode: BlendMode.modulate,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 30),
        ElevatedButton.icon(
          onPressed: _isRolling ? null : _rollDice,
          icon: const Icon(Icons.casino, color: Colors.white),
          label: const Text("Roll Dice"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1e3c72),
            foregroundColor: Colors.white,
            minimumSize: const Size(160, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            elevation: 6,
            shadowColor: Colors.black45,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _isRolling ? null : _resetDice,
          icon: const Icon(Icons.casino, color: Colors.white),
          label: const Text("Roll Dice"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            minimumSize: const Size(160, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            elevation: 6,
            shadowColor: Colors.black45,
          ),
        ),
      ],
    );
  }
}
