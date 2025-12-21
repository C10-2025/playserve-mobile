class ReplyModel {
  final int id;
  final String content;
  final String author;
  final DateTime createdAt;

  ReplyModel({
    required this.id,
    required this.content,
    required this.author,
    required this.createdAt,
  });

  factory ReplyModel.fromJson(Map<String, dynamic> json) {
    return ReplyModel(
      id: json['id'] as int,
      content: json['content'] as String? ?? '',
      author: json['author'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class PostModel {
  final int id;
  final String title;
  final String content;
  final String author;
  final DateTime createdAt;
  final List<ReplyModel> replies;

  PostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
    required this.replies,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final repliesJson = json['replies'] as List<dynamic>? ?? [];
    return PostModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      author: json['author'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      replies: repliesJson
          .map((e) => ReplyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
