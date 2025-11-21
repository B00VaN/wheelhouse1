import 'package:flutter/material.dart';
import '../models/voyage.dart';

// Dark-mode color constants used across this file so helpers can access them.
const Color _darkBg = Color(0xFF121216);
const Color _darkAppBar = Color(0xFF1E1E20);
const Color _darkTab = Color(0xFF232328);
const Color _darkMetrics = Color(0xFF1B1B1E);
const Color _darkInfo = Color(0xFF2B2730);

class AdditionalDetailsScreen extends StatelessWidget {
  final Voyage? voyage;

  const AdditionalDetailsScreen({super.key, this.voyage});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lightFill = const Color(0xFFF2F2F2);

    return Scaffold(
      // Use consistent ColorScheme values; prefer `background` for page background
      backgroundColor: isDark ? _darkBg : colors.background,
      appBar: AppBar(
        // keep AppBar neutral and readable in light theme
        backgroundColor: isDark ? _darkAppBar : colors.surface,
        iconTheme: IconThemeData(color: colors.onSurface),
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
        title: Text(voyage?.title ?? 'VYG-L01/23', style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.check)),
          IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          // Map placeholder
          Stack(children: [
            SizedBox(height: 180, child: Image.network('https://upload.wikimedia.org/wikipedia/commons/8/80/World_map_-_low_resolution.svg', fit: BoxFit.cover, width: double.infinity)),
              Positioned(right: 12, top: 12, child: Column(children: [
                _smallCircleIcon(context, Icons.my_location),
                const SizedBox(height: 8),
                _smallCircleIcon(context, Icons.layers),
              ]))
          ]),

          // Tab-like nav row
          Container(
            color: isDark ? _darkTab : lightFill,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _tabItem(context, Icons.anchor, 'DETAILS', active: true),
              _tabItem(context, Icons.route, 'ROUTE'),
              _tabItem(context, Icons.stacked_line_chart, 'ESTIMATES'),
              _tabItem(context, Icons.bar_chart, 'CHARTS'),
              _tabItem(context, Icons.event, 'EVENTS'),
            ]),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              // Update + Edit
              Row(children: [
                Expanded(child: Row(children: [Icon(Icons.refresh, color: const Color(0xFF00C8A0)), const SizedBox(width: 8), Text('Updated 10 minutes ago', style: text.bodySmall)])),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  label: const Text('EDIT'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9B59B6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0),
                )
              ]),
              const SizedBox(height: 12),

              // Segmented progress bar: left = progress (green), arrow, right = remaining (grey)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: LayoutBuilder(builder: (context, constraints) {
                  final isDarkBar = Theme.of(context).brightness == Brightness.dark;
                  // Example progress fraction (can be made dynamic later)
                  final progress = 0.55; // 55% completed
                  final leftFlex = (progress * 100).round();
                  final rightFlex = ((1 - progress) * 100).round();
                  return Row(children: [
                    Expanded(
                        flex: leftFlex,
                        child: Container(height: 6, decoration: BoxDecoration(color: const Color(0xFF00C8A0), borderRadius: BorderRadius.circular(3)))),
                    SizedBox(width: 12, child: Center(child: Icon(Icons.arrow_forward, size: 16, color: const Color(0xFF00C8A0)))),
                    Expanded(
                        flex: rightFlex,
                        child: Container(height: 6, decoration: BoxDecoration(color: isDarkBar ? const Color(0xFF2B2730) : Colors.grey.shade300, borderRadius: BorderRadius.circular(3)))),
                  ]);
                }),
              ),

              // Distances and metrics (dark card style)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: isDark ? _darkInfo : lightFill, borderRadius: BorderRadius.circular(8), border: Border.all(color: colors.outline.withOpacity(0.12))),
                child: Column(children: [
                  Row(children: [
                    Expanded(child: _labelValue(context, 'TOTAL DISTANCE', '1,000 NM')),
                    Expanded(child: _labelValue(context, 'DISTANCE TO GO', '1,000 NM', alignRight: true)),
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    _metricSmall(context, 'DRAFT', '20.6 m'),
                    const SizedBox(width: 8),
                    _metricSmall(context, 'SPEED OG', voyage?.upperLimits['speed'] ?? '15.4 kn'),
                    const SizedBox(width: 8),
                    _metricSmall(context, 'COURSE OG', voyage?.upperLimits['course'] ?? '0.0°'),
                    const SizedBox(width: 8),
                    _metricSmall(context, 'HEADING', voyage?.upperLimits['heading'] ?? '0.0°'),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    _metricSmall(context, 'WIND SPEED', voyage?.upperLimits['wind'] ?? '3.6 kn'),
                    const SizedBox(width: 8),
                    _metricSmall(context, 'WAVES', voyage?.upperLimits['waves'] ?? '6.0 m'),
                    const SizedBox(width: 8),
                    _metricSmall(context, 'CURRENT', voyage?.upperLimits['current'] ?? '0.0 kn'),
                    const SizedBox(width: 8),
                    _metricSmall(context, 'SWELL', voyage?.upperLimits['swell'] ?? '0.0°'),
                  ])
                ]),
              ),

              const SizedBox(height: 18),
              Text('ADDITIONAL DETAILS', style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),

              // Detail cards / fields
                Wrap(spacing: 12, runSpacing: 12, children: [
                _infoBox(context, 'ETB (UTC)', voyage?.etbLocal ?? '2021-08-06 10:00', lightFill: lightFill),
                _infoBox(context, 'ETD (UTC)', voyage?.etdLocal ?? '2021-08-07 12:00', lightFill: lightFill),
                _infoBox(context, 'Purpose', voyage?.upperLimits['purpose'] ?? 'Loading', wide: true, lightFill: lightFill),
                _infoBox(context, 'Loading Condition', voyage?.upperLimits['loadingCondition'] ?? 'Ladden', wide: true, lightFill: lightFill),
                _infoBox(context, 'Charterer', voyage?.upperLimits['charterer'] ?? 'Charterer Company Name', wide: true, lightFill: lightFill),
                _infoBox(context, 'Departure Draft AFT', voyage?.upperLimits['aft'] ?? '20.6', lightFill: lightFill),
                _infoBox(context, 'Departure Draft FWD', voyage?.upperLimits['fwd'] ?? '20.6', lightFill: lightFill),
                _infoBox(context, 'Optimization Settings', voyage?.fixedEta == true ? 'Fixed ETA' : 'Save Fuel', wide: true, lightFill: lightFill),
              ]),

              const SizedBox(height: 18),
              Text('Upper Limit Settings', style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Wrap(spacing: 12, runSpacing: 12, children: [
                _infoBox(context, 'Speed (knots)', voyage?.upperLimits['speed'] ?? '17.00', lightFill: lightFill),
                _infoBox(context, 'HFO MT / Day', voyage?.upperLimits['hfo'] ?? '85.00', lightFill: lightFill),
                _infoBox(context, 'RPM', voyage?.upperLimits['rpm'] ?? '260', lightFill: lightFill),
                _infoBox(context, 'Load %', voyage?.upperLimits['load'] ?? '80', lightFill: lightFill),
              ])
            ]),
          )
        ]),
      ),
    );
  }

  Widget _smallCircleIcon(BuildContext context, IconData icon) {
    final colors = Theme.of(context).colorScheme;
    final localIsDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: localIsDark ? _darkTab : colors.surface,
      shape: const CircleBorder(),
      elevation: 3,
      child: Padding(padding: const EdgeInsets.all(8), child: Icon(icon, size: 18, color: colors.onSurface)),
    );
  }

  Widget _tabItem(BuildContext context, IconData icon, String label, {bool active = false}) {
    final colors = Theme.of(context).colorScheme;
    final accent = const Color(0xFF9B59B6);
    return Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: active ? accent : colors.onSurfaceVariant), const SizedBox(height: 6), Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: active ? accent : colors.onSurfaceVariant))]);
  }

  Widget _labelValue(BuildContext context, String label, String value, {bool alignRight = false}) {
    final t = Theme.of(context).textTheme;
    return Column(crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [Text(label, style: t.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)), const SizedBox(height: 6), Text(value, style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700))]);
  }

  Widget _metricSmall(BuildContext context, String label, String value) {
    final t = Theme.of(context).textTheme;
    return Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: t.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)), const SizedBox(height: 6), Text(value, style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w700))]),
    );
  }

  Widget _infoBox(BuildContext context, String label, String value, {bool wide = false, Color? lightFill}) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final boxWidth = wide ? (width - 64) : (width - 64) / 2;
    final bg = isDark ? _darkInfo : (lightFill ?? colors.surfaceVariant);
    return Container(
      width: wide ? double.infinity : (boxWidth),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8), border: Border.all(color: colors.outline.withOpacity(0.08))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant)), const SizedBox(height: 8), Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700))]),
    );
  }
}

