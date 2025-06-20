import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> players = [
      {'name': 'John', 'score': 95, 'avatar': Icons.person},
      {'name': 'Mary', 'score': 90, 'avatar': Icons.person},
      {'name': 'Peter', 'score': 85, 'avatar': Icons.person},
      {'name': 'Sarah', 'score': 80, 'avatar': Icons.person},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: const Color(0xFF3E5F8A),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(text: 'Local'),
                  Tab(text: 'Global'),
                ],
                labelColor: Color(0xFFF4C430),
                unselectedLabelColor: Colors.white,
                indicatorColor: Color(0xFFF4C430),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: List.generate(players.length, (index) {
                      final player = players[index];
                      return ListTile(
                            leading: CircleAvatar(
                              child: Icon(
                                player['avatar'],
                                color: const Color(0xFF3E5F8A),
                              ),
                            ),
                            title: Text(
                              player['name'],
                              style: const TextStyle(color: Color(0xFF3E5F8A)),
                            ),
                            subtitle: Text(
                              'Score: ${player['score']}',
                              style: const TextStyle(color: Color(0xFF6D9886)),
                            ),
                            trailing: index < 3
                                ? const Icon(
                                    Icons.emoji_events,
                                    color: Color.fromARGB(255, 111, 164, 224),
                                  )
                                : null,
                          )
                          .animate()
                          .fadeIn(duration: 500.ms, delay: (index * 100).ms)
                          .scale();
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
