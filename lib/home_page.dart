import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/team.dart';
import '../models/player.dart';
import 'pages/team_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Team> teams = [];
  List<Team> filteredTeams = [];
  List<Player> players = [];
  List<Player> filteredPlayers = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchTeams();
  }

  Future<void> fetchTeams() async {
    final response = await http.get(
      Uri.https('api.balldontlie.io', '/v1/teams'),
      headers: {
        'Authorization': 'c32fac5e-ce59-4ddf-8c01-73c12ed234b5',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      setState(() {
        teams = data.map<Team>((json) => Team.fromJson(json)).toList();
        filteredTeams = teams;
      });
    } else {
      throw Exception('Failed to fetch teams');
    }
  }

  Future<void> fetchPlayers(String query) async {
    final response = await http.get(
      Uri.https('api.balldontlie.io', '/v1/players', {'search': query}),
      headers: {
        'Authorization': 'c32fac5e-ce59-4ddf-8c01-73c12ed234b5',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      setState(() {
        players = data.map<Player>((json) => Player.fromJson(json)).toList();
        filteredPlayers = players;
      });
    } else {
      throw Exception('Failed to fetch players');
    }
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      filteredTeams = teams
          .where((team) =>
              team.fullName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
    fetchPlayers(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NBA Search',
          style: TextStyle(
            fontFamily: 'BebasNeue',
            fontSize: 28,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange[700],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.orange],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: updateSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Search teams or players...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  filled: true,
                  fillColor: Colors.orange[400],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),

            // Search Results
            Expanded(
              child: ListView(
                children: [
                  // Teams Section
                  if (filteredTeams.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Teams',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ...filteredTeams.map((team) {
                    return Card(
                      color: Colors.orange[100],
                      margin: const EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.orange[300],
                          child: Text(
                            team.abbreviation,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          team.fullName,
                          style: const TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text('${team.city}, ${team.conference}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TeamDetailPage(teamId: team.id),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                  if (filteredPlayers.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Players',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ...filteredPlayers.map((player) {
                    return Card(
                      color: Colors.black87,
                      margin: const EdgeInsets.all(8),
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
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
