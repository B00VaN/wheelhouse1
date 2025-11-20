import 'package:flutter/material.dart';
import '../widgets/ship_card.dart';
import '../widgets/voyage_card.dart';
import '../theme/theme_controller.dart';
import '../models/voyage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Voyage> _voyages = [];

  // No persistence: keep voyages in-memory. New voyages are added via the
  // `onCreate` callback passed to `VoyageCard`.

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text(
          'WHEELHOUSE',
          style: textTheme.titleMedium?.copyWith(color: colors.onPrimary, fontWeight: FontWeight.w600),
        ),
        // Ensure the hamburger and other app bar icons use the onPrimary color
        iconTheme: IconThemeData(color: colors.onPrimary),
        actionsIconTheme: IconThemeData(color: colors.onPrimary),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications, color: colors.onPrimary)),
          // Theme toggle: switch between dark and light modes
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (context, mode, _) {
              return IconButton(
                onPressed: toggleTheme,
                icon: Icon(mode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode, color: colors.onPrimary),
              );
            },
          ),
        ],
        backgroundColor: colors.primary,
        elevation: 0,
      ),
      // Left navigation drawer (slides out when hamburger pressed)
      drawer: Drawer(
        child: Column(
          children: [
            // Header: use a light accent background in dark mode so it
            // contrasts with the dark drawer body (matches the screenshot).
            Builder(builder: (context) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              // Use a light grey for the header area in dark mode so the
              // name/email panel stands out against the dark drawer body.
              final headerColor = isDark ? const Color(0xFFE0E0E0) : colors.primaryContainer;
              final headerTextColor = isDark ? Colors.black87 : colors.onPrimary;

              return UserAccountsDrawerHeader(
                accountName: Text('Montse Hall', style: TextStyle(color: headerTextColor, fontWeight: FontWeight.w600)),
                accountEmail: Text('montse.hall@mymail.com', style: TextStyle(color: headerTextColor.withOpacity(0.9))),
                currentAccountPicture: CircleAvatar(
                  // Use a simple icon fallback to avoid missing asset crashes.
                  backgroundColor: headerColor.withOpacity(0.9),
                  child: Icon(Icons.person, color: headerTextColor),
                ),
                decoration: BoxDecoration(
                  color: headerColor,
                ),
              );
            }),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: Icon(Icons.directions_boat, color: colors.onSurface),
                    title: const Text('Your Vessel'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.trip_origin, color: colors.onSurface),
                    title: const Text('Voyages'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.warning_amber_rounded, color: colors.onSurface),
                    title: const Text('SOF'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.local_gas_station, color: colors.onSurface),
                    title: const Text('Bunkers'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.bar_chart, color: colors.onSurface),
                    title: const Text('Performance'),
                    onTap: () {},
                  ),
                ],
              ),
            )
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ShipCard(),
            const SizedBox(height: 16),
            if (_voyages.isEmpty)
              VoyageCard(onCreate: (v) => setState(() => _voyages.insert(0, v)))
            else
              VoyageCard(voyage: _voyages.first, onCreate: (v) => setState(() => _voyages.insert(0, v))),
          ],
        ),
      ),
    );
  }
}
