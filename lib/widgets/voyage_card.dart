import 'package:flutter/material.dart';
import '../screens/add_voyage_screen.dart';

class VoyageCard extends StatelessWidget {
  const VoyageCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    final fabPadding = width < 360 ? 8.0 : 12.0;

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
              // Purple circular FAB styled to match screenshot
              Material(
                color: colors.secondary,
                shape: const CircleBorder(),
                elevation: 6,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddVoyageScreen()));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(fabPadding),
                    child: Icon(Icons.add, color: colors.onSecondary, size: width < 360 ? 18 : 20),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
