import 'package:flutter/material.dart';
import '../services/game_services.dart';
import '../models/game_model.dart';

class PipelineScreen extends StatefulWidget {
  const PipelineScreen({super.key});

  @override
  State<PipelineScreen> createState() => _PipelineScreenState();
}

class _PipelineScreenState extends State<PipelineScreen> {
  final TextEditingController _themeController = TextEditingController();
  String _status = 'Ready to start pipeline';
  GameModel? _finalGame;

  Future<void> _runPipeline() async {
    setState(() => _status = 'Generating mystery...');
    final llm = MockLlmService();
    var game = await llm.generateMystery(_themeController.text);

    setState(() => _status = 'Building knowledge graph...');
    final graph = KnowledgeGraphService();
    graph.buildGraph(game);

    setState(() => _status = 'Generating assets...');
    final assetGen = AssetGeneratorService();
    game = GameModel(
      id: game.id,
      title: game.title,
      mystery: game.mystery,
      suspects: game.suspects,
      culprit: game.culprit,
      motive: game.motive,
      alibis: game.alibis,
      clues: game.clues,
      knowledgeGraph: graph.graph,
      assets: await assetGen.generateAssets(game),
      agents: [],
    );

    setState(() => _status = 'Setting up agents...');
    final agentService = AgentService();
    game = GameModel(
      id: game.id,
      title: game.title,
      mystery: game.mystery,
      suspects: game.suspects,
      culprit: game.culprit,
      motive: game.motive,
      alibis: game.alibis,
      clues: game.clues,
      knowledgeGraph: game.knowledgeGraph,
      assets: game.assets,
      agents: await agentService.setupAgents(game, graph),
    );

    setState(() => _status = 'Packaging game...');
    final storage = GameStorageService();
    await storage.saveGame(game);
    _finalGame = game;
    setState(() => _status = 'Pipeline complete! Game saved.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Full Pipeline')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _themeController,
              decoration: const InputDecoration(labelText: 'Theme'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _runPipeline, child: const Text('Run Pipeline')),
            const SizedBox(height: 20),
            Text(_status),
            if (_finalGame != null) ...[
              Text('Game: ${_finalGame!.title}'),
              ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/viewer'), child: const Text('View Game')),
            ],
          ],
        ),
      ),
    );
  }
}
