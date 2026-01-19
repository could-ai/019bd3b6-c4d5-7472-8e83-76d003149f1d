import 'package:flutter/material.dart';
import '../services/game_services.dart';
import '../models/game_model.dart';

class GameViewerScreen extends StatefulWidget {
  const GameViewerScreen({super.key});

  @override
  State<GameViewerScreen> createState() => _GameViewerScreenState();
}

class _GameViewerScreenState extends State<GameViewerScreen> {
  List<GameModel> _games = [];
  GameModel? _selectedGame;

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  Future<void> _loadGames() async {
    final storage = GameStorageService();
    _games = await storage.loadGames();
    setState(() {});
  }

  void _chatWithAgent(SuspectAgent agent) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text('Chat with ${agent.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Personality: ${agent.personality}'),
              TextField(controller: controller, decoration: const InputDecoration(labelText: 'Ask a question')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final service = AgentService();
                final response = service.chatWithAgent(agent, controller.text);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response)));
                Navigator.pop(context);
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View Games')),
      body: _games.isEmpty
          ? const Center(child: Text('No games generated yet.'))
          : ListView.builder(
              itemCount: _games.length,
              itemBuilder: (context, index) {
                final game = _games[index];
                return ListTile(
                  title: Text(game.title),
                  subtitle: Text('Culprit: ${game.culprit}'),
                  onTap: () => setState(() => _selectedGame = game),
                );
              },
            ),
      floatingActionButton: _selectedGame != null
          ? FloatingActionButton.extended(
              onPressed: () {},
              label: const Text('Download Package'),
              icon: const Icon(Icons.download),
            )
          : null,
      bottomSheet: _selectedGame != null
          ? Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Assets: ${_selectedGame!.assets.join(', ')}'),
                  const SizedBox(height: 10),
                  Text('Agents:'),
                  ..._selectedGame!.agents.map((agent) => TextButton(
                        onPressed: () => _chatWithAgent(agent),
                        child: Text(agent.name),
                      )),
                ],
              ),
            )
          : null,
    );
  }
}