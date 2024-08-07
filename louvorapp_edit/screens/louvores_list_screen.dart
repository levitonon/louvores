import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/louvor.dart';
import '../services/louvor_service.dart';
import 'louvor_edit_screen.dart';

class LouvoresListScreen extends StatelessWidget {
  final String category;

  LouvoresListScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    final louvorService = Provider.of<LouvorService>(context);
    final louvores = louvorService.getLouvoresByCategory(category);

    return Scaffold(
      appBar: AppBar(
        title: Text('Louvores - $category'),
      ),
      body: ListView.builder(
        itemCount: louvores.length,
        itemBuilder: (context, index) {
          final louvor = louvores[index];
          return ListTile(
            title: Text(louvor.title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LouvorEditScreen(louvor: louvor),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
