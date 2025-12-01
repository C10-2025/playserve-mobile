class Community {
  final int id;
  final String name;
  final String description;
  final int membersCount;
  final bool isJoined;

  Community({
    required this.id,
    required this.name,
    required this.description,
    required this.membersCount,
    required this.isJoined,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['id'] is int
          ? json['id'] as int
          : int.parse(json['id'].toString()),
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      membersCount: json['members_count'] as int? ?? 0,
      isJoined: json['is_joined'] as bool? ?? false,
    );
  }
}
