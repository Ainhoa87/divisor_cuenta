/// Valores numéricos de una cuenta después de validar las entradas.
class Cuenta {
  const Cuenta({
    required this.montoTotal,
    required this.numeroPersonas,
    required this.porcentajePropina,
  });

  final double montoTotal;
  final int numeroPersonas;
  final double porcentajePropina;
}
