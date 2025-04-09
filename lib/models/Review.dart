class Review {
  String author;
  String content;
  DateTime date;
  String avatarUrl;
  List<String> photoUrls;
  List<String> videoUrls;

  Review({
    required this.author,
    required this.content,
    required this.date,
    required this.avatarUrl,
    required this.photoUrls,
    required this.videoUrls,
  });

  // Factory function to create Review from JSON
  factory Review.fromJson(Map<String, dynamic> data) {
    return Review(
      author: data['reviewer']['name'] ?? 'Anonymous',
      content: data['body'] ?? '',
      date: DateTime.parse(data['created_at']),
      avatarUrl: data['reviewer']['avatar'] ?? '',
      photoUrls: (data['photos'] as List<dynamic>?)
          ?.map((photo) => photo['url'] as String)
          .toList() ?? [],
      videoUrls: (data['videos'] as List<dynamic>?)
          ?.map((video) => video['url'] as String)
          .toList() ?? [],
    );
  }
}