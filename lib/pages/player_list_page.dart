import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/player.dart';

class PlayerListPage extends StatelessWidget {
  final int teamId;

  const PlayerListPage({super.key, required this.teamId});

  Future<List<Player>> fetchPlayers() async {
    final response = await http.get(
      Uri.https('api.balldontlie.io', '/v1/players', {'team_ids[]': '$teamId'}),
      headers: {
        'Authorization': 'c32fac5e-ce59-4ddf-8c01-73c12ed234b5',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return data.map<Player>((json) => Player.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch players');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Players'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Player>>(
        future: fetchPlayers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final players = snapshot.data!;
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.orange],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final player = players[index];
                  return Card(
                    color: Colors.black87,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange,
                        child: Text(
                          player.position,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      title: Text(
                        '${player.firstName} ${player.lastName}',
                        style: const TextStyle(
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Team: ${player.team.fullName}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: Text(
                        'No. ${player.jerseyNumber}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      onTap: () {},
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(child: Text('No players found'));
          }
        },
      ),
    );
  }
}
