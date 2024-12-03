import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/team.dart';
import 'player_list_page.dart';

class TeamDetailPage extends StatelessWidget {
  final int teamId;

  const TeamDetailPage({super.key, required this.teamId});

  Future<Team> fetchTeamDetails() async {
    final response = await http.get(
      Uri.https('api.balldontlie.io', '/v1/teams/$teamId'),
      headers: {
        'Authorization': 'c32fac5e-ce59-4ddf-8c01-73c12ed234b5',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return Team(
        id: data['id'],
        name: data['name'],
        fullName: data['full_name'],
        city: data['city'],
        conference: data['conference'],
        division: data['division'],
        abbreviation: '',
      );
    } else {
      throw Exception('Failed to fetch team details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Details'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<Team>(
        future: fetchTeamDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final team = snapshot.data!;
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.orange],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        team.fullName,
                        style: const TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 40,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'City: ${team.city}',
                        style: const TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Conference: ${team.conference}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Division: ${team.division}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PlayerListPage(teamId: team.id),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[700],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'View Players',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: Text('Team details unavailable'));
          }
        },
      ),
    );
  }
}
