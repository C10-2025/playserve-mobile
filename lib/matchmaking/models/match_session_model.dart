class MatchSessionModel {
  final bool hasSession;
  final int? sessionId;
  final PlayerMini? player1;
  final PlayerMini? player2;
  final bool? youArePlayer1;

  MatchSessionModel({
    required this.hasSession,
    this.sessionId,
    this.player1,
    this.player2,
    this.youArePlayer1,
  });

  factory MatchSessionModel.fromJson(Map<String, dynamic> json) {
    return MatchSessionModel(
      hasSession: json['has_session'],
      sessionId: json['session_id'],
      youArePlayer1: json['you_are_player1'],
      player1: json['player1'] == null
          ? null
          : PlayerMini.fromJson(json['player1']),
      player2: json['player2'] == null
          ? null
          : PlayerMini.fromJson(json['player2']),
    );
  }
}

class PlayerMini {
  final int id;
  final String username;

  PlayerMini({
    required this.id,
    required this.username,
  });

  factory PlayerMini.fromJson(Map<String, dynamic> json) {
    return PlayerMini(
      id: json['id'],
      username: json['username'],
    );
  }
}
