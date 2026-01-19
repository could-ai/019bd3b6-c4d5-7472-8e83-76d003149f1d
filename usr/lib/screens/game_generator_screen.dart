import 'package:flutter/material.dart';
import '../services/game_services.dart';
import '../models/game_model.dart';

class GameGeneratorScreen extends StatefulWidget {
  const GameGeneratorScreen({super.key});

  @override
  State<GameGeneratorScreen> createState() => _GameGeneratorScreenState();
}

class _GameGeneratorScreenState extends State<GameGeneratorScreen> {
  final TextEditingController _themeController = TextEditingController();
  GameModel? _generatedGame;
  bool _isGenerating = false;

  Future<void> _generate() async {
    setState(() => _isGenerating = true);
    final service = MockLlmService();
    _generatedGame = await service.generateMystery(_themeController.text);
    setState(() => _isGenerating = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generate Mystery')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _themeController,
              decoration: const InputDecoration(labelText: 'Enter Theme (e.g., Mansion Heist)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generate,
              child: _isGenerating ? const CircularProgressIndicator() : const Text('Generate Mystery'),
            ),
            if (_generatedGame != null) ...[
              const SizedBox(height: 20),
              Text('Title: ${_generatedGame!.title}'),
              Text('Mystery: ${_generatedGame!.mystery}'),
              Text('Culprit: ${_generatedGame!.culprit}'),
            ],
          ],
        ),
      ),
    );
  }
}