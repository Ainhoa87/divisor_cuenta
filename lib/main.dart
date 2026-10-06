import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const DivideCuentaApp());

const _ink = Color(0xFF172B24);
const _green = Color(0xFF1F7656);
const _paper = Color(0xFFF6F7F2);

class DivideCuentaApp extends StatelessWidget {
  const DivideCuentaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cuenta Clara',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: _paper,
        colorScheme: ColorScheme.fromSeed(seedColor: _green, brightness: Brightness.light),
        fontFamily: 'Roboto',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE5E9E2))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: _green, width: 1.5)),
        ),
      ),
      home: const SplitBillPage(),
    );
  }
}

class SplitBillPage extends StatefulWidget {
  const SplitBillPage({super.key});

  @override
  State<SplitBillPage> createState() => _SplitBillPageState();
}

class _SplitBillPageState extends State<SplitBillPage> {
  final _amountController = TextEditingController();
  final _amountFocus = FocusNode();
  int _people = 2;
  int _tipPercent = 10;

  double get _subtotal => double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0;
  double get _tip => _subtotal * _tipPercent / 100;
  double get _total => _subtotal + _tip;
  double get _perPerson => _total / _people;

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocus.dispose();
    super.dispose();
  }

  String _money(double value) => '\$${value.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 30),
              children: [
                Row(children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(color: const Color(0xFFE3EFE6), borderRadius: BorderRadius.circular(15)),
                    child: const Icon(Icons.call_split_rounded, color: _green, size: 23),
                  ),
                  const SizedBox(width: 12),
                  const Text('CUENTA CLARA', style: TextStyle(color: _green, fontWeight: FontWeight.w800, letterSpacing: 1.5, fontSize: 13)),
                  const Spacer(),
                  const Icon(Icons.more_horiz_rounded, color: Color(0xFF748078)),
                ]),
                const SizedBox(height: 32),
                const Text('Una cuenta,\ncuentas claras.', style: TextStyle(color: _ink, fontSize: 34, height: 1.08, fontWeight: FontWeight.w800, letterSpacing: -1.2)),
                const SizedBox(height: 9),
                const Text('Divide la cuenta sin complicarte.', style: TextStyle(color: Color(0xFF77817A), fontSize: 15)),
                const SizedBox(height: 28),
                _sectionLabel('TOTAL DE LA CUENTA'),
                const SizedBox(height: 10),
                TextField(
                  controller: _amountController,
                  focusNode: _amountFocus,
                  onChanged: (_) => setState(() {}),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                  style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w700, color: _ink),
                  decoration: InputDecoration(
                    prefixText: '\$ ',
                    prefixStyle: const TextStyle(fontSize: 24, color: _green, fontWeight: FontWeight.w700),
                    hintText: '0.00', hintStyle: const TextStyle(color: Color(0xFFB4BDB6)),
                    suffixText: 'USD', suffixStyle: const TextStyle(color: Color(0xFF89928B), fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 23),
                _sectionLabel('¿CUÁNTAS PERSONAS?'),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE5E9E2))),
                  child: Row(children: [
                    Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFFF0F4EF), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.groups_2_outlined, color: _green)),
                    const SizedBox(width: 13),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('$_people ${_people == 1 ? 'persona' : 'personas'}', style: const TextStyle(color: _ink, fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(height: 2),
                      const Text('Reparto en partes iguales', style: TextStyle(color: Color(0xFF8A938D), fontSize: 12)),
                    ]),
                    const Spacer(),
                    _roundButton(Icons.remove_rounded, 'Quitar persona', () { if (_people > 1) setState(() => _people--); }, enabled: _people > 1),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('$_people', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: _ink))),
                    _roundButton(Icons.add_rounded, 'Añadir persona', () { if (_people < 99) setState(() => _people++); }, enabled: _people < 99),
                  ]),
                ),
                const SizedBox(height: 23),
                Row(children: [_sectionLabel('PROPINA'), const Spacer(), Text('$_tipPercent%', style: const TextStyle(color: _green, fontWeight: FontWeight.w800, fontSize: 15))]),
                const SizedBox(height: 11),
                Row(children: [0, 10, 12, 15, 20].map((value) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: value == 20 ? 0 : 9),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(13),
                      onTap: () => setState(() => _tipPercent = value),
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: _tipPercent == value ? _green : Colors.white, borderRadius: BorderRadius.circular(13), border: Border.all(color: _tipPercent == value ? _green : const Color(0xFFE5E9E2))),
                        child: Text('$value%', style: TextStyle(color: _tipPercent == value ? Colors.white : const Color(0xFF657169), fontWeight: FontWeight.w700, fontSize: 13)),
                      ),
                    ),
                  ),
                )).toList()),
                const SizedBox(height: 25),
                Container(
                  padding: const EdgeInsets.all(21),
                  decoration: BoxDecoration(color: _ink, borderRadius: BorderRadius.circular(24)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      const Expanded(child: Text('CADA PERSONA PAGA', style: TextStyle(color: Color(0xFFB7C8BD), fontWeight: FontWeight.w700, letterSpacing: 1.1, fontSize: 11))),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: const Color(0xFF294B3C), borderRadius: BorderRadius.circular(20)), child: Text('$_people ${_people == 1 ? 'persona' : 'personas'}', style: const TextStyle(color: Color(0xFFD4E9DA), fontSize: 11, fontWeight: FontWeight.w600))),
                    ]),
                    const SizedBox(height: 8),
                    FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text(_money(_perPerson), style: const TextStyle(color: Colors.white, fontSize: 52, height: 1.08, fontWeight: FontWeight.w800, letterSpacing: -1.5))),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(color: Color(0xFF33473D), height: 1)),
                    _summaryRow('Consumo', _money(_subtotal)),
                    const SizedBox(height: 11),
                    _summaryRow('Propina ($_tipPercent%)', _money(_tip)),
                    const SizedBox(height: 11),
                    _summaryRow('Total con propina', _money(_total), strong: true),
                  ]),
                ),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
                  Icon(Icons.check_circle_outline_rounded, size: 16, color: _green),
                  SizedBox(width: 7),
                  Text('La cuenta queda dividida exactamente', style: TextStyle(color: Color(0xFF77817A), fontSize: 12)),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(text, style: const TextStyle(color: Color(0xFF6D7971), fontWeight: FontWeight.w800, letterSpacing: 1.15, fontSize: 11));

  Widget _summaryRow(String label, String value, {bool strong = false}) => Row(children: [
    Expanded(child: Text(label, style: TextStyle(color: strong ? Colors.white : const Color(0xFFB7C8BD), fontSize: 13, fontWeight: strong ? FontWeight.w700 : FontWeight.w400))),
    Text(value, style: TextStyle(color: strong ? Colors.white : const Color(0xFFD4E0D8), fontSize: 14, fontWeight: strong ? FontWeight.w700 : FontWeight.w500)),
  ]);

  Widget _roundButton(IconData icon, String label, VoidCallback onPressed, {required bool enabled}) => Semantics(
    button: true,
    label: label,
    child: InkWell(
      onTap: enabled ? onPressed : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(width: 36, height: 36, decoration: BoxDecoration(color: enabled ? const Color(0xFFE8F0E9) : const Color(0xFFF3F5F2), borderRadius: BorderRadius.circular(12)), child: Icon(icon, size: 19, color: enabled ? _green : const Color(0xFFC2C9C3))),
    ),
  );
}
