import 'package:flutter/material.dart';
import '../screens/add_voyage_screen.dart';

class VoyageCard extends StatelessWidget {
  const VoyageCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('ACTIVE VOYAGE', style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: colors.onSurfaceVariant)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('NO VOYAGE RECORD FOUND', style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
                    const SizedBox(height: 6),
                    Text('Create New Voyage', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: colors.onSurface)),
                  ],
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddVoyageScreen()));
                },
                backgroundColor: colors.secondary,
                mini: true,
                child: Icon(Icons.add, color: colors.onSecondary),
              )
            ],
          )
        ],
      ),
    );
  }
}
