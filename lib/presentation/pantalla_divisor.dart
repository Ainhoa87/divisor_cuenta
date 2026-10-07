import 'package:flutter/material.dart';

import 'divisor_controller.dart';
import 'formateador_moneda.dart';

const _tinta = Color(0xFF172B24);
const _verde = Color(0xFF1F7656);
const _fondo = Color(0xFFF6F7F2);

/// Única pantalla; conserva los campos y el resultado durante su vida.
class PantallaDivisor extends StatefulWidget {
  const PantallaDivisor({
    required this.controlador,
    required this.etiquetasEstrategia,
    required this.formateador,
    super.key,
  });

  final DivisorController controlador;
  final Map<String, String> etiquetasEstrategia;
  final FormateadorMoneda formateador;

  @override
  State<PantallaDivisor> createState() => _PantallaDivisorState();
}

class _PantallaDivisorState extends State<PantallaDivisor> {
  final _monto = TextEditingController();
  final _personas = TextEditingController(text: '2');
  final _propina = TextEditingController(text: '10');
  String? _estrategiaId;
  double? _importePorPersona;
  String? _mensajeError;

  @override
  void initState() {
    super.initState();
    final ids = widget.etiquetasEstrategia.keys;
    _estrategiaId = ids.isEmpty ? null : ids.first;
  }

  @override
  void dispose() {
    _monto.dispose();
    _personas.dispose();
    _propina.dispose();
    super.dispose();
  }

  void _limpiarResultado() {
    setState(() {
      _importePorPersona = null;
      _mensajeError = null;
    });
  }

  void _calcular() {
    final estado = widget.controlador.calcular(
      monto: _monto.text,
      personas: _personas.text,
      propina: _propina.text,
      estrategiaId: _estrategiaId ?? '',
    );

    setState(() {
      _importePorPersona = estado.resultado?.importePorPersona;
      _mensajeError = estado.mensajeError;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fondo,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 30),
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3EFE6),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.call_split_rounded,
                        color: _verde,
                        size: 23,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'CUENTA CLARA',
                      style: TextStyle(
                        color: _verde,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Text(
                  'Una cuenta,\ncuentas claras.',
                  style: TextStyle(
                    color: _tinta,
                    fontSize: 34,
                    height: 1.08,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Divide la cuenta sin complicarte.',
                  style: TextStyle(color: Color(0xFF77817A), fontSize: 15),
                ),
                const SizedBox(height: 24),
                _campo(
                  clave: 'monto',
                  etiqueta: 'Monto total',
                  controlador: _monto,
                  teclado: const TextInputType.numberWithOptions(decimal: true),
                  prefijo: '\$ ',
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _campo(
                        clave: 'personas',
                        etiqueta: 'Personas',
                        controlador: _personas,
                        teclado: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _campo(
                        clave: 'propina',
                        etiqueta: 'Propina (%)',
                        controlador: _propina,
                        teclado: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                const Text(
                  'MODO DE REDONDEO',
                  style: TextStyle(
                    color: Color(0xFF6D7971),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.15,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 9),
                Wrap(
                  spacing: 9,
                  children: widget.etiquetasEstrategia.entries.map((entrada) {
                    return ChoiceChip(
                      label: Text(entrada.value),
                      selected: _estrategiaId == entrada.key,
                      onSelected: (_) {
                        setState(() {
                          _estrategiaId = entrada.key;
                          _importePorPersona = null;
                          _mensajeError = null;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _calcular,
                  icon: const Icon(Icons.calculate_outlined),
                  label: const Text('Calcular'),
                  style: FilledButton.styleFrom(
                    backgroundColor: _verde,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                if (_mensajeError != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    key: const ValueKey('error'),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEEEE),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      _mensajeError!,
                      style: const TextStyle(
                        color: Color(0xFF9D3030),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                if (_importePorPersona != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    key: const ValueKey('resultado'),
                    padding: const EdgeInsets.all(21),
                    decoration: BoxDecoration(
                      color: _tinta,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CADA PERSONA PAGA',
                          style: TextStyle(
                            color: Color(0xFFB7C8BD),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 7),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.formateador.formatear(_importePorPersona!),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 52,
                              height: 1.08,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _campo({
    required String clave,
    required String etiqueta,
    required TextEditingController controlador,
    required TextInputType teclado,
    String? prefijo,
  }) {
    return TextField(
      key: ValueKey(clave),
      controller: controlador,
      keyboardType: teclado,
      onChanged: (_) => _limpiarResultado(),
      decoration: InputDecoration(
        labelText: etiqueta,
        prefixText: prefijo,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE5E9E2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE5E9E2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _verde, width: 1.5),
        ),
      ),
    );
  }
}
