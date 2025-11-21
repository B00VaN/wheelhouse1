import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/voyage.dart';
import 'add_route_screen.dart';

// Dark-mode color constants used across this file so helpers can access them.
const Color _darkBg = Color(0xFF121216);
const Color _darkAppBar = Color(0xFF1E1E20);
const Color _darkTab = Color(0xFF232328);
const Color _darkInfo = Color(0xFF2B2730);

class AdditionalDetailsScreen extends StatefulWidget {
  final Voyage? voyage;

  const AdditionalDetailsScreen({super.key, this.voyage});

  @override
  State<AdditionalDetailsScreen> createState() => _AdditionalDetailsScreenState();
}

class _AdditionalDetailsScreenState extends State<AdditionalDetailsScreen> {
  final Map<String, TextEditingController> _c = {};
  bool _editing = false;
  final MapController _mapCtrl = MapController();
  late LatLng _markerLatLng;
  int _activeTab = 0;

  @override
  void initState() {
    super.initState();
    // controllers for header fields
    final keys = [
      'departurePort',
      'arrivalPort',
      'etdLocal',
      'etaLocal',
      'etbLocal',
      // info boxes / upper limits
      'purpose',
      'loadingCondition',
      'charterer',
      'aft',
      'fwd',
      'speed',
      'hfo',
      'rpm',
      'load',
      'mapLat',
      'mapLng',
    ];
    for (var k in keys) _c[k] = TextEditingController();
    final v = widget.voyage;
    if (v != null) {
      _c['departurePort']?.text = v.departurePort;
      _c['arrivalPort']?.text = v.arrivalPort;
      _c['etdLocal']?.text = v.etdLocal;
      _c['etaLocal']?.text = v.etaLocal;
      _c['etbLocal']?.text = v.etbLocal;
      _c['purpose']?.text = v.upperLimits['purpose'] ?? '';
      _c['loadingCondition']?.text = v.upperLimits['loadingCondition'] ?? '';
      _c['charterer']?.text = v.upperLimits['charterer'] ?? '';
      _c['aft']?.text = v.upperLimits['aft'] ?? '';
      _c['fwd']?.text = v.upperLimits['fwd'] ?? '';
      _c['speed']?.text = v.upperLimits['speed'] ?? '';
      _c['hfo']?.text = v.upperLimits['hfo'] ?? '';
      _c['rpm']?.text = v.upperLimits['rpm'] ?? '';
      _c['load']?.text = v.upperLimits['load'] ?? '';
      // try to read saved map coords if available
      _c['mapLat']?.text = v.upperLimits['mapLat'] ?? '';
      _c['mapLng']?.text = v.upperLimits['mapLng'] ?? '';
    }
    // initialize marker position from controllers or default
    final lat = double.tryParse(_c['mapLat']?.text ?? '');
    final lng = double.tryParse(_c['mapLng']?.text ?? '');
    if (lat != null && lng != null) {
      _markerLatLng = LatLng(lat, lng);
    } else {
      // default to a sensible location (Equator / Prime meridian)
      _markerLatLng = LatLng(0.0, 0.0);
      _c['mapLat']?.text = _markerLatLng.latitude.toStringAsFixed(6);
      _c['mapLng']?.text = _markerLatLng.longitude.toStringAsFixed(6);
    }
  }

  @override
  void dispose() {
    for (var c in _c.values) c.dispose();
    super.dispose();
  }

  String _val(String key, String fallback) {
    final t = _c[key]?.text;
    if (t != null && t.isNotEmpty) return t;
    return fallback;
  }

  Widget _maybeEditable(String key, String fallback, TextStyle? style, {bool alignRight = false}) {
    if (!_editing) return Text(_val(key, fallback), style: style, textAlign: alignRight ? TextAlign.right : TextAlign.left);
    return TextFormField(
      controller: _c[key],
      style: style,
      textAlign: alignRight ? TextAlign.right : TextAlign.left,
      decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 4)),
    );
  }

  void _saveAndPop() {
    final id = widget.voyage?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    final updated = Voyage(
      id: id,
      title: widget.voyage?.title ?? '',
      departurePort: _c['departurePort']?.text ?? widget.voyage?.departurePort ?? '',
      arrivalPort: _c['arrivalPort']?.text ?? widget.voyage?.arrivalPort ?? '',
      etdLocal: _c['etdLocal']?.text ?? widget.voyage?.etdLocal ?? '',
      etaLocal: _c['etaLocal']?.text ?? widget.voyage?.etaLocal ?? '',
      etbLocal: _c['etbLocal']?.text ?? widget.voyage?.etbLocal ?? '',
      fixedEta: widget.voyage?.fixedEta ?? false,
      upperLimits: {
        'purpose': _c['purpose']?.text ?? widget.voyage?.upperLimits['purpose'] ?? '',
        'loadingCondition': _c['loadingCondition']?.text ?? widget.voyage?.upperLimits['loadingCondition'] ?? '',
        'charterer': _c['charterer']?.text ?? widget.voyage?.upperLimits['charterer'] ?? '',
        'aft': _c['aft']?.text ?? widget.voyage?.upperLimits['aft'] ?? '',
        'fwd': _c['fwd']?.text ?? widget.voyage?.upperLimits['fwd'] ?? '',
        'speed': _c['speed']?.text ?? widget.voyage?.upperLimits['speed'] ?? '',
        'hfo': _c['hfo']?.text ?? widget.voyage?.upperLimits['hfo'] ?? '',
        'rpm': _c['rpm']?.text ?? widget.voyage?.upperLimits['rpm'] ?? '',
        'load': _c['load']?.text ?? widget.voyage?.upperLimits['load'] ?? '',
        'mapLat': _c['mapLat']?.text ?? widget.voyage?.upperLimits['mapLat'] ?? '',
        'mapLng': _c['mapLng']?.text ?? widget.voyage?.upperLimits['mapLng'] ?? '',
      },
    );
    Navigator.of(context).pop(updated);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Slightly darker light-mode fill so panels contrast better against page background
    final lightFill = const Color(0xFFE0E0E0);

    return Scaffold(
      // Use consistent ColorScheme values; prefer `background` for page background
      backgroundColor: isDark ? _darkBg : colors.background,
      appBar: AppBar(
        // keep AppBar neutral and readable in light theme
        backgroundColor: isDark ? _darkAppBar : colors.surface,
        iconTheme: IconThemeData(color: colors.onSurface),
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop(null)),
        title: Text(widget.voyage?.title ?? 'VYG-L01/23', style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            onPressed: _editing ? _saveAndPop : null,
            icon: const Icon(Icons.check),
          ),
          IconButton(onPressed: () => Navigator.of(context).pop(null), icon: const Icon(Icons.close)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          // Details under title: FROM/TO, ATD/ETA and progress bar
          Container(
            color: isDark ? _darkAppBar : colors.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(children: [
              Row(children: [
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('FROM', style: text.labelSmall?.copyWith(color: colors.onSurfaceVariant)),
                  const SizedBox(height: 6),
                  _maybeEditable('departurePort', widget.voyage?.departurePort ?? 'Ellefsen Harbor (AQ)', text.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text('ATD (UTC)', style: text.labelSmall?.copyWith(color: colors.onSurfaceVariant)),
                  const SizedBox(height: 6),
                  _maybeEditable('etdLocal', widget.voyage?.etdLocal ?? '31/08/2025', text.bodySmall),
                ])),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('TO', style: text.labelSmall?.copyWith(color: colors.onSurfaceVariant)),
                  const SizedBox(height: 6),
                  _maybeEditable('arrivalPort', widget.voyage?.arrivalPort ?? 'Ellefsen Harbor (AQ)', text.titleSmall?.copyWith(fontWeight: FontWeight.w700), alignRight: true),
                  const SizedBox(height: 8),
                  Text('ETA (UTC)', style: text.labelSmall?.copyWith(color: colors.onSurfaceVariant)),
                  const SizedBox(height: 6),
                  _maybeEditable('etaLocal', widget.voyage?.etaLocal ?? '15/01/2026', text.bodySmall, alignRight: true),
                ])),
              ]),
              const SizedBox(height: 12),
              // (header progress removed - moved below)
            ]),
          ),

          // Interactive map (tap to move marker, center button)
          Stack(children: [
            SizedBox(
              height: 220,
              child: FlutterMap(
                mapController: _mapCtrl,
                options: MapOptions(
                  center: _markerLatLng,
                  zoom: 3.5,
                  onTap: (tapPos, latlng) {
                    setState(() {
                      _markerLatLng = latlng;
                      _c['mapLat']?.text = latlng.latitude.toStringAsFixed(6);
                      _c['mapLng']?.text = latlng.longitude.toStringAsFixed(6);
                      _mapCtrl.move(latlng, _mapCtrl.zoom);
                    });
                  },
                ),
                nonRotatedChildren: [
                  TileLayer(
                    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                    userAgentPackageName: 'com.example.wheelhouse',
                  ),
                  MarkerLayer(markers: [
                    Marker(
                      width: 48,
                      height: 48,
                      point: _markerLatLng,
                      builder: (ctx) => const Icon(Icons.location_on, color: Color(0xFF9B59B6), size: 36),
                    )
                  ])
                ],
              ),
            ),
            Positioned(right: 12, top: 12, child: Column(children: [
              InkWell(onTap: () {
                // center map on marker
                _mapCtrl.move(_markerLatLng, 6.0);
              }, child: _smallCircleIcon(context, Icons.my_location)),
              const SizedBox(height: 8),
              InkWell(onTap: () {
                // toggle map zoom layers: simple placeholder
                final newZoom = (_mapCtrl.zoom < 6) ? 6.0 : 3.5;
                _mapCtrl.move(_markerLatLng, newZoom);
              }, child: _smallCircleIcon(context, Icons.layers)),
            ]))
          ]),

          // Tab-like nav row (responsive)
          Container(
            color: isDark ? _darkTab : lightFill,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: LayoutBuilder(builder: (context, constraints) {
              final max = constraints.maxWidth;
              final isNarrow = max < 420; // switch to compact/scrolling on narrow screens
              final tabs = [
                [Icons.anchor, 'DETAILS'],
                [Icons.route, 'ROUTE'],
                [Icons.stacked_line_chart, 'ESTIMATES'],
                [Icons.bar_chart, 'CHARTS'],
                [Icons.event, 'EVENTS'],
              ];

              if (isNarrow) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    for (var i = 0; i < tabs.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: SizedBox(
                            width: 84,
                            child: _tabItem(context, tabs[i][0] as IconData, tabs[i][1] as String, active: i == _activeTab, onTap: () {
                              setState(() => _activeTab = i);
                            })),
                      )
                  ]),
                );
              }

              // wide layout: evenly space items and allow them to expand
              return Row(children: [
                for (var i = 0; i < tabs.length; i++)
                  Expanded(
                      child: _tabItem(context, tabs[i][0] as IconData, tabs[i][1] as String, active: i == _activeTab, onTap: () {
                    setState(() => _activeTab = i);
                  })),
              ]);
            }),
          ),

          // main content switches based on active tab
          if (_activeTab == 0)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                // Update + Edit
                Row(children: [
                  Expanded(child: Row(children: [Icon(Icons.refresh, color: const Color(0xFF00C8A0)), const SizedBox(width: 8), Text('Updated 10 minutes ago', style: text.bodySmall)])),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (!_editing) {
                        setState(() => _editing = true);
                      } else {
                        // cancel edits: restore controllers to original voyage values
                        final v = widget.voyage;
                        if (v != null) {
                          _c['departurePort']?.text = v.departurePort;
                          _c['arrivalPort']?.text = v.arrivalPort;
                          _c['etdLocal']?.text = v.etdLocal;
                          _c['etaLocal']?.text = v.etaLocal;
                          _c['etbLocal']?.text = v.etbLocal;
                          _c['purpose']?.text = v.upperLimits['purpose'] ?? '';
                          _c['loadingCondition']?.text = v.upperLimits['loadingCondition'] ?? '';
                          _c['charterer']?.text = v.upperLimits['charterer'] ?? '';
                          _c['aft']?.text = v.upperLimits['aft'] ?? '';
                          _c['fwd']?.text = v.upperLimits['fwd'] ?? '';
                          _c['speed']?.text = v.upperLimits['speed'] ?? '';
                          _c['hfo']?.text = v.upperLimits['hfo'] ?? '';
                          _c['rpm']?.text = v.upperLimits['rpm'] ?? '';
                          _c['load']?.text = v.upperLimits['load'] ?? '';
                        }
                        setState(() => _editing = false);
                      }
                    },
                    icon: const Icon(Icons.edit),
                    label: Text(_editing ? 'CANCEL' : 'EDIT'),
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
                      Expanded(child: _labelValue(context, 'DISTANCE TO GO', '450 NM', alignRight: true)),
                    ]),
                    const SizedBox(height: 12),
                    Row(children: [
                      _metricSmall(context, 'DRAFT', '20.6 m'),
                      const SizedBox(width: 8),
                      _metricSmall(context, 'SPEED OG', _val('speed', widget.voyage?.upperLimits['speed'] ?? '15.4 kn')),
                      const SizedBox(width: 8),
                      _metricSmall(context, 'COURSE OG', widget.voyage?.upperLimits['course'] ?? '0.0°'),
                      const SizedBox(width: 8),
                      _metricSmall(context, 'HEADING', widget.voyage?.upperLimits['heading'] ?? '0.0°'),
                    ]),
                    const SizedBox(height: 8),
                    Row(children: [
                      _metricSmall(context, 'WIND SPEED', widget.voyage?.upperLimits['wind'] ?? '3.6 kn'),
                      const SizedBox(width: 8),
                      _metricSmall(context, 'WAVES', widget.voyage?.upperLimits['waves'] ?? '6.0 m'),
                      const SizedBox(width: 8),
                      _metricSmall(context, 'CURRENT', widget.voyage?.upperLimits['current'] ?? '0.0 kn'),
                      const SizedBox(width: 8),
                      _metricSmall(context, 'SWELL', widget.voyage?.upperLimits['swell'] ?? '0.0°'),
                    ])
                  ]),
                ),

                const SizedBox(height: 18),
                Text('ADDITIONAL DETAILS', style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),

                // Detail cards / fields
                  Wrap(spacing: 12, runSpacing: 12, children: [
                  _infoBox(context, 'ETB (UTC)', _val('etbLocal', widget.voyage?.etbLocal ?? ''), lightFill: lightFill, controllerKey: 'etbLocal'),
                  _infoBox(context, 'ETD (UTC)', _val('etdLocal', widget.voyage?.etdLocal ?? ''), lightFill: lightFill, controllerKey: 'etdLocal'),
                  _infoBox(context, 'Purpose', _val('purpose', widget.voyage?.upperLimits['purpose'] ?? 'Loading'), wide: true, lightFill: lightFill, controllerKey: 'purpose'),
                  _infoBox(context, 'Loading Condition', _val('loadingCondition', widget.voyage?.upperLimits['loadingCondition'] ?? 'Ladden'), wide: true, lightFill: lightFill, controllerKey: 'loadingCondition'),
                  _infoBox(context, 'Charterer', _val('charterer', widget.voyage?.upperLimits['charterer'] ?? 'Charterer Company Name'), wide: true, lightFill: lightFill, controllerKey: 'charterer'),
                  _infoBox(context, 'Departure Draft AFT', _val('aft', widget.voyage?.upperLimits['aft'] ?? '20.6'), lightFill: lightFill, controllerKey: 'aft'),
                  _infoBox(context, 'Departure Draft FWD', _val('fwd', widget.voyage?.upperLimits['fwd'] ?? '20.6'), lightFill: lightFill, controllerKey: 'fwd'),
                  _infoBox(context, 'Optimization Settings', (widget.voyage?.fixedEta == true) ? 'Fixed ETA' : 'Save Fuel', wide: true, lightFill: lightFill),
                ]),

                const SizedBox(height: 18),
                Text('Upper Limit Settings', style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Wrap(spacing: 12, runSpacing: 12, children: [
                  _infoBox(context, 'Speed (knots)', _val('speed', widget.voyage?.upperLimits['speed'] ?? '17.00'), lightFill: lightFill, controllerKey: 'speed'),
                  _infoBox(context, 'HFO MT / Day', _val('hfo', widget.voyage?.upperLimits['hfo'] ?? '85.00'), lightFill: lightFill, controllerKey: 'hfo'),
                  _infoBox(context, 'RPM', _val('rpm', widget.voyage?.upperLimits['rpm'] ?? '260'), lightFill: lightFill, controllerKey: 'rpm'),
                  _infoBox(context, 'Load %', _val('load', widget.voyage?.upperLimits['load'] ?? '80'), lightFill: lightFill, controllerKey: 'load'),
                ])
              ]),
            )
          else if (_activeTab == 1)
            // Route tab content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 360,
                child: Stack(children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Text('CURRENT ROUTE', style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text('NO ROUTE ADDED TO PASSAGE PLAN', style: text.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
                    const SizedBox(height: 18),
                    GestureDetector(onTap: () async {
                      final res = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddRouteScreen(voyage: widget.voyage)));
                      // handle returned route summary if any
                      if (res != null) {
                        // for now we simply show a snack
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Route created: ${res.toString()}')));
                      }
                    }, child: Text('Add New Route', style: text.titleMedium?.copyWith(color: const Color(0xFF9B59B6), fontWeight: FontWeight.w700))),
                    const SizedBox(height: 8),
                    Expanded(child: Container()),
                  ]),
                  Positioned(right: 0, bottom: 0, child: FloatingActionButton(
                    onPressed: () async {
                      final res = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddRouteScreen(voyage: widget.voyage)));
                      if (res != null) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Route created: ${res.toString()}')));
                    },
                    backgroundColor: const Color(0xFF9B59B6),
                    child: const Icon(Icons.add),
                  ))
                ]),
              ),
            )
          else
            // placeholder for other tabs
            Padding(padding: const EdgeInsets.all(16.0), child: Text('No content yet for this tab', style: text.bodyMedium)),
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

  Widget _tabItem(BuildContext context, IconData icon, String label, {bool active = false, VoidCallback? onTap}) {
    final colors = Theme.of(context).colorScheme;
    final accent = const Color(0xFF9B59B6);
    final content = Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: active ? accent : colors.onSurfaceVariant), const SizedBox(height: 6), Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: active ? accent : colors.onSurfaceVariant))]);
    if (onTap != null) {
      return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(8), child: Padding(padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6), child: content));
    }
    return Padding(padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6), child: content);
  }

  Widget _labelValue(BuildContext context, String label, String value, {bool alignRight = false}) {
    final t = Theme.of(context).textTheme;
    return Column(crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [Text(label, style: t.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)), const SizedBox(height: 6), Text(value, style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700))]);
  }

  Widget _metricSmall(BuildContext context, String label, String value) {
    final t = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: t.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant), textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(value, style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w700), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _infoBox(BuildContext context, String label, String value, {bool wide = false, Color? lightFill, String? controllerKey}) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Calculate widths so boxes align with the outer padding and Wrap spacing.
    // Parent padding is 16 on both sides (total 32). Wrap spacing between boxes is 12.
    final totalWidth = MediaQuery.of(context).size.width;
    final innerAvailable = totalWidth - 32; // account for parent horizontal padding
    final boxWidth = wide ? innerAvailable : (innerAvailable - 12) / 2;
    final bg = isDark ? _darkInfo : (lightFill ?? colors.surfaceVariant);
    Widget content;
    if (_editing && controllerKey != null && _c.containsKey(controllerKey)) {
      content = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _c[controllerKey],
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
          decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 6)),
        )
      ]);
    } else {
      content = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant)), const SizedBox(height: 8), Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700))]);
    }

    return Container(
      width: wide ? double.infinity : (boxWidth),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8), border: Border.all(color: colors.outline.withOpacity(0.08))),
      child: content,
    );
  }
}

