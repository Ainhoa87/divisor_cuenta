/// Convierte un importe numérico a la presentación USD de la pantalla.
class FormateadorMoneda {
  const FormateadorMoneda();

  /// Devuelve el símbolo y dos decimales sin alterar el valor original.
  String formatear(double importe) => '\$${importe.toStringAsFixed(2)}';
}
