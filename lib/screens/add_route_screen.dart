import 'package:flutter/material.dart';
import '../models/voyage.dart';

class AddRouteScreen extends StatefulWidget {
  final Voyage? voyage;
  const AddRouteScreen({super.key, this.voyage});

  @override
  State<AddRouteScreen> createState() => _AddRouteScreenState();
}

class _AddRouteScreenState extends State<AddRouteScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _allowed = ['Bahamas Canal', 'Magellan Strait', 'Kiel Canal', 'Oresund strait', 'Panama Canal', 'Corinth Canal', 'Suez Canal', 'Bonifacio Strait'];
  final List<String> _noGo = ['Somalia Zone 1 (65th meridian)', 'Somalia Zone 2 (60th meridian)', 'Somalia Zone 3 (400-500n.m off Somalian coast)', 'Somalia Zone 4 (250-300n.m off Somalian coast)', 'NO Somalia Avoidance (De-activates Somalia avoidance)'];
  final Set<String> _selectedAllowed = {};
  String? _selectedNoGo;
  int _navMethod = 0; // 0=Great Circle,1=Rhumb
  int _gcInterval = 5;
  double _seca = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _chip(String text) {
    final theme = Theme.of(context);
    return InputChip(
      label: Text(text),
      selected: _selectedAllowed.contains(text),
      onSelected: (v) => setState(() => v ? _selectedAllowed.add(text) : _selectedAllowed.remove(text)),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: () => setState(() => _selectedAllowed.remove(text)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADD NEW ROUTE'),
        leading: BackButton(color: colors.onSurface),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Column(children: [
        // FROM/TO row
        Container(
          color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E20) : colors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('FROM', style: text.labelSmall), const SizedBox(height: 6), Text(widget.voyage?.departurePort ?? 'Ellefsen Harbor (AQ)', style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700))])),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text('TO', style: text.labelSmall), const SizedBox(height: 6), Text(widget.voyage?.arrivalPort ?? 'Ellefsen Harbor (AQ)', style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700))])),
          ]),
        ),

        // Tabs
        Material(
          color: Theme.of(context).colorScheme.surface,
          child: TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFF9B59B6),
            labelColor: const Color(0xFF9B59B6),
            unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
            tabs: const [Tab(text: 'AUTO'), Tab(text: 'IMPORT'), Tab(text: 'ARCHIVE')],
          ),
        ),

        Expanded(
          child: TabBarView(controller: _tabController, children: [
            // AUTO tab
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Allowed Areas', style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: _allowed.map((s) => _chip(s)).toList()),
                const SizedBox(height: 16),
                Text('No Go Areas', style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    items: _noGo.map((n) => DropdownMenuItem(value: n, child: Text(n, overflow: TextOverflow.visible))).toList(),
                    value: _selectedNoGo,
                    onChanged: (v) => setState(() => _selectedNoGo = v),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Navigational Method', style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(
                      child: RadioListTile<int>(
                    value: 0,
                    groupValue: _navMethod,
                    onChanged: (v) => setState(() => _navMethod = v ?? 0),
                    title: const Text('Great Circle'),
                    activeColor: const Color(0xFF9B59B6),
                  )),
                  Expanded(
                      child: RadioListTile<int>(
                    value: 1,
                    groupValue: _navMethod,
                    onChanged: (v) => setState(() => _navMethod = v ?? 0),
                    title: const Text('Rhumb Line'),
                    activeColor: const Color(0xFF9B59B6),
                  )),
                ]),
                const SizedBox(height: 8),
                LayoutBuilder(builder: (context, constraints) {
                  final narrow = constraints.maxWidth < 420;
                  Widget _squareButton(IconData icon, VoidCallback onTap) {
                    return Material(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(6),
                      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(6), child: SizedBox(width: 36, height: 36, child: Icon(icon, size: 18, color: Colors.black87))),
                    );
                  }

                  final controlRow = SizedBox(
                    height: 36,
                    child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
                      _squareButton(Icons.add, () => setState(() => _gcInterval++)),
                      const SizedBox(width: 8),
                      Container(
                        width: 40,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: const Color(0xFF9B59B6), borderRadius: BorderRadius.circular(6)),
                        child: Text('$_gcInterval', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 8),
                      _squareButton(Icons.remove, () => setState(() => _gcInterval = (_gcInterval > 1 ? _gcInterval - 1 : 1))),
                    ]),
                  );

                  if (narrow) {
                    // show label above control on narrow screens but align control to right
                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Great Circle Interval (NM)', style: text.bodyMedium), const SizedBox(height: 8), Row(children: [const Spacer(), controlRow])]);
                  }

                  return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [Text('Great Circle Interval (NM)', style: text.bodyMedium), const Spacer(), controlRow]);
                }),
                const SizedBox(height: 16),
                Text('SECA Area Avoidance', style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                Slider(
                  value: _seca,
                  onChanged: (v) => setState(() => _seca = v),
                  min: 0,
                  max: 100,
                  activeColor: const Color(0xFF9B59B6),
                  inactiveColor: Theme.of(context).colorScheme.surfaceVariant,
                ),
                Align(alignment: Alignment.centerRight, child: Text('${_seca.toInt()} %')),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    // For now, just pop with a small route summary
                    Navigator.of(context).pop({'allowed': _selectedAllowed.toList(), 'noGo': _selectedNoGo});
                  },
                  icon: const Icon(Icons.check),
                  label: const Padding(padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8), child: Text('CALCULATE')),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9B59B6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                )
              ]),
            ),

            // IMPORT tab (placeholder)
            Center(child: Text('Import routes from file or service', style: text.bodyLarge)),

            // ARCHIVE tab (placeholder)
            Center(child: Text('Previously generated routes', style: text.bodyLarge)),
          ]),
        )
      ]),
    );
  }
}
