/// Contrato para ajustar el importe individual después de dividir la cuenta.
///
/// Las implementaciones concretas viven en `data`; el dominio solo conoce
/// esta operación para que las estrategias puedan sustituirse entre sí.
abstract interface class EstrategiaRedondeo {
  /// Recibe el importe sin redondear y devuelve el importe ajustado.
  double redondear(double importePorPersona);
}
