class Player {
  final int id;
  final String firstName;
  final String lastName;
  final String position; // e.g., "G" (Guard)
  final String? height; // e.g., "6-2", bisa null
  final String? weight; // e.g., "185", bisa null
  final String? jerseyNumber; // Nomor jersey, bisa null
  final String? college; // Nama kampus, bisa null
  final String? country; // Negara asal, bisa null
  final int? draftYear; // Tahun draft, bisa null
  final int? draftRound; // Round draft, bisa null
  final int? draftNumber; // Pick draft, bisa null
  final PlayerTeam team; // Informasi tim pemain

  Player({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.position,
    this.height,
    this.weight,
    this.jerseyNumber,
    this.college,
    this.country,
    this.draftYear,
    this.draftRound,
    this.draftNumber,
    required this.team,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      position: json['position'] ?? 'Unknown',
      height: json['height'] as String?,
      weight: json['weight'] as String?,
      jerseyNumber: json['jersey_number'] as String?,
      college: json['college'] as String?,
      country: json['country'] as String?,
      draftYear: json['draft_year'] as int?,
      draftRound: json['draft_round'] as int?,
      draftNumber: json['draft_number'] as int?,
      team: PlayerTeam.fromJson(json['team']),
    );
  }
}

class PlayerTeam {
  final int id;
  final String name;
  final String fullName;

  PlayerTeam({
    required this.id,
    required this.name,
    required this.fullName,
  });

  factory PlayerTeam.fromJson(Map<String, dynamic> json) {
    return PlayerTeam(
      id: json['id'],
      name: json['name'],
      fullName: json['full_name'],
    );
  }
}
