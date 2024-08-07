import 'package:flutter/material.dart';
import 'package:provider/provider.dart';  // Adicione esta linha

import 'screens/home_screen.dart';
import 'services/louvor_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LouvorService(),
      child: MaterialApp(
        title: 'Louvores App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
