import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guia/models/motel_model.dart';
import 'package:guia/widgets/promo_card_widget.dart';

class FakeHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

// Mock para evitar erro de carregamento de imagens na rede
Future<void> _mockNetworkImages() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = FakeHttpOverrides();

  // Substitui NetworkImage por uma imagem vazia para evitar erro
  await ui.instantiateImageCodec(Uint8List.fromList([]));
}

void main() {
  setUpAll(() async {
    await _mockNetworkImages(); // Aplica o mock antes dos testes iniciarem
  });

  group('PromoCardWidget', () {
    testWidgets('Renderiza corretamente quando há desconto', (WidgetTester tester) async {
      // Simulando uma suíte com desconto
      final mockSuiteComDesconto = Suite(
        exibirQtdDisponiveis: true,
        nome: "Suíte Luxo",
        fotos: ["https://example.com/suite.jpg"], // Apenas para referência, mas não será carregada
        quantidade: 2,
        categoriaItens: [],
        itens: [],
        periodos: [
          Periodo(
            tempoFormatado: "6 horas",
            tempo: "6",
            valor: 180,
            valorTotal: 180,
            temCortesia: false,
            desconto: Desconto(desconto: 20),
          ),
        ],
      );

      final mockMotel = Motel(
        fantasia: "Motel Exemplo",
        logo: "https://example.com/logo.jpg",
        bairro: "Bairro Teste",
        distancia: 5,
        qtdFavoritos: 10,
        suites: [mockSuiteComDesconto],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PromoCardWidget(motel: mockMotel, suite: mockSuiteComDesconto),
          ),
        ),
      );

      expect(find.text("Motel Exemplo"), findsOneWidget);
      expect(find.text("20% de desconto"), findsOneWidget);
      expect(find.text("a partir de R\$ 180.00"), findsOneWidget);
      expect(find.text("reservar"), findsOneWidget);
    });

    testWidgets('Não renderiza se não houver desconto', (WidgetTester tester) async {
      final mockSuiteSemDesconto = Suite(
        exibirQtdDisponiveis: true,
        nome: "Suíte Standard",
        fotos: ["https://example.com/suite2.jpg"],
        quantidade: 1,
        categoriaItens: [],
        itens: [],
        periodos: [
          Periodo(
            tempoFormatado: "6 horas",
            tempo: "6",
            valor: 180,
            valorTotal: 180,
            temCortesia: false,
            desconto: null, // Sem desconto
          ),
        ],
      );

      final mockMotel = Motel(
        fantasia: "Motel Exemplo",
        logo: "https://example.com/logo.jpg",
        bairro: "Bairro Teste",
        distancia: 5,
        qtdFavoritos: 10,
        suites: [mockSuiteSemDesconto],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PromoCardWidget(motel: mockMotel, suite: mockSuiteSemDesconto),
          ),
        ),
      );

      expect(find.text("Motel Exemplo"), findsNothing);
      expect(find.text("a partir de R\$ 180.00"), findsNothing);
      expect(find.text("reservar"), findsNothing);
    });
  });
}
