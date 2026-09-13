import 'package:flutter/material.dart';
import 'shared/widgets/neon_outline_card.dart';
import 'shared/widgets/card_rarity.dart';

void main() {
  runApp(const NeonOutlineDemoApp());
}

class NeonOutlineDemoApp extends StatelessWidget {
  const NeonOutlineDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neon Outline Demo',
      theme: ThemeData.dark(useMaterial3: true),
      home: const NeonOutlineDemoPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NeonOutlineDemoPage extends StatelessWidget {
  const NeonOutlineDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF000000), Color(0xFF0A0A0A), Color(0xFF000000)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(),

                const SizedBox(height: 40),

                // Cards grid
                _buildCardsGrid(context),

                const SizedBox(height: 40),

                // Features info
                _buildFeaturesInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'NEON OUTLINE',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 2,
            shadows: [
              Shadow(
                color: const Color(0xFF00E5FF).withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Minimalist cyberpunk aesthetic with clean lines',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.7),
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: 80,
          height: 2,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00E5FF), Color(0xFF64FFDA)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00E5FF).withOpacity(0.6),
                blurRadius: 8,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardsGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.7,
      ),
      itemCount: _getCardData().length,
      itemBuilder: (context, index) {
        final cardData = _getCardData()[index];
        return NeonOutlineCard(
          title: cardData['title'],
          icon: cardData['icon'],
          rarity: cardData['rarity'],
          xpValue: cardData['xp'],
          progressValue: cardData['progress'],
          progressType: cardData['progressType'],
          onTap: () => _showCardDetails(context, cardData),
        );
      },
    );
  }

  List<Map<String, dynamic>> _getCardData() {
    return [
      {
        'title': 'Morning Prayer',
        'icon': Icons.wb_sunny_outlined,
        'rarity': CardRarity.gold,
        'xp': 250,
        'progress': 85,
        'progressType': 'streak',
      },
      {
        'title': 'Quran Study',
        'icon': Icons.menu_book_outlined,
        'rarity': CardRarity.diamond,
        'xp': 180,
        'progress': 65,
        'progressType': 'daily',
      },
      {
        'title': 'Meditation',
        'icon': Icons.self_improvement_outlined,
        'rarity': CardRarity.platinum,
        'xp': 120,
        'progress': 92,
        'progressType': 'streak',
      },
      {
        'title': 'Prayer Collection',
        'icon': Icons.favorite_outline,
        'rarity': CardRarity.nur,
        'xp': 300,
        'progress': 78,
        'progressType': 'total',
      },
      {
        'title': 'Night Prayer',
        'icon': Icons.nights_stay_outlined,
        'rarity': CardRarity.silver,
        'xp': 150,
        'progress': 45,
        'progressType': 'daily',
      },
      {
        'title': 'Master Level',
        'icon': Icons.auto_awesome_outlined,
        'rarity': CardRarity.sidre,
        'xp': 500,
        'progress': 100,
        'progressType': 'master',
      },
    ];
  }

  Widget _buildFeaturesInfo() {
    final features = [
      {
        'icon': Icons.border_color_outlined,
        'title': 'Neon Borders',
        'desc': 'Pulsing neon outline effects',
        'color': const Color(0xFF00E5FF),
      },
      {
        'icon': Icons.line_style_outlined,
        'title': 'Scan Lines',
        'desc': 'Animated scanning effects',
        'color': const Color(0xFF64FFDA),
      },
      {
        'icon': Icons.flash_on_outlined,
        'title': 'Glitch Effect',
        'desc': 'Text glitch on interaction',
        'color': const Color(0xFFFF6B35),
      },
      {
        'icon': Icons.minimize_outlined,
        'title': 'Minimal Design',
        'desc': 'Clean cyberpunk aesthetic',
        'color': const Color(0xFFFFD700),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DESIGN FEATURES',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 20),
        ...features.map(
          (feature) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                color: (feature['color'] as Color).withOpacity(0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: (feature['color'] as Color).withOpacity(0.5),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    feature['icon'] as IconData,
                    color: feature['color'] as Color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feature['title'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        feature['desc'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showCardDetails(BuildContext context, Map<String, dynamic> cardData) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF00E5FF).withOpacity(0.5),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFF000000),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NeonOutlineCard(
                title: cardData['title'],
                icon: cardData['icon'],
                rarity: cardData['rarity'],
                xpValue: cardData['xp'],
                progressValue: cardData['progress'],
                progressType: cardData['progressType'],
                width: 250,
                height: 350,
              ),
              const SizedBox(height: 24),
              Text(
                'NEON OUTLINE CARD',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Minimalist cyberpunk design with neon effects and clean typography.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: const Color(0xFF00E5FF), width: 1),
                  foregroundColor: const Color(0xFF00E5FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text('CLOSE'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
