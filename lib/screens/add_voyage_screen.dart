import 'package:flutter/material.dart';
import '../widgets/ship_card.dart';

class AddVoyageScreen extends StatelessWidget {
  const AddVoyageScreen({super.key});

  Widget _field(BuildContext context, String label, [String value = '']) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
          const SizedBox(height: 8),
          Text(value, style: textTheme.bodyMedium?.copyWith(color: colors.onSurface)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        // Use surface background for this page's AppBar so the title can
        // use onBackground (black in light theme, white in dark theme).
        backgroundColor: colors.surface,
        iconTheme: IconThemeData(color: colors.onBackground),
        title: Text(
          'ADD NEW VOYAGE',
          style: text.titleLarge?.copyWith(color: colors.onBackground, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ShipCard(),
            const SizedBox(height: 16),
            Text('VOYAGE DETAILS', style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: colors.onBackground)),
            const SizedBox(height: 8),

            _field(context, 'Voyage Title', 'VYG-L01/23'),
            _field(context, 'Departure Port'),

            Row(
              children: [
                Expanded(child: _field(context, 'ETD (LOCAL)')),
                const SizedBox(width: 8),
                Expanded(child: _field(context, 'Time Zone')),
              ],
            ),

            _field(context, 'Arrival Port'),

            Row(
              children: [
                Expanded(child: _field(context, 'ETA (LOCAL)')),
                const SizedBox(width: 8),
                Expanded(child: _field(context, 'Time Zone')),
              ],
            ),

            Row(
              children: [
                Expanded(child: _field(context, 'ETB (LOCAL)')),
                const SizedBox(width: 8),
                Expanded(child: _field(context, 'ETD (LOCAL)')),
              ],
            ),

            _field(context, 'Purpose'),
            _field(context, 'Loading Condition'),
            _field(context, 'Charterer'),

            const SizedBox(height: 12),
            Text('Estimated Departure Draught:', style: text.bodyMedium?.copyWith(color: colors.onBackground)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _field(context, 'AFT (m)')),
                const SizedBox(width: 8),
                Expanded(child: _field(context, 'FWD (m)')),
              ],
            ),

            const SizedBox(height: 24),
            Text('Optimization Settings:', style: text.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: colors.onBackground)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Radio(value: true, groupValue: true, onChanged: (_) {}),
                title: const Text('Fixed ETA'),
              )),
              Expanded(child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Radio(value: false, groupValue: true, onChanged: (_) {}),
                title: const Text('Save Fuel'),
              )),
            ]),

            const SizedBox(height: 120),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.check),
        label: const Text('SAVE'),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
