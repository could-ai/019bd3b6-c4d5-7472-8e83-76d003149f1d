class GameModel {
  final String id;
  final String title;
  final String mystery;
  final List<String> suspects;
  final String culprit;
  final String motive;
  final List<String> alibis;
  final List<String> clues;
  final Map<String, dynamic> knowledgeGraph;
  final List<String> assets; // Paths to generated documents/photos
  final List<SuspectAgent> agents;

  GameModel({
    required this.id,
    required this.title,
    required this.mystery,
    required this.suspects,
    required this.culprit,
    required this.motive,
    required this.alibis,
    required this.clues,
    required this.knowledgeGraph,
    required this.assets,
    required this.agents,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'],
      title: json['title'],
      mystery: json['mystery'],
      suspects: List<String>.from(json['suspects']),
      culprit: json['culprit'],
      motive: json['motive'],
      alibis: List<String>.from(json['alibis']),
      clues: List<String>.from(json['clues']),
      knowledgeGraph: json['knowledgeGraph'],
      assets: List<String>.from(json['assets']),
      agents: (json['agents'] as List).map((a) => SuspectAgent.fromJson(a)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'mystery': mystery,
      'suspects': suspects,
      'culprit': culprit,
      'motive': motive,
      'alibis': alibis,
      'clues': clues,
      'knowledgeGraph': knowledgeGraph,
      'assets': assets,
      'agents': agents.map((a) => a.toJson()).toList(),
    };
  }
}

class SuspectAgent {
  final String name;
  final String personality;
  final List<String> knowledgeSet; // Clues/facts this agent knows

  SuspectAgent({
    required this.name,
    required this.personality,
    required this.knowledgeSet,
  });

  factory SuspectAgent.fromJson(Map<String, dynamic> json) {
    return SuspectAgent(
      name: json['name'],
      personality: json['personality'],
      knowledgeSet: List<String>.from(json['knowledgeSet']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'personality': personality,
      'knowledgeSet': knowledgeSet,
    };
  }
}