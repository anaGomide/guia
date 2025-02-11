import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guia/providers/motel_provider.dart';

void main() {
  late MotelProvider motelProvider;

  setUp(() {
    motelProvider = MotelProvider();
  });

  test('Deve carregar motéis corretamente', () async {
    await motelProvider.loadMoteis();
    expect(motelProvider.moteis.isNotEmpty, true);
  });

  test('Deve filtrar motéis corretamente por faixa de preço', () {
    motelProvider.filterMoteis(
      priceRange: const RangeValues(100, 500),
      periods: [],
      items: [],
      onlyDiscounted: false,
      onlyAvailable: false,
    );

    /// ✅ Agora acessa a lista `filteredMoteis`
    expect(
        motelProvider.moteis
            .every((motel) => motel.suites.any((suite) => suite.periodos.any((periodo) => periodo.valor >= 100 && periodo.valor <= 500))),
        true);
  });

  test('Deve aplicar filtro de "Somente com desconto"', () {
    motelProvider.filterMoteis(
      priceRange: const RangeValues(30, 2030),
      periods: [],
      items: [],
      onlyDiscounted: true,
      onlyAvailable: false,
    );

    /// ✅ Novo teste: Agora verificamos se TODAS as suítes retornadas possuem desconto
    expect(
      motelProvider.moteis.every(
          (motel) => motel.suites.every((suite) => suite.periodos.any((periodo) => periodo.desconto != null && periodo.desconto!.desconto > 0))),
      true,
    );
  });

  test('Deve aplicar filtro de "Somente disponíveis"', () {
    motelProvider.filterMoteis(
      priceRange: const RangeValues(30, 2030),
      periods: [],
      items: [],
      onlyDiscounted: false,
      onlyAvailable: true,
    );

    /// ✅ Agora acessa `moteis` corretamente
    expect(motelProvider.moteis.every((motel) => motel.suites.any((suite) => suite.quantidade > 0)), true);
  });

  test('Deve aplicar filtro de períodos corretamente', () {
    motelProvider.filterMoteis(
      priceRange: const RangeValues(30, 2030),
      periods: ["3 horas"],
      items: [],
      onlyDiscounted: false,
      onlyAvailable: false,
    );

    expect(
      motelProvider.moteis.every((motel) => motel.suites.any((suite) => suite.periodos.any((periodo) => periodo.tempoFormatado == "3 horas"))),
      true,
    );
  });

  test('Deve aplicar filtro de itens da suíte corretamente', () {
    motelProvider.filterMoteis(
      priceRange: const RangeValues(30, 2030),
      periods: [],
      items: ["hidro"],
      onlyDiscounted: false,
      onlyAvailable: false,
    );

    expect(
      motelProvider.moteis.every((motel) => motel.suites
          .any((suite) => suite.categoriaItens.any((categoria) => utf8.decode(categoria.nome.runes.toList()).trim().toLowerCase() == "hidro"))),
      true,
    );
  });
}
