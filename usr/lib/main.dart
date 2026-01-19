import 'package:flutter/material.dart';
import 'screens/game_generator_screen.dart';
import 'screens/pipeline_screen.dart';
import 'screens/game_viewer_screen.dart';
import 'models/game_model.dart';
import 'services/game_services.dart';

void main() {
  runApp(const CrimeGameGeneratorApp());
}

class CrimeGameGeneratorApp extends StatelessWidget {
  const CrimeGameGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crime Game Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/generator': (context) => const GameGeneratorScreen(),
        '/pipeline': (context) => const PipelineScreen(),
        '/viewer': (context) => const GameViewerScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crime Game Generator')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Generate Automated Crime-Solving Board Games'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/generator'),
              child: const Text('Start New Game'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/pipeline'),
              child: const Text('Run Full Pipeline'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/viewer'),
              child: const Text('View Generated Games'),
            ),
          ],
        ),
      ),
    );
  }
}