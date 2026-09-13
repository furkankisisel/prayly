import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../shared/widgets/pixel/pixel_primitives.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import '../../../../gen_l10n/app_localizations.dart';

/// Kıble Pusulası Ekranı
/// - Cihaz yönü (compass heading)
/// - Kullanıcı lokasyonu -> Kâbe yön açısı (bearing)
/// - Fark açısı ile ok göstərilir.
class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});

  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  double? _heading; // cihazın manyetik/gerçek heading'i (derece)
  Position? _position;
  String? _error;
  bool _locLoading = false;
  bool _permDenied = false;
  bool _permDeniedForever = false;

  static const _kaabaLat = 21.422487; // Kâbe enlemi
  static const _kaabaLon = 39.826206; // Kâbe boylamı
  static const double _toleranceDeg = 3; // hizalanmış saymak için tolerans
  bool _aligned = false; // son build'te hizalı mı

  @override
  void initState() {
    super.initState();
    _listenCompass();
    _initLocation();
  }

  void _listenCompass() {
    // Guard against unsupported platforms (desktop/web)
    final supported = !kIsWeb && (Platform.isAndroid || Platform.isIOS);
    if (!supported) return;
    try {
      FlutterCompass.events?.listen(
        (event) {
          if (!mounted) return;
          setState(() {
            _heading = event.heading; // heading null olabilir (sensör yok)
          });
        },
        onError: (e) {
          // Silently ignore compass on unsupported devices
        },
        cancelOnError: false,
      );
    } catch (_) {
      // Ignore
    }
  }

  Future<void> _initLocation() async {
    setState(() {
      _locLoading = true;
      _error = null;
    });
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          setState(() {
            _error = AppLocalizations.of(context)!.qiblaServiceDisabled;
            _locLoading = false;
          });
        }
        return;
      }
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      // ignore: curly_braces_in_flow_control_structures
      if (perm == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _permDenied = true;
            _permDeniedForever = true;
            _locLoading = false;
            _position = null;
          });
        }
        return;
      } else if (perm == LocationPermission.denied) {
        if (mounted) {
          setState(() {
            _permDenied = true;
            _permDeniedForever = false;
            _locLoading = false;
            _position = null;
          });
        }
        return;
      } else {
        if (mounted) {
          setState(() {
            _permDenied = false;
            _permDeniedForever = false;
          });
        }
      }
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );
      if (mounted) {
        setState(() {
          _position = pos;
          _locLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = AppLocalizations.of(
            context,
          )!.qiblaLocationError(e.toString());
          _locLoading = false;
        });
      }
    }
  }

  Future<void> _requestPermission() async {
    setState(() {
      _locLoading = true;
    });
    try {
      LocationPermission perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _permDenied = true;
            _permDeniedForever = true;
            _locLoading = false;
          });
        }
        return;
      }
      if (perm == LocationPermission.denied) {
        if (mounted) {
          setState(() {
            _permDenied = true;
            _permDeniedForever = false;
            _locLoading = false;
          });
        }
        return;
      }
      // granted
      await _initLocation();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = AppLocalizations.of(
            context,
          )!.qiblaPermissionError(e.toString());
          _locLoading = false;
        });
      }
    }
  }

  Widget _buildPermissionPanel(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return PixelBox(
      padding: const EdgeInsets.all(12),
      borderColor: scheme.outline,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.my_location, color: Colors.white70, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: PixelLabel(
                  AppLocalizations.of(context)!.qiblaPermissionRequired,
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          PixelLabel(
            _permDeniedForever
                ? AppLocalizations.of(context)!.qiblaPermissionPermanentlyDenied
                : AppLocalizations.of(context)!.qiblaPermissionPrompt,
            fontSize: 10,
            color: Colors.white70,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              if (!_permDeniedForever)
                PixelButton(
                  AppLocalizations.of(context)!.qiblaGrantPermission,
                  onPressed: _locLoading ? null : _requestPermission,
                )
              else ...[
                PixelButton(
                  AppLocalizations.of(context)!.qiblaOpenSettings,
                  onPressed: () async {
                    await Geolocator.openAppSettings();
                    await Geolocator.openLocationSettings();
                  },
                ),
              ],
              const SizedBox(width: 8),
              PixelButton(
                AppLocalizations.of(context)!.qiblaRefresh,
                onPressed: _locLoading ? null : _initLocation,
              ),
            ],
          ),
        ],
      ),
    );
  }

  double? get _qiblaBearing {
    final p = _position;
    if (p == null) return null;
    return _calculateBearing(p.latitude, p.longitude, _kaabaLat, _kaabaLon);
  }

  // Büyük daire (initial bearing) hesaplama
  double _calculateBearing(double lat1, double lon1, double lat2, double lon2) {
    final lat1Rad = lat1 * math.pi / 180;
    final lat2Rad = lat2 * math.pi / 180;
    final dLon = (lon2 - lon1) * math.pi / 180;
    final y = math.sin(dLon) * math.cos(lat2Rad);
    final x =
        math.cos(lat1Rad) * math.sin(lat2Rad) -
        math.sin(lat1Rad) * math.cos(lat2Rad) * math.cos(dLon);
    var bearingRad = math.atan2(y, x); // -pi..pi
    bearingRad = (bearingRad * 180 / math.pi + 360) % 360; // 0..360
    return bearingRad;
  }

  @override
  Widget build(BuildContext context) {
    final heading = _heading; // 0 = Kuzey
    final bearing = _qiblaBearing; // 0 = Kuzey (derece)
    final diff = (heading != null && bearing != null)
        ? ((bearing - heading + 540) % 360) -
              180 // -180..180 (sağa/sola sapma)
        : null;
    final nowAligned = diff != null && diff.abs() <= _toleranceDeg;
    if (nowAligned != _aligned) {
      _aligned = nowAligned; // animasyon için state; rebuild zaten oluyor
    }

    return RefreshIndicator(
      onRefresh: _initLocation,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          if (_permDenied || _permDeniedForever)
            _buildPermissionPanel(context)
          else if (_error != null)
            PixelBox(
              padding: const EdgeInsets.all(12),
              color: Theme.of(
                context,
              ).colorScheme.errorContainer.withValues(alpha: .8),
              borderColor: Theme.of(context).colorScheme.error,
              child: PixelLabel(_error!, fontSize: 11, color: Colors.white),
            )
          else if (_locLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            )
          else ...[
            // Yönlendirme metni artık pusula kartının dışında gösteriliyor
            QiblaDirectionHint(
              diff: diff,
              tolerance: _toleranceDeg,
              scheme: Theme.of(context).colorScheme,
            ),
            const SizedBox(height: 12),
            _CompassCard(
              heading: heading,
              qibla: bearing,
              diff: diff,
              aligned: _aligned,
              tolerance: _toleranceDeg,
            ),
            const SizedBox(height: 24),
            _InfoRow(
              label: AppLocalizations.of(context)!.qiblaDeviceDirection,
              value: heading != null ? '${heading.toStringAsFixed(0)}°' : '—',
            ),
            _InfoRow(
              label: AppLocalizations.of(context)!.screenTitleQiblaCompass,
              value: bearing != null ? '${bearing.toStringAsFixed(1)}°' : '—',
            ),
            _InfoRow(
              label: AppLocalizations.of(context)!.qiblaDirectionReading,
              value: diff != null ? '${diff.toStringAsFixed(1)}°' : '—',
            ),
            if (bearing == null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: PixelLabel(
                  AppLocalizations.of(context)!.qiblaWaitingLocation,
                  fontSize: 10,
                  color: Colors.white70,
                ),
              ),
            if (heading == null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: PixelLabel(
                  AppLocalizations.of(context)!.qiblaCompassSensorUnavailable,
                  fontSize: 10,
                  color: Colors.white70,
                ),
              ),
            const SizedBox(height: 32),
            PixelLabel(
              AppLocalizations.of(context)!.qiblaPullToRefresh,
              fontSize: 9,
              color: Colors.white60,
            ),
          ],
        ],
      ),
    );
  }
}

class _CompassCard extends StatefulWidget {
  final double? heading; // 0..360
  final double? qibla; // 0..360
  final double? diff; // -180..180
  final bool aligned;
  final double tolerance;
  const _CompassCard({
    required this.heading,
    required this.qibla,
    required this.diff,
    required this.aligned,
    required this.tolerance,
  });

  @override
  State<_CompassCard> createState() => _CompassCardState();
}

class _CompassCardState extends State<_CompassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    if (widget.aligned) _controller.forward();
  }

  @override
  void didUpdateWidget(covariant _CompassCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.aligned && !oldWidget.aligned) {
      _controller.forward(from: 0);
    } else if (!widget.aligned && oldWidget.aligned) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final heading = widget.heading;
    final qibla = widget.qibla;
    final diff = widget.diff;
    return AspectRatio(
      aspectRatio: 1,
      child: PixelBox(
        padding: const EdgeInsets.all(16),
        color: scheme.surface,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.biggest.shortestSide;
            final ringPadding = 12.0;
            final effectiveHeading = heading ?? 0.0; // 0 = Kuzey
            final qiblaDeg = qibla ?? 0.0;
            final relAngle =
                (qiblaDeg - effectiveHeading) *
                math.pi /
                180; // ekrana göre kıble açısı
            return Stack(
              alignment: Alignment.center,
              children: [
                // Dönen halka (yön harfleri ve tickler birlikte)
                Transform.rotate(
                  angle:
                      -effectiveHeading *
                      math.pi /
                      180, // cihaz döndükçe halka ters döner, N üstte kalır
                  child: _CompassRing(
                    size: size - ringPadding * 2,
                    scheme: scheme,
                  ),
                ),
                // Pixel-minecraft tarzı ibre
                Transform.rotate(
                  angle: relAngle,
                  child: _PixelNeedle(primary: scheme.primary),
                ),
                // Yönlendirme metni
                // Guidance artık dışarı taşındı
                Positioned(
                  bottom: 12,
                  child: Column(
                    children: [
                      PixelLabel(
                        diff != null
                            ? '${diff.abs().toStringAsFixed(1)}° ${(diff >= 0) ? 'sağ' : 'sol'}'
                            : '—',
                        fontSize: 11,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      const PixelLabel(
                        'Kıble',
                        fontSize: 10,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ),
                // Başarı tiki
                Positioned(
                  child: IgnorePointer(
                    child: ScaleTransition(
                      scale: _scale,
                      child: FadeTransition(
                        opacity: _opacity,
                        child: Icon(
                          Icons.check_circle_rounded,
                          size: size * 0.35,
                          color: scheme.tertiary.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Kıble yönü hizalama ipucu (Sağa/Sola dön/Hizalandı vb.)
class QiblaDirectionHint extends StatelessWidget {
  final double? diff;
  final double tolerance;
  final ColorScheme scheme;
  const QiblaDirectionHint({
    super.key,
    required this.diff,
    required this.tolerance,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    String text;
    Color bg;
    IconData icon;
    if (diff == null) {
      text = AppLocalizations.of(context)!.qiblaDirectionWaiting;
      bg = scheme.surfaceContainerHighest;
      icon = Icons.explore_outlined;
    } else if (diff!.abs() <= tolerance) {
      text = AppLocalizations.of(context)!.qiblaAligned;
      bg = scheme.primaryContainer;
      icon = Icons.check;
    } else if (diff! > 0) {
      text = AppLocalizations.of(context)!.qiblaTurnRight;
      bg = scheme.secondaryContainer;
      icon = Icons.rotate_right;
    } else {
      text = AppLocalizations.of(context)!.qiblaTurnLeft;
      bg = scheme.secondaryContainer;
      icon = Icons.rotate_left;
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: PixelBox(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        color: bg.withValues(alpha: 0.85),
        borderColor: scheme.outline,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: Colors.black87),
            const SizedBox(width: 6),
            PixelLabel(text, fontSize: 11, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _CompassRing extends StatelessWidget {
  final double size;
  final ColorScheme scheme;
  const _CompassRing({required this.size, required this.scheme});
  @override
  Widget build(BuildContext context) {
    final lettersStyleColor = scheme.onSurface;
    // Build a pixel-art circular frame by placing many small square segments
    // around the circumference, then draw an inner circular face.
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pixel ring segments
          ...List.generate(64, (i) {
            final angle = i * (2 * math.pi / 64);
            const segSize = 6.0;
            // small inward offset so segments sit inside the outer edge
            const segInset = 4.0;
            return Positioned.fill(
              child: Transform.rotate(
                angle: angle,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: segInset),
                    child: Container(
                      width: segSize,
                      height: segSize,
                      decoration: BoxDecoration(
                        color: scheme.primary,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            offset: const Offset(1, 1),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
          // Inner circular face
          Container(
            width: size - 22,
            height: size - 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.surface.withValues(alpha: 0.08),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(2, 2),
                  color: Colors.black,
                  blurRadius: 0,
                ),
              ],
            ),
          ),
          // Tick marks
          ...List.generate(32, (i) {
            final isCardinal = i % 8 == 0; // 8 yön işareti
            final angle = (i * (360 / 32)) * math.pi / 180;
            final length = isCardinal ? 14.0 : 8.0;
            final thickness = isCardinal ? 4.0 : 3.0;
            return Positioned.fill(
              child: Transform.rotate(
                angle: angle,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: thickness,
                    height: length,
                    decoration: BoxDecoration(
                      color: isCardinal
                          ? scheme.primary
                          : scheme.outlineVariant,
                    ),
                  ),
                ),
              ),
            );
          }),
          // Cardinal letters (N,E,S,W) - oriented upright (so inside opposite rotation of ring)
          _letter('N', 0, lettersStyleColor),
          _letter('E', 90, lettersStyleColor),
          _letter('S', 180, lettersStyleColor),
          _letter('W', 270, lettersStyleColor),
        ],
      ),
    );
  }

  Widget _letter(String txt, double deg, Color color) {
    return Positioned.fill(
      child: Transform.rotate(
        angle: deg * math.pi / 180,
        child: Align(
          alignment: Alignment.topCenter,
          child: Transform.rotate(
            angle: -deg * math.pi / 180, // keep upright
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: PixelLabel(txt, fontSize: 10, color: color),
            ),
          ),
        ),
      ),
    );
  }
}

class _PixelNeedle extends StatelessWidget {
  final Color primary;
  const _PixelNeedle({required this.primary});
  @override
  Widget build(BuildContext context) {
    // Minecraft-like: red tip + white tail in pixel blocks with a small hub
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tip uses theme error color (stands out)
        Container(
          width: 10,
          height: 10,
          color: Theme.of(context).colorScheme.error,
        ),
        const SizedBox(height: 2),
        // Stem as stacked pixels
        Container(width: 8, height: 8, color: primary),
        const SizedBox(height: 2),
        Container(width: 8, height: 8, color: primary.withValues(alpha: .9)),
        const SizedBox(height: 2),
        Container(
          width: 8,
          height: 8,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.9),
        ),
        const SizedBox(height: 2),
        Container(
          width: 8,
          height: 8,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
        const SizedBox(height: 6),
        // Hub
        PixelBox(
          padding: const EdgeInsets.all(2),
          color: Colors.black.withValues(alpha: .6),
          borderColor: primary,
          child: Container(width: 6, height: 6, color: Colors.white24),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const SizedBox(width: 6),
          Expanded(
            child: PixelLabel(label, fontSize: 10, color: Colors.white70),
          ),
          PixelLabel(value, fontSize: 11, color: Colors.white),
        ],
      ),
    );
  }
}
