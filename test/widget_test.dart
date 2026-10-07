import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:divisor_cuenta/main.dart';
import 'package:divisor_cuenta/data/redondeo_exacto.dart';
import 'package:divisor_cuenta/data/redondeo_hacia_arriba.dart';
import 'package:divisor_cuenta/domain/calcular_division.dart';
import 'package:divisor_cuenta/domain/validar_entrada.dart';
import 'package:divisor_cuenta/presentation/divisor_controller.dart';
import 'package:divisor_cuenta/presentation/formateador_moneda.dart';

DivideCuentaApp _crearApp() {
  const etiquetas = {'exacto': 'Exacto', 'hacia-arriba': 'Hacia arriba'};
  final controlador = DivisorController(
    validarEntrada: ValidarEntrada(),
    calcularDivision: const CalcularDivision(),
    estrategias: const {
      'exacto': RedondeoExacto(),
      'hacia-arriba': RedondeoHaciaArriba(),
    },
  );
  return DivideCuentaApp(
    controlador: controlador,
    etiquetasEstrategia: etiquetas,
    formateador: const FormateadorMoneda(),
  );
}

Future<void> _calcular(
  WidgetTester tester, {
  required String monto,
  required String personas,
  required String propina,
  bool haciaArriba = false,
}) async {
  await tester.pumpWidget(_crearApp());
  await tester.enterText(find.byKey(const ValueKey('monto')), monto);
  await tester.enterText(find.byKey(const ValueKey('personas')), personas);
  await tester.enterText(find.byKey(const ValueKey('propina')), propina);
  if (haciaArriba) {
    await tester.tap(find.text('Hacia arriba'));
  } else {
    await tester.tap(find.text('Exacto'));
  }
  await tester.tap(find.text('Calcular'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('divide 100.00 entre 4 con 10% exacto', (tester) async {
    await _calcular(
      tester,
      monto: '100.00',
      personas: '4',
      propina: '10',
    );

    expect(find.text(r'$27.50'), findsOneWidget);
  });

  testWidgets('divide 90.00 entre 3 sin propina', (tester) async {
    await _calcular(
      tester,
      monto: '90.00',
      personas: '3',
      propina: '0',
    );

    expect(find.text(r'$30.00'), findsOneWidget);
  });

  testWidgets('muestra dos decimales para 10.00 entre 3 en modo exacto', (
    tester,
  ) async {
    await _calcular(
      tester,
      monto: '10.00',
      personas: '3',
      propina: '0',
    );

    expect(find.text(r'$3.33'), findsOneWidget);
  });

  testWidgets('redondea 10.00 entre 3 hacia arriba a 4.00', (tester) async {
    await _calcular(
      tester,
      monto: '10.00',
      personas: '3',
      propina: '0',
      haciaArriba: true,
    );

    expect(find.text(r'$4.00'), findsOneWidget);
  });

  testWidgets('cero personas muestra error y oculta el resultado', (tester) async {
    await _calcular(
      tester,
      monto: '50.00',
      personas: '0',
      propina: '0',
    );

    expect(find.text('Debe haber al menos una persona'), findsOneWidget);
    expect(find.byKey(const ValueKey('resultado')), findsNothing);
  });

  testWidgets('monto no numérico muestra error y oculta el resultado', (
    tester,
  ) async {
    await _calcular(
      tester,
      monto: 'abc',
      personas: '2',
      propina: '0',
    );

    expect(find.text('Monto inválido'), findsOneWidget);
    expect(find.byKey(const ValueKey('resultado')), findsNothing);
  });

  testWidgets('calcula sin crear clientes HTTP', (tester) async {
    await HttpOverrides.runZoned(
      () => _calcular(
        tester,
        monto: '90.00',
        personas: '3',
        propina: '0',
      ),
      createHttpClient: (_) => throw StateError('La app no debe usar la red'),
    );

    expect(find.text(r'$30.00'), findsOneWidget);
  });
}
