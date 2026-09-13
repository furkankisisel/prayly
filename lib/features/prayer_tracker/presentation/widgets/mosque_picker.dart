import 'package:flutter/material.dart';
import 'dart:io';
import '../../../../gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/prayer_tracker_storage.dart';
import '../../../../shared/widgets/pixel/pixel_app_bar.dart';
import '../../../../shared/widgets/pixel/pixel_primitives.dart';

class MosquePicker extends StatefulWidget {
  final Function(PrayerLocation) onLocationSelected;
  final List<PrayerLocation> savedLocations;

  const MosquePicker({
    super.key,
    required this.onLocationSelected,
    required this.savedLocations,
  });

  @override
  State<MosquePicker> createState() => _MosquePickerState();
}

class _MosquePickerState extends State<MosquePicker> {
  final _nameController = TextEditingController();
  String? _selectedImagePath;
  final ImagePicker _picker = ImagePicker();
  bool _isAddingNew = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.mosquePickerImageError(e.toString()))),
        );
      }
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.mosquePickerImageError(e.toString()))),
        );
      }
    }
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: PixelPanel(
            outlineOnly: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PixelLabel(
                  AppLocalizations.of(context)!.mosquePickerTitle,
                  fontSize: 14,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PixelButton(
                      AppLocalizations.of(
                        context,
                      )!.mosquePickerSelectFromGallery,
                      onPressed: () {
                        Navigator.pop(context);
                        _pickImageFromGallery();
                      },
                    ),
                    PixelButton(
                      AppLocalizations.of(context)!.profileSelectFromGallery,
                      onPressed: () {
                        Navigator.pop(context);
                        _takePhoto();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveNewMosque() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.mosquePickerEnterName),
        ),
      );
      return;
    }

    // Check if mosque name already exists
    final existingMosque = widget.savedLocations.firstWhere(
      (mosque) => mosque.name.toLowerCase() == name.toLowerCase(),
      orElse: () => PrayerLocation(name: '', firstVisited: DateTime.now()),
    );

    if (existingMosque.name.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.mosquePickerNameExists),
        ),
      );
      return;
    }

    final location = PrayerLocation(
      name: name,
      imagePath: _selectedImagePath,
      firstVisited: DateTime.now(),
    );

    widget.onLocationSelected(location);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: PixelAppBar(title: l10n.mosquePickerTitle),
      body: _isAddingNew ? _buildAddNewMosqueForm() : _buildSavedMosquesList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            _isAddingNew = !_isAddingNew;
          });
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.mosquePickerAddNewLabel),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildSavedMosquesList() {
    if (widget.savedLocations.isEmpty) {
      return Center(
        child: PixelPanel(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PixelBox(
                padding: const EdgeInsets.all(12),
                color: Colors.transparent,
                borderColor: Theme.of(context).colorScheme.primary,
                child: Icon(
                  Icons.mosque,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              PixelLabel(
                AppLocalizations.of(context)!.mosquePickerNoSaved,
                fontSize: 12,
              ),
              const SizedBox(height: 6),
              PixelLabel(
                AppLocalizations.of(context)!.mosquePickerNote,
                fontSize: 9,
              ),
            ],
          ),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: widget.savedLocations.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final mosque = widget.savedLocations[index];
        return PixelNavTile(
          icon: Icons.mosque,
          title: mosque.name,
          subtitle: AppLocalizations.of(context)!.mosquePickerFirstVisit(
            mosque.firstVisited.day.toString(),
            mosque.firstVisited.month.toString(),
            mosque.firstVisited.year.toString(),
          ),
          onTap: () => widget.onLocationSelected(mosque),
        );
      },
    );
  }

  Widget _buildAddNewMosqueForm() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PixelPanel(
            outlineOnly: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PixelLabel(
                  AppLocalizations.of(context)!.mosquePickerAddNewTitle,
                  fontSize: 14,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                GestureDetector(
                  onTap: _showImageOptions,
                  child: PixelBox(
                    padding: const EdgeInsets.all(8),
                    radius: 8,
                    child: _selectedImagePath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.file(
                              File(_selectedImagePath!),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 140,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 8),
                              PixelLabel(
                                AppLocalizations.of(
                                  context,
                                )!.mosquePickerSelectFromGallery,
                                fontSize: 11,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              PixelLabel(
                                AppLocalizations.of(
                                  context,
                                )!.mosquePickerOptional,
                                fontSize: 9,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 12),

                PixelLabel(
                  AppLocalizations.of(context)!.mosquePickerNameLabel,
                  fontSize: 10,
                ),
                const SizedBox(height: 6),
                PixelBox(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: AppLocalizations.of(
                        context,
                      )!.mosquePickerHintExample,
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                ),

                const SizedBox(height: 12),

                PixelButton(
                  AppLocalizations.of(context)!.mosquePickerSaveMosque,
                  onPressed: _saveNewMosque,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          PixelPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    PixelLabel(
                      AppLocalizations.of(context)!.mosquePickerInfoLabel,
                      fontSize: 11,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                PixelLabel(
                  AppLocalizations.of(context)!.mosquePickerNote,
                  fontSize: 9,
                ),
                PixelLabel(
                  AppLocalizations.of(context)!.mosquePickerOptional,
                  fontSize: 9,
                ),
                PixelLabel(
                  AppLocalizations.of(context)!.mosquePickerNameUnique,
                  fontSize: 9,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
