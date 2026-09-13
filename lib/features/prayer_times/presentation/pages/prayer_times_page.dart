import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../../data/services/place_suggestions_service.dart';
import '../controllers/prayer_times_controller.dart';
import '../../../../shared/widgets/pixel/pixel_prayer_widgets.dart';
import '../../../../shared/widgets/pixel/pixel_primitives.dart';
import '../../../../gen_l10n/app_localizations.dart';

class PrayerTimesPage extends StatelessWidget {
  const PrayerTimesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PrayerTimesController>(
      builder: (context, controller, _) {
        final err = controller.state.error;
        if (err != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final messenger = ScaffoldMessenger.maybeOf(context);
            if (messenger != null && messenger.mounted) {
              messenger.hideCurrentSnackBar();
              messenger.showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.prayerTimesError(err),
                  ),
                ),
              );
            }
          });
        }
        return _PrayerTimesContent(controller: controller);
      },
    );
  }
}

class _PrayerTimesContent extends StatelessWidget {
  final PrayerTimesController controller;
  const _PrayerTimesContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        // Make the content area wider on large screens so prayer tiles appear broader.
        final contentWidth = width > 720 ? 720.0 : width * .96;
        if (state.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.error != null) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.prayerTimesError(state.error!),
            ),
          );
        }
        final data = state.data!;
        final times = data.times;
        final next = state.next;
        // Add a small safe padding around the content so tiles aren't
        // cramped against the app bar or bottom navigation.
        final horizontalPadding = 12.0;
        final topPadding = 12.0;
        final bottomPadding = MediaQuery.of(context).viewPadding.bottom + 16.0;

        return Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              topPadding,
              horizontalPadding,
              bottomPadding,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _LocationToggleBar(controller: controller),
                  const SizedBox(height: 16),
                  PixelCountdownPanel(
                    title: AppLocalizations.of(
                      context,
                    )!.prayerTimesRemainingTime,
                    timeText: controller.formatCountdown(state.countdown),
                    danger: controller.isKerahatTime(),
                    subtitle: controller.isKerahatTime()
                        ? controller.getKerahatReason()
                        : _currentLocationLabel(controller, context),
                    accentColor: Theme.of(context).colorScheme.primary,
                    extra: controller.isKandilDay()
                        ? PixelLabel(
                            controller.getTodaysKandil()!,
                            color: Colors.indigo,
                            fontSize: 11,
                            textAlign: TextAlign.center,
                          )
                        : null,
                  ),
                  const SizedBox(height: 20),
                  for (final t in times) ...[
                    PixelPrayerTile(
                      name: _getPrayerName(t.name, context),
                      time: controller.formatTime(t.time),
                      highlight: next != null && t.name == next.name,
                      lineColor: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 20),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Helper moved from earlier version
String _currentLocationLabel(PrayerTimesController c, BuildContext context) {
  if (c.currentCity != null) {
    return AppLocalizations.of(
      context,
    )!.prayerTimesLocationText(c.currentCity!, c.currentCountry);
  }
  return AppLocalizations.of(context)!.prayerTimesLocationGPS;
}

// Helper to get localized prayer name
String _getPrayerName(String name, BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  switch (name) {
    case 'İmsak':
      return l10n.prayerFajr;
    case 'Sabah':
      return l10n.prayerMorning;
    case 'Güneş':
      return l10n.prayerSunrise;
    case 'Öğle':
      return l10n.prayerDhuhr;
    case 'İkindi':
      return l10n.prayerAsr;
    case 'Akşam':
      return l10n.prayerMaghrib;
    case 'Yatsı':
      return l10n.prayerIsha;
    default:
      return name; // fallback
  }
}

// Old tile removed; PixelPrayerTile is used instead.

class _LocationToggleBar extends StatefulWidget {
  final PrayerTimesController controller;
  const _LocationToggleBar({required this.controller});
  @override
  State<_LocationToggleBar> createState() => _LocationToggleBarState();
}

class _LocationToggleBarState extends State<_LocationToggleBar> {
  bool _expanded = false;
  bool _autoLoading = false;

  Future<void> _useAuto() async {
    setState(() => _autoLoading = true);
    await widget.controller.loadAutomaticLocation();
    if (mounted) setState(() => _autoLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: PixelLabel(
                AppLocalizations.of(context)!.prayerTimesLocation,
                color: theme.colorScheme.primary,
                fontSize: 12,
              ),
            ),
            PixelButton(
              AppLocalizations.of(context)!.prayerTimesAutomatic,
              onPressed: _autoLoading ? null : _useAuto,
              busy: _autoLoading,
              textColor: theme.brightness == Brightness.dark
                  ? Colors.white
                  : null,
            ),
            const SizedBox(width: 8),
            PixelButton(
              _expanded
                  ? AppLocalizations.of(context)!.prayerTimesHide
                  : AppLocalizations.of(context)!.prayerTimesCity,
              onPressed: () => setState(() => _expanded = !_expanded),
              textColor: theme.brightness == Brightness.dark
                  ? Colors.white
                  : null,
            ),
          ],
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _expanded
              ? Padding(
                  key: const ValueKey('expanded'),
                  padding: const EdgeInsets.only(top: 12),
                  child: _CitySearchBar(controller: widget.controller),
                )
              : const SizedBox.shrink(key: ValueKey('collapsed')),
        ),
      ],
    );
  }
}

// Method selector moved to profile page

// Removed previous circular progress visualization since panel now only shows remaining time.

class _CitySearchBar extends StatefulWidget {
  final PrayerTimesController controller;
  const _CitySearchBar({required this.controller});

  @override
  State<_CitySearchBar> createState() => _CitySearchBarState();
}

class _CitySearchBarState extends State<_CitySearchBar> {
  final _ctrl = TextEditingController();
  bool _loading = false;
  List<(String, String)> _currentSuggestions = const [];
  Timer? _debounce;
  bool _fetchingSuggestions = false;
  String _lastFetchedQuery = ''; // son API isteği yapılan sorgu

  // Önerileri asenkron olarak güncelle (dünya çapı)
  void _onTextChanged() {
    final input = _ctrl.text.trim();
    // Debug: trace typing for autocomplete (temporary)
    // ignore: avoid_print
    print(
      '[CitySearch] input="$input" fetchingSuggestions=${_fetchingSuggestions}',
    );
    // Hızlı tepki: önce mevcut listeyi yerel filtreye bırak (Autocomplete zaten filter uyguluyor)
    if (input.length < 2) {
      _debounce?.cancel();
      if (mounted)
        setState(() {
          _currentSuggestions = const [];
          _fetchingSuggestions = false;
        });
      return;
    }

    // Önceki sorgunun uzantısıysa eski sonuçları koruyarak spinner gösterebiliriz
    if (_currentSuggestions.isNotEmpty && input.startsWith(_lastFetchedQuery)) {
      if (mounted && !_fetchingSuggestions)
        setState(() => _fetchingSuggestions = true);
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () async {
      final q = _ctrl.text.trim();
      // ignore: avoid_print
      print('[CitySearch] debounced q="$q"');
      if (q.length < 2) {
        if (mounted)
          setState(() {
            _currentSuggestions = const [];
            _fetchingSuggestions = false;
          });
        return;
      }
      if (mounted) setState(() => _fetchingSuggestions = true);
      final list = await PlaceSuggestionsService.instance.fetch(
        q,
        language: 'tr',
      );
      if (!mounted) return;
      if (q == _ctrl.text.trim()) {
        // Debug: report how many suggestions arrived
        // ignore: avoid_print
        print('[CitySearch] fetched ${list.length} suggestions for "$q"');
        setState(() {
          _currentSuggestions = list;
          _fetchingSuggestions = false;
          _lastFetchedQuery = q;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onTextChanged);
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _search() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    // Parse pattern: City[, Country]
    String city = text;
    String country = 'Turkey';
    if (text.contains(',')) {
      final parts = text.split(',');
      if (parts.isNotEmpty) city = parts[0].trim();
      if (parts.length > 1 && parts[1].trim().isNotEmpty) {
        country = parts.sublist(1).join(',').trim();
      }
    } else {
      // Eğer önerilerde ilk eşleşen varsa ülkeyi al
      final found = _currentSuggestions.firstWhere(
        (e) => e.$1.toLowerCase() == city.toLowerCase(),
        orElse: () => (city, country),
      );
      country = found.$2;
    }
    setState(() => _loading = true);
    await widget.controller.loadByCity(city, country: country);
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CityCountryAutocomplete(
          controller: _ctrl,
          loading: _loading,
          onSubmit: _search,
          fetchingSuggestions: _fetchingSuggestions,
        ),
      ],
    );
  }
}

class _CityCountryAutocomplete extends StatefulWidget {
  final TextEditingController controller;
  final bool loading;
  final Future<void> Function() onSubmit;
  final bool fetchingSuggestions;
  const _CityCountryAutocomplete({
    required this.controller,
    required this.loading,
    required this.onSubmit,
    required this.fetchingSuggestions,
  });

  @override
  State<_CityCountryAutocomplete> createState() =>
      _CityCountryAutocompleteState();
}

class _CityCountryAutocompleteState extends State<_CityCountryAutocomplete> {
  // Öneriler üst bileşende defalarca yeniden hesaplandığı için burada sadece controller text'ine göre gelen listeyi kullanacağız.
  List<(String, String)> get _suggestions =>
      (context
          .findAncestorStateOfType<_CitySearchBarState>()
          ?._currentSuggestions) ??
      const [];
  // Autocomplete kendi controller'ını kullanıyor; dış controller'a senkronize ediyoruz.
  TextEditingController? _lastAutoController;
  VoidCallback? _autoControllerListener;

  Iterable<(String, String)> _filter(String pattern) {
    String _normalize(String s) {
      final low = s.toLowerCase();
      // Basic Turkish character folding to improve matching for user input
      return low
          .replaceAll('ş', 's')
          .replaceAll('ı', 'i')
          .replaceAll('ğ', 'g')
          .replaceAll('ü', 'u')
          .replaceAll('ö', 'o')
          .replaceAll('ç', 'c')
          .replaceAll(RegExp(r"[^a-z0-9,\s]"), '');
    }

    final p = _normalize(pattern.trim());
    if (p.isEmpty) return const [];

    return _suggestions.where((e) {
      final name = _normalize(e.$1);
      final composite = _normalize('${e.$1}, ${e.$2}');
      // Match if the normalized city name or the composite contains the query
      return name.contains(p) || composite.contains(p);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final popupMaxWidth = constraints.maxWidth.clamp(200, 600);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Autocomplete<(String, String)>(
              // Prefer the internal Autocomplete controller text when present
              // (keeps UI responsive), but fall back to the external
              // controller text which our async fetcher updates.
              optionsBuilder: (textEditingValue) {
                final t = textEditingValue.text.isNotEmpty
                    ? textEditingValue.text
                    : widget.controller.text;
                // ignore: avoid_print
                print('[CitySearch][optionsBuilder] text="$t"');
                final opts = _filter(t).toList();
                // ignore: avoid_print
                print(
                  '[CitySearch][optionsBuilder] returning ${opts.length} options',
                );
                return opts;
              },
              displayStringForOption: (opt) => '${opt.$1}, ${opt.$2}',
              fieldViewBuilder: (ctx, textCtrl, focus, onFieldSubmitted) {
                if (textCtrl.text.isEmpty &&
                    widget.controller.text.isNotEmpty) {
                  textCtrl.text = widget.controller.text; // sync
                }
                // Attach listener to the provided internal controller instance and
                // keep a reference so we can remove it later when Autocomplete
                // rebuilds with a different controller. This avoids the bug
                // where a one-time flag left new controllers unbridged.
                if (_lastAutoController != textCtrl) {
                  if (_lastAutoController != null &&
                      _autoControllerListener != null) {
                    _lastAutoController!.removeListener(
                      _autoControllerListener!,
                    );
                  }
                  _autoControllerListener = () {
                    if (widget.controller.text != textCtrl.text) {
                      widget.controller.value = textCtrl.value;
                    }
                  };
                  textCtrl.addListener(_autoControllerListener!);
                  _lastAutoController = textCtrl;
                }
                return PixelSearchField(
                  controller: textCtrl,
                  loading: widget.loading,
                  onSubmit: widget.onSubmit,
                  focusNode: focus,
                  onFieldSubmitted: () => onFieldSubmitted(),
                );
              },
              onSelected: (opt) {
                widget.controller.text = '${opt.$1}, ${opt.$2}';
                widget.onSubmit();
              },
              optionsViewBuilder: (ctx, onSelected, options) {
                // ignore: avoid_print
                print(
                  '[CitySearch][optionsViewBuilder] called with ${options.length} options; controller="${widget.controller.text}" fetching=${widget.fetchingSuggestions}',
                );
                final showNoResults =
                    !widget.fetchingSuggestions &&
                    options.isEmpty &&
                    widget.controller.text.trim().length >= 2;
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: popupMaxWidth.toDouble(),
                        maxHeight: 280,
                      ),
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 120),
                        curve: Curves.easeOut,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (widget.fetchingSuggestions) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.prayerTimesLoading,
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 1),
                            ],
                            if (showNoResults)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                child: Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.prayerTimesNoResults,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              )
                            else
                              Flexible(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (c, i) {
                                    final opt = options.elementAt(i);
                                    return InkWell(
                                      onTap: () => onSelected(opt),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              opt.$1,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              opt.$2,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (_, __) =>
                                      const Divider(height: 1),
                                  itemCount: options.length,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    if (_lastAutoController != null && _autoControllerListener != null) {
      _lastAutoController!.removeListener(_autoControllerListener!);
    }
    super.dispose();
  }
}
