import 'package:flutter_test/flutter_test.dart';

import 'package:divisor_cuenta/data/redondeo_exacto.dart';
import 'package:divisor_cuenta/data/redondeo_hacia_arriba.dart';
import 'package:divisor_cuenta/domain/calcular_division.dart';
import 'package:divisor_cuenta/domain/codigo_error_entrada.dart';
import 'package:divisor_cuenta/domain/cuenta.dart';
import 'package:divisor_cuenta/domain/estrategia_redondeo.dart';
import 'package:divisor_cuenta/domain/resultado.dart';
import 'package:divisor_cuenta/domain/validar_entrada.dart';

import 'casos_de_prueba.dart';

class _CalcularDivisionContador extends CalcularDivision {
  int calculos = 0;

  @override
  Resultado calcular(Cuenta cuenta, EstrategiaRedondeo estrategia) {
    calculos++;
    return super.calcular(cuenta, estrategia);
  }
}

String _mensajePara(CodigoErrorEntrada error) => switch (error) {
  CodigoErrorEntrada.montoInvalido => 'Monto inválido',
  CodigoErrorEntrada.personasInsuficientes => 'Debe haber al menos una persona',
  CodigoErrorEntrada.propinaInvalida => 'Propina inválida',
};

void main() {
  for (final caso in casos) {
    test(caso.nombre, () {
      final entrada = ValidarEntrada().validar(
        monto: caso.monto.toString(),
        personas: caso.personas.toString(),
        propina: caso.propina.toString(),
      );
      final calculador = _CalcularDivisionContador();

      if (caso.errorEsperado != null) {
        expect(entrada.error, isNotNull);
        expect(_mensajePara(entrada.error!), caso.errorEsperado);
        expect(entrada.cuenta, isNull);
        expect(calculador.calculos, 0);
        return;
      }

      expect(entrada.error, isNull);
      expect(entrada.cuenta, isNotNull);

      final EstrategiaRedondeo estrategia = switch (caso.modo) {
        'exacto' => const RedondeoExacto(),
        'arriba' => const RedondeoHaciaArriba(),
        _ => throw StateError('Modo de redondeo desconocido: ${caso.modo}'),
      };
      final resultado = calculador.calcular(entrada.cuenta!, estrategia);

      expect(resultado.importePorPersona, closeTo(caso.esperado!, 0.001));
      expect(calculador.calculos, 1);
    });
  }

  test('CalcularDivision acepta ambas estrategias (LSP)', () {
    final calculador = const CalcularDivision();
    final entrada = ValidarEntrada().validar(
      monto: '10',
      personas: '3',
      propina: '0',
    );
    final cuenta = entrada.cuenta!;

    final exacto = calculador.calcular(cuenta, const RedondeoExacto());
    final haciaArriba = calculador.calcular(
      cuenta,
      const RedondeoHaciaArriba(),
    );

    expect(exacto.importePorPersona, closeTo(3.33, 0.001));
    expect(haciaArriba.importePorPersona, closeTo(4, 0.001));
  });
}
