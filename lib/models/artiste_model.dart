class Artist {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> genres;
  final int popularity;

  Artist({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.genres,
    required this.popularity,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    List<String> genres = (json['genres'] as List<dynamic>)
        .map((genre) => genre as String)
        .toList();

    return Artist(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['images'] != null && json['images'].isNotEmpty
          ? json['images'][0]['url'] as String
          : 'https://via.placeholder.com/150', // Image par défaut si aucune n'est fournie
      genres: genres,
      popularity: json['popularity'] as int,
    );
  }
}