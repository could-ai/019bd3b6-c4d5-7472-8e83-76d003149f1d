import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_model.dart';

class MockLlmService {
  // Mock LLM for mystery generation (replace with real LLM via Supabase Edge Function)
  Future<GameModel> generateMystery(String theme) async {
    // Simulate LLM call
    await Future.delayed(const Duration(seconds: 2));
    return GameModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '$theme Mystery',
      mystery: 'A crime occurred in $theme involving theft and deception.',
      suspects: ['Alice', 'Bob', 'Charlie'],
      culprit: 'Bob',
      motive: 'Financial gain',
      alibis: ['Alice was at home', 'Charlie was at work'],
      clues: ['A fingerprint', 'A hidden note'],
      knowledgeGraph: {
        'characters': {'Alice': 'Innocent witness', 'Bob': 'Culprit', 'Charlie': 'Ally'},
        'facts': ['Crime at night', 'Motive: money'],
        'relationships': {'Bob-Alice': 'Friends'}
      },
      assets: [],
      agents: [],
    );
  }
}

class KnowledgeGraphService {
  // In-memory RAG graph to prevent contradictions
  Map<String, dynamic> graph = {};

  void buildGraph(GameModel game) {
    graph = game.knowledgeGraph;
  }

  String queryTruth(String query) {
    // Simple lookup; in real RAG, this would retrieve relevant nodes
    return graph.toString(); // Placeholder
  }
}

class AssetGeneratorService {
  Future<List<String>> generateAssets(GameModel game) async {
    // Mock: Generate PDF reports and images (use pdf/image packages)
    await Future.delayed(const Duration(seconds: 1));
    return ['police_report.pdf', 'letter.jpg', 'photo.png'];
  }
}

class AgentService {
  Future<List<SuspectAgent>> setupAgents(GameModel game, KnowledgeGraphService graph) async {
    // Mock: Create agents with personalities and knowledge subsets
    await Future.delayed(const Duration(seconds: 1));
    return game.suspects.map((name) {
      return SuspectAgent(
        name: name,
        personality: 'Nervous and evasive',
        knowledgeSet: graph.queryTruth(name).split(','), // Filtered knowledge
      );
    }).toList();
  }

  String chatWithAgent(SuspectAgent agent, String question) {
    // Mock response based on knowledge
    return 'As ${agent.name}, I know: ${agent.knowledgeSet.join(', ')}';
  }
}

class GameStorageService {
  static const String gamesKey = 'generated_games';

  Future<void> saveGame(GameModel game) async {
    final prefs = await SharedPreferences.getInstance();
    final games = await loadGames();
    games.add(game);
    await prefs.setString(gamesKey, jsonEncode(games.map((g) => g.toJson()).toList()));
  }

  Future<List<GameModel>> loadGames() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(gamesKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List;
    return list.map((g) => GameModel.fromJson(g)).toList();
  }
}