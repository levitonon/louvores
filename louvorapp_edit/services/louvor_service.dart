import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/louvor.dart';

class LouvorService extends ChangeNotifier {
  List<Louvor> _louvores = [];
  late String _jsonPath;

  List<Louvor> get louvores => _louvores;

  LouvorService() {
    _init();
  }

  Future<void> _init() async {
    _jsonPath = await _localPath;
    await loadLouvores();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path + '/louvores.json';
  }

  Future<void> loadLouvores() async {
    final file = File(_jsonPath);
    if (await file.exists()) {
      final String response = await file.readAsString();
      final List<dynamic> data = json.decode(response);
      _louvores = data.map((item) => Louvor.fromJson(item)).toList();
    } else {
      final String response = await rootBundle.loadString('assets/louvores.json');
      final List<dynamic> data = json.decode(response);
      _louvores = data.map((item) => Louvor.fromJson(item)).toList();
      await file.writeAsString(json.encode(_louvores));
    }
    // Chame notifyListeners fora do carregamento inicial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  List<Louvor> getLouvoresByCategory(String category) {
    return _louvores.where((louvor) => louvor.category == category).toList();
  }

  void updateLouvor(Louvor updatedLouvor) {
    final index = _louvores.indexWhere((louvor) => louvor.title == updatedLouvor.title);
    if (index != -1) {
      _louvores[index] = updatedLouvor;
      _saveLouvores();
      notifyListeners();
    }
  }

  Future<void> _saveLouvores() async {
    try {
      final file = File(_jsonPath);
      String jsonLouvores = json.encode(_louvores);
      print("Caminho do arquivo JSON: ${file.path}");  // Imprime apenas o caminho do arquivo
      await file.writeAsString(jsonLouvores);
    } catch (e) {
      print("Erro ao salvar louvores: $e");
    }
  }
}
