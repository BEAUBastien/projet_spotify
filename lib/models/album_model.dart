class Track {
  final String name;
  final String previewUrl;

  Track({
    required this.name,
    required this.previewUrl,
  });
}

class Album {
  final String id;
  final String title;
  final String imageUrl;
  final List<String>? artists;
  final List<String>? artistsId;
  final List<Track>? tracks;

  Album({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.artists,
    this.artistsId,
    this.tracks,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    List<String>? artists = json['artists'] != null
        ? (json['artists'] as List)
            .map((artist) => artist['name'] as String)
            .toList()
        : null;
    List<String>? artistsId = json['artists'] != null
        ? (json['artists'] as List)
            .map((artistId) =>
                artistId['id'] as String)
            .toList()
        : null;
    List<Track>? tracks =
        json.containsKey('tracks') && json['tracks']['items'] != null
            ? (json['tracks']['items'] as List).map((trackJson) {
                return Track(
                  name: trackJson['name'] as String,
                  previewUrl: trackJson['preview_url'] as String,
                );
              }).toList()
            : null;

    return Album(
      id: json['id'],
      title: json['name'],
      imageUrl: json['images'] != null && json['images'].isNotEmpty
          ? json['images'][0]['url']
          : 'https://via.placeholder.com/150',
      artists: artists,
      artistsId: artistsId,
      tracks: tracks,
    );
  }

  void playTrack(int index) {
    if (tracks != null && index >= 0 && index < tracks!.length) {
      final String previewUrl = tracks![index].previewUrl;
      if (previewUrl.isNotEmpty) {
        // Jouer la piste avec l'URL de prévisualisation
        print('Playing track with preview URL: $previewUrl');
        // Ajoutez votre logique de lecture de piste ici
      } else {
        print('Preview URL is not available for this track');
      }
    } else {
      print('Invalid track index');
    }
  }
}
