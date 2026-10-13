import '../domain/calcular_division.dart';
import '../domain/codigo_error_entrada.dart';
import '../domain/estrategia_redondeo.dart';
import '../domain/resultado.dart';
import '../domain/validar_entrada.dart';

/// Coordina validación y cálculo sin depender de implementaciones de `data`.
class DivisorController {
  const DivisorController({
    required this.validarEntrada,
    required this.calcularDivision,
    required this.estrategias,
  });

  final ValidarEntrada validarEntrada;
  final CalcularDivision calcularDivision;
  final Map<String, EstrategiaRedondeo> estrategias;

  /// Devuelve un resultado o un mensaje; una entrada inválida no conserva cálculos viejos.
  ({Resultado? resultado, String? mensajeError}) calcular({
    required String monto,
    required String personas,
    required String propina,
    required String estrategiaId,
  }) {
    final entrada = validarEntrada.validar(
      monto: monto,
      personas: personas,
      propina: propina,
    );

    final error = entrada.error;
    if (error != null) {
      return (
        resultado: null,
        mensajeError: entrada.mensajeError ?? _mensajePara(error),
      );
    }

    final cuenta = entrada.cuenta;
    if (cuenta == null) {
      return (resultado: null, mensajeError: 'No se pudo validar la cuenta');
    }

    final estrategia = estrategias[estrategiaId];
    if (estrategia == null) {
      return (resultado: null, mensajeError: 'Seleccione un modo de redondeo');
    }

    return (
      resultado: calcularDivision.calcular(cuenta, estrategia),
      mensajeError: null,
    );
  }

  String _mensajePara(CodigoErrorEntrada error) => switch (error) {
    CodigoErrorEntrada.montoInvalido => 'Monto inválido',
    CodigoErrorEntrada.personasInsuficientes =>
      'Debe haber al menos una persona',
    CodigoErrorEntrada.propinaInvalida => 'Propina inválida',
  };
}
