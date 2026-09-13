import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_controller.dart';
import '../../../../shared/widgets/pixel/pixel_primitives.dart';
import 'package:provider/provider.dart';
import '../../../prayer_times/presentation/controllers/prayer_times_controller.dart';
import '../../../notifications/presentation/pages/notification_settings_page.dart';
import '../../../../gen_l10n/app_localizations.dart';

/// Profil ekranı: Tema modu seçimi (Açık / Koyu / AMOLED / Sistem)
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = 'Kullanıcı';
  String? _userImagePath;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfilePersistence();
  }

  Future<void> _loadProfilePersistence() async {
    final prefs = await SharedPreferences.getInstance();
    final storedName = prefs.getString('profile_name');
    final storedImage = prefs.getString('profile_image');
    setState(() {
      _userName = storedName ?? 'Kullanıcı';
      _userImagePath = storedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppControllerProvider.of(context);
    final current = controller.themeMode;
    final prayerController = context.watch<PrayerTimesController>();
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    // Fill color for inner widget areas: use primary (yellow) for light mode,
    // otherwise keep the previous surface-filled look.
    final fillColor = current == AppThemeMode.light
        ? scheme.primary.withValues(alpha: .12)
        : scheme.surface.withValues(alpha: .4);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Kullanıcı Profil Paneli
        const SizedBox(height: 4),
        PixelPanel(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Avatar ve İsim
              GestureDetector(
                onTap: _showImageOptions,
                child: PixelBox(
                  padding: const EdgeInsets.all(6),
                  borderColor: scheme.outline,
                  color: scheme.surfaceVariant.withValues(alpha: .85),
                  child: Container(
                    width: 108,
                    height: 108,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: _userImagePath != null
                          ? DecorationImage(
                              image: FileImage(File(_userImagePath!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _userImagePath == null
                        ? Icon(
                            Icons.person,
                            size: 56,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Kullanıcı Adı
              GestureDetector(
                onTap: _editUserName,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: PixelLabel(
                        _userName,
                        fontSize: 14,
                        color: Colors.white,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.edit,
                      size: 16,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              PixelLabel(
                l10n.profileChangeAvatar,
                fontSize: 9,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Tema Ayarları
        PixelPanel(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PixelLabel(l10n.profileThemeSettings, fontSize: 12),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ThemeSegment(
                    label: l10n.profileThemeLight,
                    icon: Icons.light_mode,
                    selected: current == AppThemeMode.light,
                    onTap: () => controller.setThemeMode(AppThemeMode.light),
                  ),
                  _ThemeSegment(
                    label: l10n.profileThemeDark,
                    icon: Icons.dark_mode,
                    selected: current == AppThemeMode.dark,
                    onTap: () => controller.setThemeMode(AppThemeMode.dark),
                  ),
                  _ThemeSegment(
                    label: l10n.profileThemeAmoled,
                    icon: Icons.contrast,
                    selected: controller.isAmoled,
                    onTap: () => controller.setThemeMode(AppThemeMode.amoled),
                  ),
                  _ThemeSegment(
                    label: l10n.profileThemeSystem,
                    icon: Icons.brightness_auto,
                    selected: current == AppThemeMode.system,
                    onTap: () => controller.setThemeMode(AppThemeMode.system),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Dil Ayarları
        PixelPanel(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PixelLabel('Dil / Language', fontSize: 12),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [AppLanguage.turkish, AppLanguage.english]
                    .map(
                      (language) => _LanguageSegment(
                        label: language.displayName,
                        selected: controller.language == language,
                        onTap: () => controller.setLanguage(language),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Bildirimler
        PixelPanel(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PixelLabel(l10n.profileNotifications, fontSize: 12),
              const SizedBox(height: 10),

              // Bildirim ayarları butonu (küresel PixelNavTile kullanılıyor)
              PixelNavTile(
                icon: Icons.notifications_active,
                title: l10n.profileNotificationSettings,
                subtitle: _getNotificationStatusText(prayerController, l10n),
                color: Colors.grey.withValues(alpha: .18),
                titleColor: Colors.white,
                subtitleColor: Colors.white70,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChangeNotifierProvider<PrayerTimesController>.value(
                            value: prayerController,
                            child: const NotificationSettingsPage(),
                          ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),

              // Hızlı erişim - Kadın özel modu
              if (prayerController.notificationsPaused) ...[
                PixelBox(
                  padding: const EdgeInsets.all(10),
                  borderColor: Theme.of(context).colorScheme.error,
                  color: Theme.of(context).colorScheme.error.withOpacity(0.12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.pause_circle_filled,
                        color: Theme.of(context).colorScheme.error,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            PixelLabel('Kadın Özel Modu Aktif', fontSize: 11),
                            SizedBox(height: 2),
                            PixelLabel(
                              'Tüm bildirimler durduruldu',
                              fontSize: 9,
                            ),
                          ],
                        ),
                      ),
                      PixelButton(
                        'KAPAT',
                        onPressed: () =>
                            prayerController.togglePauseNotifications(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],

              // Hızlı erişim - Namazdayım modu
              if (prayerController.inPrayerMode) ...[
                PixelBox(
                  padding: const EdgeInsets.all(10),
                  borderColor: Theme.of(context).colorScheme.secondary,
                  color: Theme.of(
                    context,
                  ).colorScheme.secondary.withOpacity(0.12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.self_improvement,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const PixelLabel(
                              'Namazdayım Modu Aktif',
                              fontSize: 11,
                            ),
                            const SizedBox(height: 2),
                            PixelLabel(
                              'Bildirimler ${prayerController.inPrayerDelayMinutes} dk erteleniyor',
                              fontSize: 9,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),
                      PixelButton(
                        'KAPAT',
                        onPressed: () => prayerController.toggleInPrayerMode(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],

              // Bildirim özeti
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: PixelLabel(
                      'Tüm bildirim ayarlarınızı yönetin',
                      fontSize: 9,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ...existing code...
      ],
    );
  }

  // Resim seçim seçenekleri göster
  void _showImageOptions() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l10n.profileSelectFromGallery),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Kamera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            if (_userImagePath != null)
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Resmi Sil'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _userImagePath = null;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  // Resim seç
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _userImagePath = image.path;
        });
        await _persistProfile();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resim seçilirken hata oluştu: $e')),
      );
    }
  }

  // İsim düzenle
  void _editUserName() {
    showDialog(
      context: context,
      builder: (context) {
        String newName = _userName;
        return AlertDialog(
          title: const Text('İsim Düzenle'),
          content: TextField(
            controller: TextEditingController(text: _userName),
            decoration: const InputDecoration(
              labelText: 'Adınız',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => newName = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                if (newName.trim().isNotEmpty) {
                  setState(() {
                    _userName = newName.trim();
                  });
                  _persistProfile();
                }
                Navigator.pop(context);
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _persistProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', _userName);
    if (_userImagePath != null) {
      await prefs.setString('profile_image', _userImagePath!);
    } else {
      await prefs.remove('profile_image');
    }
  }

  String _getNotificationStatusText(
    PrayerTimesController controller,
    AppLocalizations l10n,
  ) {
    if (controller.notificationsPaused) {
      return 'Kadın özel modu aktif - Bildirimler kapalı';
    }
    if (controller.inPrayerMode) {
      return 'Namazdayım modu aktif - Erteleniyor';
    }

    final List<String> activeFeatures = [];
    if (controller.notifyOnTime) activeFeatures.add('Vaktinde');
    if (controller.notifyPre)
      activeFeatures.add('${controller.notifyPreMinutes}dk önce');

    if (activeFeatures.isEmpty) {
      return 'Bildirimler kapalı';
    }

    return activeFeatures.join(' • ');
  }
}

class _ThemeSegment extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeSegment({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight =
        AppControllerProvider.of(context).themeMode == AppThemeMode.light;

    return InkWell(
      onTap: onTap,
      child: PixelBox(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        borderColor: selected ? scheme.primary : scheme.outline,
        color: selected
            ? Colors.grey.withValues(alpha: .24)
            : (isLight
                  ? Colors.grey.withValues(alpha: .12)
                  : scheme.surface.withValues(alpha: .4)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            PixelLabel(label, fontSize: 10, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _LanguageSegment extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageSegment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight =
        AppControllerProvider.of(context).themeMode == AppThemeMode.light;

    return InkWell(
      onTap: onTap,
      child: PixelBox(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        borderColor: selected ? scheme.primary : scheme.outline,
        color: selected
            ? Colors.grey.withValues(alpha: .24)
            : (isLight
                  ? Colors.grey.withValues(alpha: .12)
                  : scheme.surface.withValues(alpha: .4)),
        child: PixelLabel(label, fontSize: 10, color: Colors.white),
      ),
    );
  }
}
