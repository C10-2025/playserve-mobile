// Helper model for the previews, directly inferred from review_item at review_list widget
class ReviewPreview {
  final int rating;
  final String username;
  final String comment;

  ReviewPreview({
    required this.rating,
    required this.username,
    required this.comment,
  });
}