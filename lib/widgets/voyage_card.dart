import 'package:flutter/material.dart';
import '../models/voyage.dart';
import '../screens/additional_details.dart';
import '../screens/add_voyage_screen.dart';

class VoyageCard extends StatelessWidget {
  final Voyage? voyage;
  final void Function(Voyage)? onCreate;

  const VoyageCard({super.key, this.voyage, this.onCreate});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // Top row: Title + Badge
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Text(voyage?.title ?? 'VYG-L01/23', style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w800))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFF1BC08E), borderRadius: BorderRadius.circular(22)),
            child: Row(children: [Icon(Icons.wifi_tethering, size: 14, color: Colors.white), const SizedBox(width: 8), Text('ACTIVE', style: text.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700))]),
          )
        ]),
        const SizedBox(height: 8),

        // Section label
        Text('ACTIVE VOYAGE', style: text.labelLarge?.copyWith(color: colors.onSurfaceVariant, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),

        // FROM / TO labels & values
        Row(children: [
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('FROM', style: text.labelSmall?.copyWith(color: colors.onSurfaceVariant, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(voyage?.departurePort ?? 'Ellefsen Harbor (AQ)', style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700))
          ])),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('TO', style: text.labelSmall?.copyWith(color: colors.onSurfaceVariant, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(voyage?.arrivalPort ?? 'Ellefsen Harbor (AQ)', textAlign: TextAlign.right, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700))
          ])),
        ]),
        const SizedBox(height: 10),

        // ATD / ETA rows
        Row(children: [
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('ATD (UTC)', style: text.labelSmall?.copyWith(color: colors.onSurfaceVariant, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(voyage?.etdLocal ?? '31/08/2025', style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700))
          ])),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('ETA (UTC)', style: text.labelSmall?.copyWith(color: colors.onSurfaceVariant, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(voyage?.etaLocal ?? '15/01/2026', textAlign: TextAlign.right, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700))
          ])),
        ]),
        const SizedBox(height: 14),

        // Progress bar with boxed arrow
        _DetailedProgressBar(progress: 0.6, backgroundColor: colors.onSurface.withOpacity(0.08), fillColor: const Color(0xFF00C8A0)),
        const SizedBox(height: 12),

        // Distances row
        Row(children: [
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('TOTAL DISTANCE', style: text.labelSmall?.copyWith(color: colors.onSurfaceVariant, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text('1,000 NM', style: text.bodyLarge?.copyWith(fontWeight: FontWeight.w800))
          ])),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('DISTANCE TO GO', style: text.labelSmall?.copyWith(color: colors.onSurfaceVariant, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text('450 NM', textAlign: TextAlign.right, style: text.bodyLarge?.copyWith(fontWeight: FontWeight.w800))
          ])),
        ]),
        const SizedBox(height: 12),

        // Metrics grid (2 rows x 4 columns)
        Column(children: [
          Row(children: [
            _metricCell(context, 'DRAFT', voyage?.upperLimits['draft'] ?? '20.6 m'),
            const SizedBox(width: 8),
            _metricCell(context, 'SPEED OG', voyage?.upperLimits['speed'] ?? '15.4 kn'),
            const SizedBox(width: 8),
            _metricCell(context, 'COURSE OG', voyage?.upperLimits['course'] ?? '0.0°'),
            const SizedBox(width: 8),
            _metricCell(context, 'HEADING', voyage?.upperLimits['heading'] ?? '0.0°'),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            _metricCell(context, 'WIND SPEED', voyage?.upperLimits['wind'] ?? '3.6 kn'),
            const SizedBox(width: 8),
            _metricCell(context, 'WAVES', voyage?.upperLimits['waves'] ?? '6.0 m'),
            const SizedBox(width: 8),
            _metricCell(context, 'CURRENT', voyage?.upperLimits['current'] ?? '0.0 kn'),
            const SizedBox(width: 8),
            _metricCell(context, 'SWELL', voyage?.upperLimits['swell'] ?? '0.0°'),
          ])
        ]),
        const SizedBox(height: 16),

        // Footer: updated + View All button
        Row(children: [
          Expanded(child: Row(children: [Icon(Icons.refresh, color: const Color(0xFF00C8A0), size: 18), const SizedBox(width: 8), Text('Updated 10 minutes ago', style: text.bodySmall)])),
          const SizedBox(width: 12),
          // VIEW ALL circular button
          SizedBox(
            width: 56,
            height: 56,
            child: Material(
              color: const Color(0xFF9B59B6),
              shape: const CircleBorder(),
              elevation: 4,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => AdditionalDetailsScreen(voyage: voyage)));
                },
                child: const Center(child: Icon(Icons.keyboard_arrow_down, color: Colors.black87, size: 28)),
              ),
            ),
          )
        ])
      ]),
    );
  }

  Widget _metricCell(BuildContext context, String label, String value) {
    final colors = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(color: colors.surfaceVariant, borderRadius: BorderRadius.circular(6)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: t.bodySmall?.copyWith(color: colors.onSurfaceVariant, fontSize: 11)),
          const SizedBox(height: 6),
          Text(value, style: t.bodyMedium?.copyWith(color: colors.onSurface, fontWeight: FontWeight.w700))
        ]),
      ),
    );
  }
}

class _DetailedProgressBar extends StatelessWidget {
  final double progress;
  final Color backgroundColor;
  final Color fillColor;

  const _DetailedProgressBar({required this.progress, required this.backgroundColor, required this.fillColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22,
      child: LayoutBuilder(builder: (context, constraints) {
        final w = constraints.maxWidth;
        final fillW = (w * progress).clamp(0.0, w);
        final arrowCenter = fillW.clamp(18.0, w - 18.0);

        return Stack(children: [
          // background track
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(height: 6, decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(6))),
            ),
          ),

          // filled portion
          Positioned(left: 0, top: 0, bottom: 0, width: fillW, child: Align(alignment: Alignment.centerLeft, child: Container(height: 6, decoration: BoxDecoration(color: fillColor, borderRadius: BorderRadius.circular(6))))),

          // arrow box
          Positioned(left: arrowCenter - 18, top: 3, child: Container(width: 36, height: 14, decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(8)), child: Center(child: Icon(Icons.arrow_forward, size: 14, color: fillColor)))),
        ]);
      }),
    );
  }
}
