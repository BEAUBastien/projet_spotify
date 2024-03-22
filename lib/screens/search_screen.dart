import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchQuery = '';
  String? selectedType; // Type de recherche sélectionné

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Screen'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Search', // Libellé du champ de texte
                border:
                    OutlineInputBorder(), // Style de la bordure du champ de texte
              ),
            ),
          ),
          _buildSearchOption('Albums', 'albums'),
          _buildSearchOption('Artists', 'artists'),
          _buildSearchOption('Tracks', 'tracks'),
          _buildSearchOption('Playlists', 'playlists'),
          ElevatedButton(
            onPressed: () {
              if (selectedType != null) {
                // Naviguer vers l'écran des détails de la recherche en passant la requête de recherche et le type de recherche
                context.go(
                    '/b/searchdetails?query=$searchQuery&type=$selectedType');
              } else {
                // Afficher un message d'erreur si aucun type de recherche n'est sélectionné
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please select a search option')),
                );
              }
            },
            child: Text('Search'), // Texte du bouton de recherche
          ),
        ],
      ),
    );
  }

  Widget _buildSearchOption(String label, String type) {
    return RadioListTile<String>(
      title: Text(label),
      value: type,
      groupValue: selectedType,
      onChanged: (value) {
        setState(() {
          selectedType = value;
        });
      },
    );
  }
}
