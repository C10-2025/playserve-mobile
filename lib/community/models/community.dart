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
      id: json['id'] as int,
      name: json['name'] as String,
      description: (json['description'] ?? '') as String,
      membersCount: (json['members_count'] ?? 0) as int,
      isJoined: (json['is_joined'] ?? false) as bool,
    );
  }
}