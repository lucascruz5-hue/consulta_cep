import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:consulta_cep/main.dart';

void main() {
  testWidgets('Verifica a presenca dos campos e componentes principais', (WidgetTester tester) async {
    // Constrói a tela da aplicação
    await tester.pumpWidget(const ConsultaCepApp());
    await tester.pumpAndSettle();

    // 1. Verifica título na AppBar
    expect(find.text('Consulta de CEP'), findsOneWidget);

    // 2. Verifica campo de CEP e botão Consultar
    expect(find.widgetWithText(TextField, 'CEP'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Consultar CEP'), findsOneWidget);
    expect(find.widgetWithText(OutlinedButton, 'Limpar'), findsOneWidget);

    // 3. Verifica os campos obrigatórios em TextFields separados:
    // logradouro, bairro, localidade e uf
    expect(find.widgetWithText(TextField, 'Logradouro (Rua, Avenida, etc.)'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Bairro'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Localidade (Cidade)'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'UF (Estado)'), findsOneWidget);
  });
}
