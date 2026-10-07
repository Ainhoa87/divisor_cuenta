import 'package:flutter/material.dart';

import 'data/redondeo_exacto.dart';
import 'data/redondeo_hacia_arriba.dart';
import 'domain/calcular_division.dart';
import 'domain/estrategia_redondeo.dart';
import 'domain/validar_entrada.dart';
import 'presentation/divisor_controller.dart';
import 'presentation/formateador_moneda.dart';
import 'presentation/pantalla_divisor.dart';

void main() {
  final estrategias = <String, EstrategiaRedondeo>{
    'exacto': const RedondeoExacto(),
    'hacia-arriba': const RedondeoHaciaArriba(),
  };
  const etiquetas = <String, String>{
    'exacto': 'Exacto',
    'hacia-arriba': 'Hacia arriba',
  };

  final controlador = DivisorController(
    validarEntrada: ValidarEntrada(),
    calcularDivision: const CalcularDivision(),
    estrategias: Map.unmodifiable(estrategias),
  );

  runApp(
    DivideCuentaApp(
      controlador: controlador,
      etiquetasEstrategia: etiquetas,
      formateador: const FormateadorMoneda(),
    ),
  );
}

/// Configura la aplicación con dependencias ya compuestas por `main`.
class DivideCuentaApp extends StatelessWidget {
  const DivideCuentaApp({
    required this.controlador,
    required this.etiquetasEstrategia,
    required this.formateador,
    super.key,
  });

  final DivisorController controlador;
  final Map<String, String> etiquetasEstrategia;
  final FormateadorMoneda formateador;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cuenta Clara',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1F7656)),
        scaffoldBackgroundColor: const Color(0xFFF6F7F2),
      ),
      home: PantallaDivisor(
        controlador: controlador,
        etiquetasEstrategia: etiquetasEstrategia,
        formateador: formateador,
      ),
    );
  }
}
