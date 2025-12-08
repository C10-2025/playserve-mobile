import 'playing_field.dart';

class PaginatedFieldsResponse {
  final List<PlayingField> fields;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasNext;
  final bool hasPrevious;

  PaginatedFieldsResponse({
    required this.fields,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginatedFieldsResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedFieldsResponse(
      fields: (json['data'] as List)
          .map((field) => PlayingField.fromJson(field))
          .toList(),
      currentPage: json['pagination']['page'],
      totalPages: json['pagination']['total_pages'],
      totalItems: json['pagination']['total_items'],
      hasNext: json['pagination']['has_next'],
      hasPrevious: json['pagination']['has_previous'],
    );
  }
}
