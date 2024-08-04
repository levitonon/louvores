import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/louvor.dart';

class LouvorService {
  final String _avulsosJsonUrl = 'https://raw.githubusercontent.com/levitonon/louvores/main/louvores.json';
  final String _coletaneaJsonUrl = 'https://raw.githubusercontent.com/levitonon/louvores/main/louvores_filtered.json';

  Future<List<Louvor>> fetchLouvoresAvulsos() async {
    final response = await http.get(Uri.parse(_avulsosJsonUrl));

    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);
      return json.map((data) => Louvor.fromJson(data)).toList();
    } else {
      throw Exception('Falha ao carregar louvores avulsos');
    }
  }

  Future<List<Louvor>> fetchLouvoresColetanea() async {
    final response = await http.get(Uri.parse(_coletaneaJsonUrl));

    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);
      return json.map((data) => Louvor.fromJson(data)).toList();
    } else {
      throw Exception('Falha ao carregar louvores da coletânea');
    }
  }

  Future<List<Louvor>> fetchLouvoresByCategory(String category) async {
    switch (category) {
      case 'Avulsos':
        return await fetchLouvoresAvulsos();
      case 'Coletânea':
        return await fetchLouvoresColetanea();
      default:
        return [];
    }
  }

  Future<List<Louvor>> fetchLouvores() async {
    List<Louvor> avulsos = await fetchLouvoresAvulsos();
    List<Louvor> coletanea = await fetchLouvoresColetanea();
    return avulsos + coletanea;
  }
}
