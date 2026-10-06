import 'package:flutter_test/flutter_test.dart';

import 'package:divisor_cuenta/main.dart';

void main() {
  testWidgets('muestra la pantalla para dividir la cuenta', (tester) async {
    await tester.pumpWidget(const DivideCuentaApp());

    expect(find.text('CUENTA CLARA'), findsOneWidget);
    expect(find.text('¿CUÁNTAS PERSONAS?'), findsOneWidget);
    expect(find.text('CADA PERSONA PAGA'), findsOneWidget);
  });
}
