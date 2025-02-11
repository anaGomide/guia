import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guia/main.dart';
import 'package:guia/models/motel_model.dart';
import 'package:guia/providers/motel_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockMotelProvider extends Mock implements MotelProvider {
  @override
  List<Motel> get moteis => [];
}

void main() {
  testWidgets('A tela principal deve renderizar corretamente', (WidgetTester tester) async {
    final mockMotelProvider = MockMotelProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<MotelProvider>.value(value: mockMotelProvider),
        ],
        child: const MyApp(),
      ),
    );

    expect(find.byType(Scaffold), findsOneWidget);
  });
}
