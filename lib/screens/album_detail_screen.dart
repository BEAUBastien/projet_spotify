import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:projet_spotify_gorouter/provider.dart';
import '/providers/spotify_provider.dart';
import '/models/album_model.dart';
import '/models/artiste_model.dart'; // Assurez-vous que le chemin est correct
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class AlbumDetailScreen extends StatefulWidget {
  final String id;

  const AlbumDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  late Future<Album> _albumFuture;
  late AudioPlayer _audioPlayer;

  final ApiService apiService = ApiService("https://api.spotify.com/v1");

  @override
  void initState() {
    super.initState();
    _albumFuture = apiService.fetchAlbumDetails(widget.id);
    _audioPlayer = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Album Detail')),
      body: FutureBuilder<Album>(
        future: _albumFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (snapshot.hasData) {
            Album album = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  Text(album.title,
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.0),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal:
                            2.0), // Ajoutez cette ligne pour spécifier les marges réduites autour de l'image
                    child: Image.network(album.imageUrl),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      // Joue la première piste de l'album (indice 0)
                      if (album.tracks != null && album.tracks!.isNotEmpty) {
                        await _audioPlayer.setUrl(album.tracks![0].previewUrl);
                        _audioPlayer.play();
                      }
                    },
                    child: const Text('Play Track'),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      _audioPlayer.pause();
                    },
                    child: const Text('Pause'),
                  ),
                  SizedBox(height: 20.0),
                  if (album.artists != null) ...[
                    Text('Artists:',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8.0),
                    Column(
                      children:
                          album.artists!.map((artist) => Text(artist)).toList(),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        if (album.artistsId != null &&
                            album.artistsId!.isNotEmpty) {
                          String artistId = album.artistsId![
                              0]; // Accéder au premier ID de la liste
                          print(artistId);
                          context.go('/a/artistedetails/$artistId');
                        }
                      },
                      child: const Text('Go Artiste Detail'),
                    ),
                    SizedBox(height: 20.0),
                  ],
                  if (album.artistsId != null) ...[
                    Text('Artists IDs:',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8.0),
                    Column(
                      children: album.artistsId!
                          .map((artistId) => Text(artistId.toString()))
                          .toList(),
                    ),
                    SizedBox(height: 20.0),
                  ],
                  if (album.tracks != null) ...[
                    Text('Tracks:',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8.0),
                    Column(
                      children: album.tracks!.map((track) {
                        return Column(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                if (track.previewUrl.isNotEmpty) {
                                  await _audioPlayer.setUrl(track.previewUrl);
                                  _audioPlayer.play();
                                } else {
                                  print(
                                      'Preview URL is not available for this track');
                                }
                              },
                              child: Text(track.name),
                            ),
                            SizedBox(
                                height:
                                    8.0), // Espacement entre les boutons de piste
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            );
          } else {
            return Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}
