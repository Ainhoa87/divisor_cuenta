import 'package:flutter_test/flutter_test.dart';

import 'package:divisor_cuenta/data/redondeo_exacto.dart';
import 'package:divisor_cuenta/data/redondeo_hacia_arriba.dart';
import 'package:divisor_cuenta/domain/calcular_division.dart';
import 'package:divisor_cuenta/domain/cuenta.dart';

void main() {
  const calcularDivision = CalcularDivision();

  test('100.00, 4 personas y 10% exacto da 27.50', () {
    final resultado = calcularDivision.calcular(
      const Cuenta(
        montoTotal: 100,
        numeroPersonas: 4,
        porcentajePropina: 10,
      ),
      const RedondeoExacto(),
    );

    expect(resultado.importePorPersona, 27.5);
  });

  test('90.00, 3 personas y 0% exacto da 30.00', () {
    final resultado = calcularDivision.calcular(
      const Cuenta(
        montoTotal: 90,
        numeroPersonas: 3,
        porcentajePropina: 0,
      ),
      const RedondeoExacto(),
    );

    expect(resultado.importePorPersona, 30);
  });

  test('10.00, 3 personas y 0% exacto da 3.33 al formatear', () {
    final resultado = calcularDivision.calcular(
      const Cuenta(
        montoTotal: 10,
        numeroPersonas: 3,
        porcentajePropina: 0,
      ),
      const RedondeoExacto(),
    );

    expect(resultado.importePorPersona.toStringAsFixed(2), '3.33');
  });

  test('10.00, 3 personas y 0% hacia arriba da 4.00', () {
    final resultado = calcularDivision.calcular(
      const Cuenta(
        montoTotal: 10,
        numeroPersonas: 3,
        porcentajePropina: 0,
      ),
      const RedondeoHaciaArriba(),
    );

    expect(resultado.importePorPersona, 4);
  });
}
