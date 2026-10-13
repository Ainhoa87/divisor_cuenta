import 'codigo_error_entrada.dart';
import 'cuenta.dart';

/// Convierte y valida los textos recibidos desde el formulario.
class ValidarEntrada {
  /// Devuelve una cuenta válida o un código de error, nunca ambos.
  ({Cuenta? cuenta, CodigoErrorEntrada? error, String? mensajeError}) validar({
    required String monto,
    required String personas,
    required String propina,
  }) {
    final montoTotal = _leerNumero(monto);
    if (montoTotal == null || montoTotal < 0) {
      return (
        cuenta: null,
        error: CodigoErrorEntrada.montoInvalido,
        mensajeError: null,
      );
    }

    final numeroPersonas = int.tryParse(personas.trim());
    if (numeroPersonas == null || numeroPersonas < 1) {
      return (
        cuenta: null,
        error: CodigoErrorEntrada.personasInsuficientes,
        mensajeError: null,
      );
    }

    final porcentajePropina = _leerNumero(propina);
    if (porcentajePropina == null || porcentajePropina < 0) {
      return (
        cuenta: null,
        error: CodigoErrorEntrada.propinaInvalida,
        mensajeError: null,
      );
    }
    if (porcentajePropina > 100) {
      return (
        cuenta: null,
        error: CodigoErrorEntrada.propinaInvalida,
        mensajeError: 'La propina no puede superar el 100%',
      );
    }

    return (
      cuenta: Cuenta(
        montoTotal: montoTotal,
        numeroPersonas: numeroPersonas,
        porcentajePropina: porcentajePropina,
      ),
      error: null,
      mensajeError: null,
    );
  }

  double? _leerNumero(String texto) {
    final numero = double.tryParse(texto.trim().replaceAll(',', '.'));
    if (numero == null || !numero.isFinite) return null;
    return numero;
  }
}
