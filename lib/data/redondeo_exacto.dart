import '../domain/estrategia_redondeo.dart';

/// Mantiene el valor calculado; la presentación decide cómo mostrar decimales.
class RedondeoExacto implements EstrategiaRedondeo {
  const RedondeoExacto();

  @override
  double redondear(double importePorPersona) =>
      (importePorPersona * 100).round() / 100;
}
