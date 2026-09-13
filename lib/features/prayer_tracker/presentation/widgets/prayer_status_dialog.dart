import 'package:flutter/material.dart';
import '../../data/prayer_tracker_storage.dart';
import 'prayer_location_picker.dart';
import '../../../../shared/widgets/pixel/pixel_primitives.dart';
import '../../../../gen_l10n/app_localizations.dart';

String _localizedPrayerShortNameForDialog(AppLocalizations l10n, String name) {
  final key = name.toLowerCase();
  switch (key) {
    case 'sabah':
      return l10n.prayerMorning;
    case 'öğle':
    case 'oğle':
    case 'ogle':
      return l10n.prayerDhuhr;
    case 'ikindi':
      return l10n.prayerAsr;
    case 'akşam':
    case 'aksam':
      return l10n.prayerMaghrib;
    case 'yatsı':
    case 'yatsi':
      return l10n.prayerIsha;
    case 'imsak':
    case 'ımsak':
      return l10n.prayerFajr;
    case 'fajr':
      return l10n.prayerFajr;
    case 'dawn':
      return l10n.prayerMorning;
    default:
      return name;
  }
}

class PrayerStatusDialog extends StatefulWidget {
  final String prayerName;
  final PrayerRecord? currentRecord;
  final Function(PrayerRecord) onRecordUpdated;

  const PrayerStatusDialog({
    super.key,
    required this.prayerName,
    this.currentRecord,
    required this.onRecordUpdated,
  });

  @override
  State<PrayerStatusDialog> createState() => _PrayerStatusDialogState();
}

class _PrayerStatusDialogState extends State<PrayerStatusDialog> {
  PrayerStatus? _selectedStatus;
  bool _showLocationOptions = false;
  bool _loading = false;
  List<PrayerLocation> _savedLocations = [];

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.currentRecord?.status ?? PrayerStatus.none;
    _loadSavedLocations();
  }

  Future<void> _loadSavedLocations() async {
    final storage = PrayerTrackerStorage();
    final locations = await storage.loadSavedLocations();
    setState(() {
      _savedLocations = locations;
    });
  }

  (Color, IconData, String) _getStatusVisual(
    PrayerStatus status,
    ColorScheme scheme,
    AppLocalizations l10n,
  ) {
    switch (status) {
      case PrayerStatus.none:
        return (
          scheme.surfaceVariant,
          Icons.radio_button_unchecked,
          l10n.statusNotPrayed,
        );
      case PrayerStatus.kaza:
        return (scheme.error, Icons.refresh, l10n.statusMakeup);
      case PrayerStatus.kilindi:
        return (scheme.primary, Icons.check_circle, l10n.statusPrayed);
      case PrayerStatus.cemaat:
        return (scheme.secondary, Icons.groups, l10n.statusCongregation);
    }
  }

  void _onStatusSelected(PrayerStatus status) {
    setState(() {
      _selectedStatus = status;
      if (status == PrayerStatus.kaza ||
          status == PrayerStatus.cemaat ||
          status == PrayerStatus.kilindi) {
        _showLocationOptions = true;
      } else {
        _showLocationOptions = false;
        // Immediately save for non-mosque options (only PrayerStatus.none)
        _saveRecord(null);
      }
    });
  }

  void _onLocationSelected(PrayerLocation? location) async {
    bool added = false;
    if (location != null) {
      setState(() {
        _loading = true;
      });

      // Save location to storage if it's new
      final storage = PrayerTrackerStorage();
      added = await storage.saveLocation(location);

      if (added) {
        // Update local cache so UI shows newly added location
        setState(() {
          _savedLocations = [..._savedLocations, location];
        });
      }

      setState(() {
        _loading = false;
      });
    }

    // Pass along whether the location was just added so the record can mark it.
    _saveRecord(location, added);
  }

  void _saveRecord(PrayerLocation? location, [bool isNew = false]) {
    if (_selectedStatus == null) return;
    final record = PrayerRecord(
      status: _selectedStatus!,
      location: location,
      recordedAt: DateTime.now(),
      isNewLocation: isNew,
    );

    widget.onRecordUpdated(record);
    Navigator.of(context).pop();
  }

  Future<void> _openLocationPicker() async {
    final result = await Navigator.of(context).push<PrayerLocation>(
      MaterialPageRoute(
        builder: (context) => PrayerLocationPicker(
          savedLocations: _savedLocations,
          onLocationSelected: (location) {
            Navigator.of(context).pop(location);
          },
        ),
      ),
    );

    if (result != null) {
      _onLocationSelected(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget optionButton({
      required IconData icon,
      required String label,
      required Color color,
      required bool selected,
      required VoidCallback onTap,
    }) {
      return InkWell(
        onTap: onTap,
        child: PixelBox(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          color: selected
              ? color.withValues(alpha: .15)
              : scheme.surface.withValues(alpha: .6),
          borderColor: selected ? color : scheme.outline,
          child: Row(
            children: [
              Icon(
                icon,
                color: selected
                    ? color
                    : scheme.onSurface.withValues(alpha: .72),
                size: 18,
              ),
              const SizedBox(width: 8),
              PixelLabel(
                label,
                fontSize: 11,
                color: selected ? color : scheme.onSurface,
              ),
            ],
          ),
        ),
      );
    }

    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: PixelBox(
        padding: const EdgeInsets.all(14),
        color: scheme.surface.withValues(alpha: 0.95),
        borderColor: scheme.primary,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: PixelLabel(
                l10n.trackerPrayerName(
                  _localizedPrayerShortNameForDialog(l10n, widget.prayerName),
                ),
                fontSize: 12,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            if (!_showLocationOptions) ...[
              PixelLabel(
                l10n.trackerSelectStatus,
                fontSize: 11,
                color: Colors.white70,
              ),
              const SizedBox(height: 10),
              ...PrayerStatus.values.map((status) {
                final (color, icon, label) = _getStatusVisual(
                  status,
                  scheme,
                  l10n,
                );
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: optionButton(
                    icon: icon,
                    label: label,
                    color: color,
                    selected: _selectedStatus == status,
                    onTap: () => _onStatusSelected(status),
                  ),
                );
              }),
            ],

            if (_showLocationOptions && !_loading) ...[
              PixelLabel(
                l10n.trackerWhere,
                fontSize: 11,
                color: Colors.white70,
              ),
              const SizedBox(height: 10),
              optionButton(
                icon: Icons.home,
                label: l10n.trackerLocationAtHome,
                color: scheme.primary,
                selected: false,
                onTap: () => _onLocationSelected(null),
              ),
              const SizedBox(height: 8),
              optionButton(
                icon: Icons.mosque,
                label: l10n.trackerLocationAtMosque,
                color: scheme.secondary,
                selected: false,
                onTap: _openLocationPicker,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: PixelButton(
                  l10n.dialogBack,
                  onPressed: () {
                    setState(() {
                      _showLocationOptions = false;
                    });
                  },
                ),
              ),
            ],

            if (_loading) ...[
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 12),
            ],

            if (!_showLocationOptions && !_loading) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: PixelButton(
                  l10n.dialogCancel,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
