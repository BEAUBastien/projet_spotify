import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/providers/spotify_provider.dart'; // Importation de ApiService
import '/models/album_model.dart'; // Importation de Album depuis le dossier models

class AlbumNewsScreen extends StatelessWidget {
  final ApiService apiService = ApiService("https://api.spotify.com/v1");

  // Suppression du mot-clé 'const' du constructeur
  AlbumNewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Album News')),
      body: FutureBuilder<List<Album>>(
        future: apiService.fetchNewReleases(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Album album = snapshot.data![index];
                return ListTile(
                  leading: Image.network(album.imageUrl, width: 56, height: 56, errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  }),
                  title: Text(album.title),
                   onTap: () {
                    // Utilisez un ID hardcodé temporairement pour tester
                    context.go('/a/albumdetails/${album.id}');
                  }, 
                );
              },
            );
          } else {
            return const Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}