import '../domain/estrategia_redondeo.dart';

/// Eleva el importe individual al entero siguiente si tiene fracción.
class RedondeoHaciaArriba implements EstrategiaRedondeo {
  const RedondeoHaciaArriba();

  @override
  double redondear(double importePorPersona) =>
      importePorPersona.ceil().toDouble();
}
