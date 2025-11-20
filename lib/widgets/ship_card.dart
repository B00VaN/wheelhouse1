import 'package:flutter/material.dart';

class ShipCard extends StatelessWidget {
  const ShipCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final mq = MediaQuery.of(context);
    final iconBoxSize = (mq.size.width * 0.12).clamp(40.0, 56.0);
    final iconSize = iconBoxSize * 0.46;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: iconBoxSize,
            height: iconBoxSize,
            decoration: BoxDecoration(
              color: colors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Center(
              child: Icon(
                Icons.directions_boat,
                color: colors.onSurface,
                size: iconSize,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Blue Star', style: textTheme.titleMedium?.copyWith(color: colors.onSurface, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('IMO: 9231232', style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.remove_red_eye, color: colors.onSurfaceVariant),
          )
        ],
      ),
    );
  }
}
