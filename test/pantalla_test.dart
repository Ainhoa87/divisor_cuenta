import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:divisor_cuenta/data/redondeo_exacto.dart';
import 'package:divisor_cuenta/data/redondeo_hacia_arriba.dart';
import 'package:divisor_cuenta/domain/calcular_division.dart';
import 'package:divisor_cuenta/domain/estrategia_redondeo.dart';
import 'package:divisor_cuenta/domain/validar_entrada.dart';
import 'package:divisor_cuenta/presentation/divisor_controller.dart';
import 'package:divisor_cuenta/presentation/formateador_moneda.dart';
import 'package:divisor_cuenta/presentation/pantalla_divisor.dart';

Widget _crearAplicacion() {
  final estrategias = <String, EstrategiaRedondeo>{
    'exacto': const RedondeoExacto(),
    'hacia-arriba': const RedondeoHaciaArriba(),
  };
  const etiquetas = <String, String>{
    'exacto': 'Exacto',
    'hacia-arriba': 'Hacia arriba',
  };
  final controlador = DivisorController(
    validarEntrada: ValidarEntrada(),
    calcularDivision: const CalcularDivision(),
    estrategias: estrategias,
  );

  return MaterialApp(
    home: PantallaDivisor(
      controlador: controlador,
      etiquetasEstrategia: etiquetas,
      formateador: const FormateadorMoneda(),
    ),
  );
}

void main() {
  testWidgets('calcula y muestra el importe por persona', (tester) async {
    await tester.pumpWidget(_crearAplicacion());

    await tester.enterText(find.byKey(const ValueKey('monto')), '100');
    await tester.enterText(find.byKey(const ValueKey('personas')), '4');
    await tester.enterText(find.byKey(const ValueKey('propina')), '10');
    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();

    expect(find.text('\$27.50'), findsOneWidget);
  });

  testWidgets('muestra error para cero personas sin mostrar resultado', (
    tester,
  ) async {
    await tester.pumpWidget(_crearAplicacion());

    await tester.enterText(find.byKey(const ValueKey('monto')), '50');
    await tester.enterText(find.byKey(const ValueKey('personas')), '0');
    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();

    expect(find.text('Debe haber al menos una persona'), findsOneWidget);
    expect(find.byKey(const ValueKey('resultado')), findsNothing);
  });

  testWidgets('muestra error para un monto no numérico', (tester) async {
    await tester.pumpWidget(_crearAplicacion());

    await tester.enterText(find.byKey(const ValueKey('monto')), 'abc');
    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();

    expect(find.text('Monto inválido'), findsOneWidget);
  });
}
