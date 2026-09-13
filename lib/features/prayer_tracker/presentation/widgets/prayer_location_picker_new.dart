import 'package:flutter/material.dart';
import '../../data/prayer_tracker_storage.dart';
import 'mosque_picker.dart';

class PrayerLocationPicker extends StatelessWidget {
  final Function(PrayerLocation) onLocationSelected;
  final List<PrayerLocation> savedLocations;

  const PrayerLocationPicker({
    super.key,
    required this.onLocationSelected,
    required this.savedLocations,
  });

  @override
  Widget build(BuildContext context) {
    return MosquePicker(
      onLocationSelected: onLocationSelected,
      savedLocations: savedLocations,
    );
  }
}
