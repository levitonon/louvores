import 'package:flutter/material.dart';
import 'louvores_list_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Louvores'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Coletânea'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LouvoresListScreen(category: 'Coletânea'),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: Text('Avulsos'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LouvoresListScreen(category: 'Avulsos'),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: Text('Cias'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LouvoresListScreen(category: 'Cias'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
