import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/motel_model.dart';

class MotelProvider with ChangeNotifier {
  List<Motel> _moteis = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Motel> get moteis => _moteis;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Moteis com promoções
  List<Motel> get moteisComPromocoes {
    return _moteis.where((motel) {
      return motel.suites.any((suite) {
        return suite.periodos.any((periodo) => periodo.desconto != null);
      });
    }).toList();
  }

  // Método para carregar motéis
  Future<void> loadMoteis() async {
    _setLoading(true);

    try {
      final response = await _fetchDataFromApi("https://www.jsonkeeper.com/b/1IXK");
      if (response != null) {
        final data = response['data']['moteis'];
        _moteis = (data as List).map((motel) => Motel.fromJson(motel)).toList();
        _errorMessage = null; // Limpa mensagens de erro ao carregar com sucesso
      } else {
        _moteis = [];
        _errorMessage = "Erro ao carregar motéis.";
      }
    } catch (e) {
      _moteis = [];
      _errorMessage = "Erro: ${e.toString()}";
    } finally {
      _setLoading(false);
    }
  }

  // Função para buscar os dados da API
  Future<Map<String, dynamic>?> _fetchDataFromApi(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Erro na API: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Erro ao buscar dados: $e");
    }
  }

  // Método para atualizar o estado de carregamento
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
