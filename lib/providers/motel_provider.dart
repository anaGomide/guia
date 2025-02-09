import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/motel_model.dart';

class MotelProvider with ChangeNotifier {
  List<Motel> _moteis = [];
  List<Motel> _filteredMoteis = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isFiltered = false;

  // Getters
  List<Motel> get moteis {
    print("Lista de motéis retornada: ${_isFiltered ? '_filteredMoteis (${_filteredMoteis.length})' : '_moteis (${_moteis.length})'}");
    return _isFiltered ? _filteredMoteis : _moteis;
  }

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
        _filteredMoteis = _moteis; // Inicializa a lista filtrada com todos os motéis
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

  // Método para filtrar motéis
  void filterMoteis({
    required RangeValues priceRange,
    required List<String> periods,
    required List<String> items,
    required bool onlyDiscounted,
    required bool onlyAvailable,
  }) {
    print("Filtros aplicados:");
    print("Faixa de preço: ${priceRange.start} - ${priceRange.end}");
    print("Períodos selecionados: $periods");
    print("Itens selecionados: $items");
    print("Somente com desconto: $onlyDiscounted");
    print("Somente disponíveis: $onlyAvailable");

    _filteredMoteis = _moteis
        .map((motel) {
          final filteredSuites = motel.suites.where((suite) {
            final inPriceRange = suite.periodos.any((periodo) => periodo.valor >= priceRange.start && periodo.valor <= priceRange.end);
            final matchesPeriod = periods.isEmpty || suite.periodos.any((periodo) => periods.contains(periodo.tempoFormatado));
            final matchesItems = items.isEmpty || items.every((item) => suite.itens.any((i) => i.nome == item));
            final hasDiscount = !onlyDiscounted || suite.periodos.any((periodo) => periodo.desconto != null);
            final isAvailable = !onlyAvailable || suite.quantidade > 0;

            return inPriceRange && matchesPeriod && matchesItems && hasDiscount && isAvailable;
          }).toList();

          return Motel(
            fantasia: motel.fantasia,
            logo: motel.logo,
            bairro: motel.bairro,
            distancia: motel.distancia,
            qtdFavoritos: motel.qtdFavoritos,
            suites: filteredSuites,
          );
        })
        .where((motel) => motel.suites.isNotEmpty)
        .toList();

    _isFiltered = true; // Marca que os filtros foram aplicados
    print("Motéis após filtragem: ${_filteredMoteis.length}");
    notifyListeners();
  }

  List<Suite> getTodasSuitesComDesconto() {
    // Lista para armazenar todas as suítes com desconto
    final List<Suite> suitesComDesconto = [];

    for (var motel in _moteis) {
      for (var suite in motel.suites) {
        // Verifica se a suíte possui algum período com desconto
        if (suite.periodos.any((periodo) => periodo.desconto != null)) {
          suitesComDesconto.add(suite);
        }
      }
    }

    return suitesComDesconto;
  }
}
