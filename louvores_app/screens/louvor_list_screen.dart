import 'package:flutter/material.dart';
import '../services/louvor_service.dart';
import '../models/louvor.dart';
import 'louvor_detail_screen.dart';

class LouvorListScreen extends StatelessWidget {
  final String category;
  final LouvorService louvorService = LouvorService();

  LouvorListScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$category Louvores'),
      ),
      body: FutureBuilder<List<Louvor>>(
        future: louvorService.fetchLouvoresByCategory(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum louvor encontrado'));
          } else {
            List<Louvor> louvores = snapshot.data!;

            return ListView.builder(
              itemCount: louvores.length,
              itemBuilder: (context, index) {
                Louvor louvor = louvores[index];
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
      ),
    );
  }
}
