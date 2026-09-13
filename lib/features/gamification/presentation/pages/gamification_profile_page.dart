import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/local_gamification_repository.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/game_card.dart';
import '../../domain/services/gamification_stats_service.dart';
import '../../../../shared/widgets/pixel_card.dart';
import '../../../../shared/widgets/pixel_profile_card.dart';
import '../../../../shared/widgets/pixel/pixel_app_bar.dart';
import '../../../../shared/widgets/pixel/pixel_tab_bar.dart';
import '../../../../shared/widgets/pixel/pixel_primitives.dart';
import '../../../../gen_l10n/app_localizations.dart';

class GamificationProfilePage extends StatefulWidget {
  const GamificationProfilePage({super.key});

  @override
  State<GamificationProfilePage> createState() =>
      _GamificationProfilePageState();
}

class _GamificationProfilePageState extends State<GamificationProfilePage>
    with TickerProviderStateMixin {
  final gamificationRepo = LocalGamificationRepository();
  UserProfile? userProfile;
  List<GameCard> cards = [];
  UserStatsReport? statsReport;
  bool loading = true;

  String? _displayName;
  String? _avatarPath;

  late TabController _tabController;
  late final AnimationController
  _fxController; // genel görsel efektler (parlama, shimmer)

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fxController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fxController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      debugPrint('Gamification: Profil yükleniyor...');
      // Kullanıcı görünür adı & avatar (profil ekranı persistence)
      await _loadUserDisplayInfo();
      final profile = await gamificationRepo.getUserProfile();
      debugPrint(
        'Gamification: Profil yüklendi - Level: ${profile.level}, XP: ${profile.totalXp}',
      );

      debugPrint('Gamification: Kartlar yükleniyor...');
      final allCards = await gamificationRepo.getAllCards();
      debugPrint('Gamification: ${allCards.length} kart yüklendi');

      // Localize cards if needed
      final l10n = mounted ? AppLocalizations.of(context) : null;
      if (l10n != null) {
        final cardTitles = <String, String>{
          'cardHomePrayerStreak': l10n.cardHomePrayerStreak,
          'cardHomePrayerTotal': l10n.cardHomePrayerTotal,
          'cardQadaPrayerTotal': l10n.cardQadaPrayerTotal,
          'cardCongregationStreak': l10n.cardCongregationStreak,
          'cardCongregationTotal': l10n.cardCongregationTotal,
          'cardMosqueCongregationStreak': l10n.cardMosqueCongregationStreak,
          'cardMosqueCongregationTotal': l10n.cardMosqueCongregationTotal,
          'cardFridayStreak': l10n.cardFridayStreak,
          'cardFridayTotal': l10n.cardFridayTotal,
          'cardKandilStreak': l10n.cardKandilStreak,
          'cardKandilTotal': l10n.cardKandilTotal,
          'cardEidStreak': l10n.cardEidStreak,
          'cardEidTotal': l10n.cardEidTotal,
          'cardMosqueDiscovery': l10n.cardMosqueDiscovery,
          'cardMosqueRegular': l10n.cardMosqueRegular,
          'cardFirstPrayer': l10n.cardFirstPrayer,
          'cardHundredPrayers': l10n.cardHundredPrayers,
          'cardFiveHundredPrayers': l10n.cardFiveHundredPrayers,
          'cardThousandPrayers': l10n.cardThousandPrayers,
        };

        final cardDescriptions = <String, String>{
          'cardDescHomePrayerStreak': l10n.cardDescHomePrayerStreak,
          'cardDescHomePrayerTotal': l10n.cardDescHomePrayerTotal,
          'cardDescQadaPrayerTotal': l10n.cardDescQadaPrayerTotal,
          'cardDescCongregationStreak': l10n.cardDescCongregationStreak,
          'cardDescCongregationTotal': l10n.cardDescCongregationTotal,
          'cardDescMosqueCongregationStreak':
              l10n.cardDescMosqueCongregationStreak,
          'cardDescMosqueCongregationTotal':
              l10n.cardDescMosqueCongregationTotal,
          'cardDescFridayStreak': l10n.cardDescFridayStreak,
          'cardDescFridayTotal': l10n.cardDescFridayTotal,
          'cardDescKandilStreak': l10n.cardDescKandilStreak,
          'cardDescKandilTotal': l10n.cardDescKandilTotal,
          'cardDescEidStreak': l10n.cardDescEidStreak,
          'cardDescEidTotal': l10n.cardDescEidTotal,
          'cardDescMosqueDiscovery': l10n.cardDescMosqueDiscovery,
          'cardDescMosqueRegular': l10n.cardDescMosqueRegular,
          'cardDescFirstPrayer': l10n.cardDescFirstPrayer,
          'cardDescHundredPrayers': l10n.cardDescHundredPrayers,
          'cardDescFiveHundredPrayers': l10n.cardDescFiveHundredPrayers,
          'cardDescThousandPrayers': l10n.cardDescThousandPrayers,
        };

        await gamificationRepo.localizeCards(cardTitles, cardDescriptions);
      }

      // Reload cards after localization
      final localizedCards = await gamificationRepo.getAllCards();

      debugPrint('Gamification: İstatistikler hesaplanıyor...');
      final statsService = GamificationStatsService(gamificationRepo);
      final stats = await statsService.generateStatsReport();
      debugPrint('Gamification: İstatistikler hazırlandı');

      if (mounted) {
        setState(() {
          userProfile = profile;
          cards = localizedCards;
          statsReport = stats;
          loading = false;
        });
      }
      debugPrint('Gamification: Yükleme tamamlandı');
    } catch (e, stackTrace) {
      debugPrint('Gamification profil yükleme hatası: $e');
      debugPrint('Stack trace: $stackTrace');

      // Varsayılan profil oluştur
      final defaultProfile = UserProfile(
        totalXp: 0.0,
        lastUpdated: DateTime.now(),
        seasonXp: 0,
      );

      if (mounted) {
        setState(() {
          userProfile = defaultProfile;
          cards = [];
          loading = false;
        });
      }
    }
  }

  Future<void> _loadUserDisplayInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _displayName =
            prefs.getString('profile_name') ??
            AppLocalizations.of(context)?.defaultUser ??
            'User';
        _avatarPath = prefs.getString('profile_image');
      });
    } catch (e) {
      debugPrint('Gamification: display info yüklenemedi: $e');
      _displayName ??= AppLocalizations.of(context)?.defaultUser ?? 'User';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (loading) {
      return Scaffold(
        appBar: PixelAppBar(title: l10n.gamificationProfile),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (userProfile == null) {
      return Scaffold(
        appBar: PixelAppBar(title: l10n.gamificationProfile),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                l10n.gamificationErrorLoading,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.gamificationPleaseRestart,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: PixelAppBar(
        title: null, // Remove 'SEVİYEM' from TabBar area
        bottom: PixelTabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: Center(child: Icon(Icons.person, color: scheme.onPrimary)),
              text: l10n.gamificationProfile,
            ),
            Tab(
              icon: Center(
                child: Icon(Icons.collections, color: scheme.onPrimary),
              ),
              text: l10n.gamificationCards,
            ),
            Tab(
              icon: Center(
                child: Icon(Icons.analytics, color: scheme.onPrimary),
              ),
              text: l10n.gamificationStatistics,
            ),
          ],
          backgroundColor: scheme.primary,
          indicatorColor: scheme.onPrimary,
          height: 72,
        ),
        backgroundColor: _getFrameColor(userProfile!.frame),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProfileTab(context),
          _buildCardsTab(context),
          _buildStatsTab(context),
        ],
      ),
    );
  }

  Widget _buildProfileCard(UserProfile profile) {
    final streakCards = cards.where((c) => c.type == GameCardType.streak);
    final activeStreaks = streakCards.where((c) => c.progress > 0).length;
    final bestStreak = statsReport?.bestStreak.toInt() ?? 0;
    final totalPrayers = statsReport?.totalPrayers.toInt() ?? 0;
    final congregationTotal = statsReport?.congregationTotal.toInt() ?? 0;
    final uniqueMosques = statsReport?.uniqueMosques.toInt() ?? 0;
    final totalCards = statsReport?.totalCards ?? cards.length;
    final weeklyXp = statsReport?.weeklyXp.toInt() ?? 0;

    return PixelProfileCard(
      displayName: _displayName ?? AppLocalizations.of(context)!.defaultUser,
      avatarPath: _avatarPath,
      level: profile.level,
      totalXp: profile.totalXp,
      nextLevelXp: profile.nextLevelXp,
      levelProgress: profile.levelProgress,
      title: profile.title,
      stats: {
        AppLocalizations.of(context)!.statAbbrTotal: totalPrayers,
        AppLocalizations.of(context)!.statAbbrCongregation: congregationTotal,
        AppLocalizations.of(context)!.statAbbrActive: activeStreaks,
        AppLocalizations.of(context)!.statAbbrBest: bestStreak,
        AppLocalizations.of(context)!.statAbbrMosques: uniqueMosques,
        AppLocalizations.of(context)!.statAbbrCards: totalCards,
        AppLocalizations.of(context)!.statAbbrWeekly: weeklyXp,
      },
    );
  }

  // Removed old _chipStat method (now handled by PixelProfileCard)

  // Removed old FIFA-style stat row (replaced by compact chips)

  Widget _buildCategorySection(String title, GameCardCategory category) {
    final categoryCards = cards.where((c) => c.category == category).toList();
    if (categoryCards.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: PixelLabel(title, fontSize: 12),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categoryCards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _calculateCrossAxisCount(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.5 / 3.5,
          ),
          itemBuilder: (ctx, i) => _buildGameCard(categoryCards[i]),
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  int _calculateCrossAxisCount() {
    final width = MediaQuery.of(context).size.width;
    final cardWidth = 150; // hedef genişlik
    final count = (width / cardWidth).floor();
    return count.clamp(2, 4);
  }

  Widget _buildGameCard(GameCard card) {
    // Use overlayIcon for type-specific small badge (streak/total/milestone)
    return PixelCard(
      title: card.title,
      icon: card.icon,
      overlayIcon: card.typeIcon,
      rarity: _mapToPixelRarity(card.rarity),
      xpValue: card.xpContributed.toInt(),
      progressValue: card.progress.toInt(),
      progressType: card.type == GameCardType.streak ? 'streak' : 'total',
      onTap: () => _showCardDetail(card),
    );
  }

  PixelRarity _mapToPixelRarity(Rarity rarity) {
    switch (rarity) {
      case Rarity.bronze:
        return PixelRarity.siradan;
      case Rarity.silver:
        return PixelRarity.nadir;
      case Rarity.gold:
        return PixelRarity.pro;
      case Rarity.diamond:
        return PixelRarity.gizemli;
    }
  }

  void _showCardDetail(GameCard card) {
    final rarityColor = _getRarityColor(card.rarity);
    final pixelRarity = _mapToPixelRarity(card.rarity);
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: .55),
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 32,
          ),
          child: PixelPanel(
            padding: const EdgeInsets.all(14),
            outlineOnly: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: PixelLabel(
                        card.title.toUpperCase(),
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      icon: const Icon(Icons.close, color: Colors.white70),
                      splashRadius: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Rarity / type badge
                Row(
                  children: [
                    PixelBox(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      color: rarityColor.withValues(alpha: .08),
                      borderColor: rarityColor,
                      child: PixelLabel(
                        '${pixelRarity.displayName(context).toUpperCase()} • ${card.type.name.toUpperCase()}',
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                PixelLabel(
                  card.description,
                  fontSize: 12,
                  color: Colors.white70,
                ),

                const SizedBox(height: 14),

                _buildDetailStatRow(
                  AppLocalizations.of(context)!.detailProgress,
                  '${card.progress.toInt()}',
                ),
                _buildDetailStatRow(
                  AppLocalizations.of(context)!.detailXpContribution,
                  card.xpContributed.toInt().toString(),
                ),
                _buildDetailStatRow(
                  AppLocalizations.of(context)!.detailRarityScore,
                  card.rarityValue.toInt().toString(),
                ),
                if (card.nextRarityThreshold > 0)
                  _buildDetailStatRow(
                    AppLocalizations.of(context)!.detailNextThreshold,
                    card.nextRarityThreshold.toInt().toString(),
                  ),

                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                    icon: const Icon(Icons.check_circle_outline),
                    label: Text(AppLocalizations.of(context)!.dialogClose),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: PixelLabel(label, fontSize: 11, color: Colors.white60),
          ),
          PixelLabel(value, fontSize: 12, color: Colors.white),
        ],
      ),
    );
  }

  // Mini stat row removed - now handled by CollectionCard widget

  // Removed rarity gradient (no longer used in modern design)

  Color _getFrameColor(ProfileFrame frame) {
    switch (frame) {
      case ProfileFrame.basic:
        return Colors.grey;
      case ProfileFrame.bronze:
        return const Color(0xFFCD7F32);
      case ProfileFrame.silver:
        return const Color(0xFFC0C0C0);
      case ProfileFrame.gold:
        return const Color(0xFFFFD700);
      case ProfileFrame.diamond:
        return const Color(0xFFB9F2FF);
      case ProfileFrame.platinum:
        return const Color(0xFFE5E4E2);
      case ProfileFrame.divine:
        return const Color(0xFFFFB6C1);
      case ProfileFrame.cosmic:
        return const Color(0xFF9370DB);
      case ProfileFrame.aurora:
        return const Color(0xFF00FF7F);
    }
  }

  Color _getRarityColor(Rarity rarity) {
    switch (rarity) {
      case Rarity.bronze:
        return const Color(0xFFCD7F32);
      case Rarity.silver:
        return const Color(0xFFC0C0C0);
      case Rarity.gold:
        return const Color(0xFFFFD700);
      case Rarity.diamond:
        return const Color(0xFFB9F2FF);
    }
  }

  // New: map category -> icon/color for the stats distribution
  IconData _getCategoryIcon(GameCardCategory category) {
    switch (category) {
      case GameCardCategory.daily:
        return Icons.calendar_today;
      case GameCardCategory.friday:
        return Icons.mosque;
      case GameCardCategory.kandil:
        return Icons.brightness_7;
      case GameCardCategory.eid:
        return Icons.celebration;
      case GameCardCategory.mosque:
        return Icons.location_on;
      case GameCardCategory.milestone:
        return Icons.emoji_events;
    }
  }

  Color _getCategoryColor(GameCardCategory category) {
    switch (category) {
      case GameCardCategory.daily:
        return Colors.teal;
      case GameCardCategory.friday:
        return const Color(0xFF6A5ACD); // slate-ish
      case GameCardCategory.kandil:
        return Colors.deepPurple;
      case GameCardCategory.eid:
        return Colors.deepOrange;
      case GameCardCategory.mosque:
        return Colors.indigo;
      case GameCardCategory.milestone:
        return Colors.amber;
    }
  }

  String _categoryDisplayName(GameCardCategory category) {
    switch (category) {
      case GameCardCategory.daily:
        return AppLocalizations.of(context)!.categoryDaily;
      case GameCardCategory.friday:
        return AppLocalizations.of(context)!.categoryFriday;
      case GameCardCategory.kandil:
        return AppLocalizations.of(context)!.categoryKandil;
      case GameCardCategory.eid:
        return AppLocalizations.of(context)!.categoryEid;
      case GameCardCategory.mosque:
        return AppLocalizations.of(context)!.categoryMosque;
      case GameCardCategory.milestone:
        return AppLocalizations.of(context)!.categoryMilestone;
    }
  }

  Widget _buildCategoryStatCard(GameCardCategory category, int count) {
    final color = _getCategoryColor(category);
    return PixelPanel(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      outlineOnly: true,
      child: Row(
        children: [
          PixelBox(
            padding: const EdgeInsets.all(6),
            color: color.withValues(alpha: .12),
            borderColor: color,
            child: Icon(_getCategoryIcon(category), color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: PixelLabel(_categoryDisplayName(category), fontSize: 10),
          ),
          PixelLabel(
            '${count.toString()} ${AppLocalizations.of(context)!.cardCountUnit}',
            fontSize: 10,
            color: color,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildProfileCard(userProfile!),
        const SizedBox(height: 24),
        if (statsReport?.activeStreaks.isNotEmpty ?? false) ...[
          PixelLabel(
            AppLocalizations.of(context)!.activeStreaks,
            fontSize: 14,
            color: Colors.orange,
          ),
          const SizedBox(height: 18),
          ...statsReport!.activeStreaks.map(
            (streak) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PixelPanel(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: Colors.orange,
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: PixelLabel(streak.title, fontSize: 12)),
                    PixelLabel(
                      '${streak.currentValue} ${AppLocalizations.of(context)!.daysUnit}',
                      fontSize: 12,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCardsTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        PixelLabel(
          AppLocalizations.of(context)!.cardsCollection(cards.length),
          fontSize: 16,
        ),
        const SizedBox(height: 12),
        _buildCategorySection(
          AppLocalizations.of(context)!.categoryDaily,
          GameCardCategory.daily,
        ),
        _buildCategorySection(
          AppLocalizations.of(context)!.categoryFriday,
          GameCardCategory.friday,
        ),
        _buildCategorySection(
          AppLocalizations.of(context)!.categoryKandil,
          GameCardCategory.kandil,
        ),
        _buildCategorySection(
          AppLocalizations.of(context)!.categoryEid,
          GameCardCategory.eid,
        ),
        _buildCategorySection(
          AppLocalizations.of(context)!.categoryMosque,
          GameCardCategory.mosque,
        ),
        _buildCategorySection(
          AppLocalizations.of(context)!.categoryMilestone,
          GameCardCategory.milestone,
        ),
      ],
    );
  }

  Widget _buildStatsTab(BuildContext context) {
    if (statsReport == null) {
      return Center(
        child: Text(AppLocalizations.of(context)!.statsFailedToLoad),
      );
    }

    // Compute category distribution from current cards (new card types)
    final Map<GameCardCategory, int> categoryDist = {
      for (final c in GameCardCategory.values) c: 0,
    };
    for (final card in cards) {
      categoryDist[card.category] = (categoryDist[card.category] ?? 0) + 1;
    }
    final List<GameCardCategory> categoryOrder = [
      GameCardCategory.daily,
      GameCardCategory.friday,
      GameCardCategory.kandil,
      GameCardCategory.eid,
      GameCardCategory.mosque,
      GameCardCategory.milestone,
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 8),
        PixelLabel(
          AppLocalizations.of(context)!.generalStatistics,
          fontSize: 14,
        ),
        const SizedBox(height: 18),

        // Pixel-styled stat cards (add spacing between each)
        _buildStatCard(
          AppLocalizations.of(context)!.statTotalPrayers,
          '${statsReport!.totalPrayers.toInt()}',
          Icons.access_time,
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          AppLocalizations.of(context)!.statCongregationPrayers,
          '${statsReport!.congregationTotal.toInt()}',
          Icons.groups,
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          AppLocalizations.of(context)!.statBestStreak,
          '${statsReport!.bestStreak.toInt()} ${AppLocalizations.of(context)!.daysUnit}',
          Icons.local_fire_department,
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          AppLocalizations.of(context)!.statWeeklyXp,
          '${statsReport!.weeklyXp.toInt()}',
          Icons.trending_up,
        ),

        const SizedBox(height: 22),

        // Kart türü dağılımı (güncel kart kategorilerine göre)
        PixelLabel(
          AppLocalizations.of(context)!.cardsDistribution,
          fontSize: 12,
        ),
        const SizedBox(height: 16),

        ...categoryOrder.map(
          (cat) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildCategoryStatCard(cat, categoryDist[cat] ?? 0),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    final scheme = Theme.of(context).colorScheme;
    return PixelPanel(
      padding: const EdgeInsets.all(12),
      outlineOnly: false,
      child: Row(
        children: [
          PixelBox(
            padding: const EdgeInsets.all(8),
            color: scheme.primary.withValues(alpha: .12),
            borderColor: scheme.primary,
            child: Icon(icon, size: 20, color: scheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PixelLabel(
                  title,
                  fontSize: 10,
                  color: scheme.onSurface.withValues(alpha: .9),
                ),
                const SizedBox(height: 6),
                PixelLabel(value, fontSize: 14, color: scheme.onSurface),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Removed shine painter (no longer used in modern design)
