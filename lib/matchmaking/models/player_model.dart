class PlayerModel {
  final int id;
  final String username;
  final String rank;
  final String lokasi;
  final String avatar;
  final int kemenangan;
  final String? instagram;

  PlayerModel({
    required this.id,
    required this.username,
    required this.rank,
    required this.lokasi,
    required this.avatar,
    required this.kemenangan,
    this.instagram,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['user_id'],
      username: json['username'],
      rank: json['rank'],
      lokasi: json['lokasi'],
      avatar: json['avatar'],
      kemenangan: json['kemenangan'],
      instagram: json['instagram'],
    );
  }
}
