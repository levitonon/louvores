import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/louvor.dart';

class LouvorService {
  final String _jsonUrl = 'https://raw.githubusercontent.com/levitonon/louvores/main/louvores_filtered.json';

  Future<List<Louvor>> fetchLouvores() async {
    final response = await http.get(Uri.parse(_jsonUrl));

    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);
      return json.map((data) => Louvor.fromJson(data)).toList();
    } else {
      throw Exception('Falha ao carregar louvores');
    }
  }

  Future<List<Louvor>> fetchLouvoresByCategory(String category) async {
    final louvores = await fetchLouvores();
    return louvores.where((louvor) => louvor.category == category).toList();
  }
}
