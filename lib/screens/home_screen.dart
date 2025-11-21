import 'package:flutter/material.dart';
import '../widgets/ship_card.dart';
import '../widgets/voyage_card.dart';
import '../theme/theme_controller.dart';
import '../models/voyage.dart';
import 'add_voyage_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Voyage> _voyages = [];
  // simple in-memory notifications for demo
  List<String> _notifications = [];

  void _showNotifications() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Notifications'),
          content: SizedBox(
            width: double.maxFinite,
            child: _notifications.isEmpty
                ? const Text('No notifications')
                : ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, i) => ListTile(title: Text(_notifications[i])),
                    separatorBuilder: (context, i) => const Divider(height: 1),
                    itemCount: _notifications.length),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('CLOSE')),
            if (_notifications.isNotEmpty)
              TextButton(
                onPressed: () {
                  setState(() => _notifications.clear());
                  Navigator.of(context).pop();
                },
                child: const Text('CLEAR ALL'),
              )
          ],
        );
      },
    );
  }

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
          Builder(builder: (context) {
            Widget badgeIcon = Stack(children: [
              Icon(Icons.notifications, color: colors.onPrimary),
              if (_notifications.isNotEmpty)
                Positioned(
                    right: 0,
                    top: 0,
                    child: Container(padding: const EdgeInsets.all(2), decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle), constraints: const BoxConstraints(minWidth: 16, minHeight: 16), child: Center(child: Text('${_notifications.length}', style: const TextStyle(color: Colors.white, fontSize: 10)))))
            ]);

            // always show icon-only button (with badge when present)
            return IconButton(onPressed: _showNotifications, icon: badgeIcon);
          }),
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

      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ShipCard(),
              const SizedBox(height: 16),
              if (_voyages.isEmpty)
                VoyageCard(onCreate: (v) => setState(() => _voyages.insert(0, v)))
              else
                VoyageCard(
                  voyage: _voyages.first,
                  onCreate: (v) => setState(() => _voyages.insert(0, v)),
                  onUpdate: (v) => setState(() => _voyages[0] = v),
                ),
            ],
          ),
        ),

        // Floating Add button anchored bottom-right, aligned with card right padding
        Positioned(
          right: 39,
          bottom: 28,
          child: SizedBox(
            width: 45,
            height: 45,
            child: Material(
              color: Theme.of(context).colorScheme.secondary,
              shape: const CircleBorder(),
              elevation: 8,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () async {
                  final result = await Navigator.of(context).push<Voyage?>(MaterialPageRoute(builder: (_) => const AddVoyageScreen()));
                  if (result != null) setState(() => _voyages.insert(0, result));
                },
                child: Padding(padding: const EdgeInsets.all(8), child: Icon(Icons.add, color: Theme.of(context).colorScheme.onSecondary, size: 28)),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
