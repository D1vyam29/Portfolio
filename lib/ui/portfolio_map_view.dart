import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PortfolioMapView extends StatefulWidget {
  final int currentStopIndex;
  final bool isPlaying;

  const PortfolioMapView({
    super.key,
    required this.currentStopIndex,
    required this.isPlaying,
  });

  @override
  State<PortfolioMapView> createState() => _PortfolioMapViewState();
}

class _PortfolioMapViewState extends State<PortfolioMapView>
    with TickerProviderStateMixin {
  late final MapController _mapController;

  // Real world coordinates for a short 5km trip (Street Level)
  // Centered around Udyog Vihar / Cyber City, Gurugram
  final List<LatLng> _stops = [
    const LatLng(28.4900, 77.0800), // Start (e.g., Shankar Chowk)
    const LatLng(28.4950, 77.0850), // ~700m away
    const LatLng(28.5000, 77.0820), // Local stop
    const LatLng(28.5050, 77.0880), // ~1.5km
    const LatLng(28.5100, 77.0920), // ~2.5km
    const LatLng(28.5150, 77.0950), // End (DLF Cyber Hub area)
  ];

  LatLng _currentCarPosition = const LatLng(28.4900, 77.0800);

  // Animation controllers
  late AnimationController _moveController;
  late Animation<double> _animation;
  LatLng _startPos = const LatLng(28.4900, 77.0800);
  LatLng _endPos = const LatLng(28.4900, 77.0800);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    // Slower animation to span the "running" time (approx 4-5 seconds per level)
    _moveController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));

    _animation = CurvedAnimation(parent: _moveController, curve: Curves.linear);

    _animation.addListener(() {
      setState(() {
        // Interpolate position
        double t = _animation.value;
        double lat =
            _startPos.latitude + (_endPos.latitude - _startPos.latitude) * t;
        double lng =
            _startPos.longitude + (_endPos.longitude - _startPos.longitude) * t;
        _currentCarPosition = LatLng(lat, lng);

        // Also move camera to follow car, maintaining zoom
        _mapController.move(_currentCarPosition, 16.0);
      });
    });
  }

  @override
  void didUpdateWidget(PortfolioMapView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.currentStopIndex != oldWidget.currentStopIndex) {
      // Level completed! Snap to the exact stop coordinate
      int reachedIndex = widget.currentStopIndex;
      if (reachedIndex < _stops.length) {
        _currentCarPosition = _stops[reachedIndex];

        // Fix: Update startPos to the new stop so resetting controller keeps us here
        _startPos = _stops[reachedIndex];
        _endPos = _stops[reachedIndex]; // Safety

        _moveController.stop();
        _moveController.value = 0;
      }
    }

    if (widget.isPlaying && !oldWidget.isPlaying) {
      _startMovingToNext();
    } else if (!widget.isPlaying && oldWidget.isPlaying) {
      if (_moveController.isAnimating) {
        _moveController.stop();
      }
    }
  }

  void _startMovingToNext() {
    int currentIndex = widget.currentStopIndex;
    int targetIndex = currentIndex + 1;

    if (currentIndex >= _stops.length - 1) return;
    if (targetIndex >= _stops.length) targetIndex = _stops.length - 1;

    _startPos = _currentCarPosition;
    _endPos = _stops[targetIndex];

    _moveController.reset();
    _moveController.forward();
  }

  @override
  void dispose() {
    _mapController.dispose();
    _moveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _stops[0],
        initialZoom: 16.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.divyam.portfolio',
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: _stops,
              strokeWidth: 4.0,
              color: Colors.blue.withValues(alpha: 0.7),
            ),
          ],
        ),
        MarkerLayer(
          markers: [
            // Stops
            ..._stops.map((pos) => Marker(
                  point: pos,
                  width: 20,
                  height: 20,
                  child: const Icon(Icons.location_on,
                      color: Colors.red, size: 20),
                )),
            // Car
            Marker(
              point: _currentCarPosition,
              width: 40,
              height: 40,
              child: const Icon(Icons.directions_car_filled,
                  color: Colors.blue, size: 40),
            ),
          ],
        ),
      ],
    );
  }
}
