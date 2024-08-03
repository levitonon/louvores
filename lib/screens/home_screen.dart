import 'package:flutter/material.dart';
import '../services/louvor_service.dart';
import 'louvor_list_screen.dart';
import 'search.dart';

class HomeScreen extends StatelessWidget {
  final LouvorService louvorService = LouvorService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Louvores'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: LouvorSearchDelegate(louvorService),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCategoryButton(context, 'Coletânea'),
          _buildCategoryButton(context, 'Avulsos'),
          _buildCategoryButton(context, 'Cias'),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(BuildContext context, String category) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 20),
          textStyle: TextStyle(fontSize: 18),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LouvorListScreen(category: category),
            ),
          );
        },
        child: Text(category),
      ),
    );
  }
}
