import 'package:flutter/material.dart';
import '../services/louvor_service.dart';
import '../models/louvor.dart';
import 'louvor_detail_screen.dart';

class LouvorSearchDelegate extends SearchDelegate<Louvor> {
  final LouvorService louvorService;

  LouvorSearchDelegate(this.louvorService);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Louvor>>(
      future: louvorService.fetchLouvores(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Nenhum louvor encontrado'));
        } else {
          List<Louvor> louvores = snapshot.data!;
          List<Louvor> filteredLouvores = louvores.where((louvor) {
            return louvor.title.toLowerCase().contains(query.toLowerCase()) ||
                   louvor.lyrics.toLowerCase().contains(query.toLowerCase());
          }).toList();

          if (filteredLouvores.isEmpty) {
            return Center(child: Text('Nenhum louvor encontrado com "${query}"'));
          }

          return ListView.builder(
            itemCount: filteredLouvores.length,
            itemBuilder: (context, index) {
              Louvor louvor = filteredLouvores[index];
              return ListTile(
                title: Text(louvor.title),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LouvorDetailScreen(louvor: louvor),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(); // Optional: You can add search suggestions here
  }
}
