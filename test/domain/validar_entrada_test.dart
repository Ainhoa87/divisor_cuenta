import 'package:flutter_test/flutter_test.dart';

import 'package:divisor_cuenta/domain/codigo_error_entrada.dart';
import 'package:divisor_cuenta/domain/validar_entrada.dart';

void main() {
  final validar = ValidarEntrada();

  test('rechaza montos vacíos, no numéricos y negativos', () {
    for (final monto in ['', 'abc', '-1']) {
      final entrada = validar.validar(
        monto: monto,
        personas: '2',
        propina: '0',
      );

      expect(entrada.cuenta, isNull);
      expect(entrada.error, CodigoErrorEntrada.montoInvalido);
    }
  });

  test('rechaza cero personas y valores que no sean enteros', () {
    for (final personas in ['0', '-2', '1.5', 'abc']) {
      final entrada = validar.validar(
        monto: '10',
        personas: personas,
        propina: '0',
      );

      expect(entrada.cuenta, isNull);
      expect(entrada.error, CodigoErrorEntrada.personasInsuficientes);
    }
  });

  test('rechaza propina no numérica o negativa', () {
    for (final propina in ['abc', '-1']) {
      final entrada = validar.validar(
        monto: '10',
        personas: '2',
        propina: propina,
      );

      expect(entrada.cuenta, isNull);
      expect(entrada.error, CodigoErrorEntrada.propinaInvalida);
    }
  });
}
