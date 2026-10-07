import 'cuenta.dart';
import 'estrategia_redondeo.dart';
import 'resultado.dart';

/// Calcula el reparto de una cuenta que ya fue validada.
class CalcularDivision {
  const CalcularDivision();

  /// Suma la propina, divide el total y delega el redondeo elegido.
  Resultado calcular(Cuenta cuenta, EstrategiaRedondeo estrategia) {
    final totalConPropina =
        cuenta.montoTotal + cuenta.montoTotal * cuenta.porcentajePropina / 100;
    final importeBasePorPersona = totalConPropina / cuenta.numeroPersonas;

    return Resultado(
      totalConPropina: totalConPropina,
      importePorPersona: estrategia.redondear(importeBasePorPersona),
    );
  }
}
