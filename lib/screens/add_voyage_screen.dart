import 'package:flutter/material.dart';
import '../widgets/ship_card.dart';
import '../models/voyage.dart';

class AddVoyageScreen extends StatefulWidget {
  const AddVoyageScreen({super.key});

  @override
  State<AddVoyageScreen> createState() => _AddVoyageScreenState();
}

class _AddVoyageScreenState extends State<AddVoyageScreen> {
  bool _fixedEtaSelected = true;
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    final keys = [
      'voyageTitle',
      'departurePort',
      'etdLocal',
      'etdTZ',
      'arrivalPort',
      'etaLocal',
      'etaTZ',
      'etbLocal',
      'etdLocal2',
      'purpose',
      'loadingCondition',
      'charterer',
      'aft',
      'fwd',
      // Upper limit fields
      'upper_speed',
      'upper_hfo',
      'upper_rpm',
      'upper_load',
    ];
    for (var k in keys) {
      _controllers[k] = TextEditingController();
    }
    // set a sample initial value for voyage title
    _controllers['voyageTitle']?.text = 'VYG-L01/23';
  }

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Widget _textField(BuildContext context, String key, String label, {String? hintText}) {
    bool isDate = false;
    if (label.toLowerCase().contains('etd') || label.toLowerCase().contains('eta') || label.toLowerCase().contains('etb')) {
      isDate = true;
    }
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final width = MediaQuery.of(context).size.width;
    final fontSize = width < 360 ? 12.0 : 14.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: _controllers[key],
        readOnly: isDate,
        onTap: isDate
            ? () async {
                await _pickDate(context, key);
              }
            : null,
        style: textTheme.bodyMedium?.copyWith(color: colors.onSurface, fontSize: fontSize),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant, fontSize: fontSize - 2),
          hintText: hintText,
          filled: true,
          fillColor: colors.surface,
          suffixIcon: isDate ? Icon(Icons.calendar_today, color: colors.onSurfaceVariant, size: fontSize + 4) : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: colors.surfaceContainerHighest),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: colors.surfaceContainerHighest),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context, String key) async {
    final colors = Theme.of(context).colorScheme;
    DateTime initial = DateTime.now();
    final text = _controllers[key]?.text;
    if (text != null && text.isNotEmpty) {
      try {
        // try dd/MM/yyyy first
        if (text.contains('/')) {
          final parts = text.split('/');
          if (parts.length == 3) {
            final d = int.parse(parts[0]);
            final m = int.parse(parts[1]);
            final y = int.parse(parts[2]);
            initial = DateTime(y, m, d);
          }
        } else if (text.contains('-')) {
          // try yyyy-MM-dd
          final parts = text.split('-');
          if (parts.length == 3) {
            final y = int.parse(parts[0]);
            final m = int.parse(parts[1]);
            final d = int.parse(parts[2]);
            initial = DateTime(y, m, d);
          }
        }
      } catch (_) {
        // ignore parse errors and fallback to today
      }
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(colorScheme: colors),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked != null) {
      final formatted = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      _controllers[key]?.text = formatted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    final titleSize = width < 360 ? 16.0 : 20.0;
    final sectionTitleSize = width < 360 ? 14.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        // Use surface background for this page's AppBar so the title can
        // use onBackground (black in light theme, white in dark theme).
        backgroundColor: colors.surface,
        iconTheme: IconThemeData(color: colors.onSurface),
        title: Text(
          'ADD NEW VOYAGE',
          style: text.titleLarge?.copyWith(color: colors.onSurface, fontWeight: FontWeight.w600, fontSize: titleSize),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ShipCard(),
            const SizedBox(height: 16),
            Text('VOYAGE DETAILS', style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: colors.onSurface, fontSize: sectionTitleSize)),
            const SizedBox(height: 8),

            _textField(context, 'voyageTitle', 'Voyage Title', hintText: 'Enter Voyage Title'),
            _textField(context, 'departurePort', 'Departure Port', hintText: 'Enter Departure Port'),

            Row(
              children: [
                Expanded(child: _textField(context, 'etdLocal', 'ETD (LOCAL)')),
                const SizedBox(width: 8),
                Expanded(child: _textField(context, 'etdTZ', 'Time Zone')),
              ],
            ),

            _textField(context, 'arrivalPort', 'Arrival Port', hintText: 'Enter Arrival Port'),

            Row(
              children: [
                Expanded(child: _textField(context, 'etaLocal', 'ETA (LOCAL)')),
                const SizedBox(width: 8),
                Expanded(child: _textField(context, 'etaTZ', 'Time Zone')),
              ],
            ),

            Row(
              children: [
                Expanded(child: _textField(context, 'etbLocal', 'ETB (LOCAL)')),
                const SizedBox(width: 8),
                Expanded(child: _textField(context, 'etdLocal2', 'ETD (LOCAL)')),
              ],
            ),

            _textField(context, 'purpose', 'Purpose'),
            _textField(context, 'loadingCondition', 'Loading Condition'),
            _textField(context, 'charterer', 'Charterer'),

            const SizedBox(height: 12),
            Text('Estimated Departure Draught:', style: text.bodyMedium?.copyWith(color: colors.onSurface)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _textField(context, 'aft', 'AFT (m)')),
                const SizedBox(width: 8),
                Expanded(child: _textField(context, 'fwd', 'FWD (m)')),
              ],
            ),

            const SizedBox(height: 24),
            Text('Optimization Settings:', style: text.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: colors.onSurface)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Radio<bool>(
                  value: true,
                  groupValue: _fixedEtaSelected,
                  onChanged: (v) {
                    setState(() {
                      _fixedEtaSelected = true;
                    });
                  },
                  fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
                    if (states.contains(WidgetState.selected)) return colors.secondary;
                    return colors.onSurface;
                  }),
                ),
                title: Text('Fixed ETA', style: TextStyle(color: colors.onSurface)),
              )),
              Expanded(child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Radio<bool>(
                  value: false,
                  groupValue: _fixedEtaSelected,
                  onChanged: (v) {
                    setState(() {
                      _fixedEtaSelected = false;
                    });
                  },
                  fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
                    if (states.contains(WidgetState.selected)) return colors.secondary;
                    return colors.onSurface;
                  }),
                ),
                title: Text('Save Fuel', style: TextStyle(color: colors.onSurface)),
              )),
            ]),

            const SizedBox(height: 12),
            Text('Upper Limit Settings:', style: text.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: colors.onSurface)),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(child: _textField(context, 'upper_speed', 'Speed (knots)')),
                const SizedBox(width: 8),
                Expanded(child: _textField(context, 'upper_hfo', 'HFO MT / Day')),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _textField(context, 'upper_rpm', 'RPM')),
                const SizedBox(width: 8),
                Expanded(child: _textField(context, 'upper_load', 'Load %')),
              ],
            ),

            SizedBox(height: width < 360 ? 80 : 120),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Build Voyage from controllers
          final id = DateTime.now().millisecondsSinceEpoch.toString();
          final v = Voyage(
            id: id,
            title: _controllers['voyageTitle']?.text ?? '',
            departurePort: _controllers['departurePort']?.text ?? '',
            arrivalPort: _controllers['arrivalPort']?.text ?? '',
            etdLocal: _controllers['etdLocal']?.text ?? '',
            etaLocal: _controllers['etaLocal']?.text ?? '',
            etbLocal: _controllers['etbLocal']?.text ?? '',
            fixedEta: _fixedEtaSelected,
            upperLimits: {
              'speed': _controllers['upper_speed']?.text ?? '',
              'hfo': _controllers['upper_hfo']?.text ?? '',
              'rpm': _controllers['upper_rpm']?.text ?? '',
              'load': _controllers['upper_load']?.text ?? '',
            },
          );

          // Return the created Voyage to the caller (in-memory UI flow).
          Navigator.of(context).pop(v);
        },
        backgroundColor: const Color(0xFF5AA0FF),
        elevation: 6,
        icon: const Icon(Icons.check, color: Colors.white),
        label: const Text('SAVE', style: TextStyle(color: Colors.white)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
    );
  }
}
