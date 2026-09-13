import 'package:flutter/material.dart';
import 'shared/widgets/floating_glass_card.dart';
import 'shared/widgets/card_rarity.dart';

void main() {
  runApp(const FloatingGlassDemoApp());
}

class FloatingGlassDemoApp extends StatelessWidget {
  const FloatingGlassDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Floating Glass Demo',
      theme: ThemeData.dark(useMaterial3: true),
      home: const FloatingGlassDemoPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FloatingGlassDemoPage extends StatelessWidget {
  const FloatingGlassDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.5,
            colors: [Color(0xFF1A1F36), Color(0xFF0D1117), Color(0xFF000000)],
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
          'Floating Glass Cards',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Minimal glassmorphism with floating effects',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.7),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 60,
          height: 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: const LinearGradient(
              colors: [Color(0xFF00D4FF), Color(0xFF5B73FF)],
            ),
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
        return FloatingGlassCard(
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
        'title': 'Sabah Namazı',
        'icon': Icons.wb_sunny_outlined,
        'rarity': CardRarity.gold,
        'xp': 250,
        'progress': 85,
        'progressType': 'streak',
      },
      {
        'title': 'Kuran Tilaveti',
        'icon': Icons.menu_book_outlined,
        'rarity': CardRarity.diamond,
        'xp': 180,
        'progress': 65,
        'progressType': 'daily',
      },
      {
        'title': 'Tesbih Çekme',
        'icon': Icons.self_improvement_outlined,
        'rarity': CardRarity.platinum,
        'xp': 120,
        'progress': 92,
        'progressType': 'streak',
      },
      {
        'title': 'Dua Koleksiyonu',
        'icon': Icons.favorite_outline,
        'rarity': CardRarity.nur,
        'xp': 300,
        'progress': 78,
        'progressType': 'total',
      },
      {
        'title': 'Gece İbadeti',
        'icon': Icons.nights_stay_outlined,
        'rarity': CardRarity.silver,
        'xp': 150,
        'progress': 45,
        'progressType': 'daily',
      },
      {
        'title': 'Özel Hatim',
        'icon': Icons.auto_awesome_outlined,
        'rarity': CardRarity.sidre,
        'xp': 500,
        'progress': 100,
        'progressType': 'mastery',
      },
    ];
  }

  Widget _buildFeaturesInfo() {
    final features = [
      {
        'icon': Icons.water_drop_outlined,
        'title': 'Glassmorphism',
        'desc': 'Şeffaf cam efektleri ile modern görünüm',
        'color': const Color(0xFF00D4FF),
      },
      {
        'icon': Icons.bubble_chart_outlined,
        'title': 'Floating Animation',
        'desc': 'Yumuşak yüzen hareket animasyonları',
        'color': const Color(0xFF5B73FF),
      },
      {
        'icon': Icons.blur_on_outlined,
        'title': 'Backdrop Blur',
        'desc': 'Arka plan bulanıklık efektleri',
        'color': const Color(0xFF8B5FBF),
      },
      {
        'icon': Icons.auto_fix_high_outlined,
        'title': 'Dynamic Glow',
        'desc': 'Dinamik ışık ve parlaklık efektleri',
        'color': const Color(0xFF00BFA5),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tasarım Özellikleri',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        ...features.map(
          (feature) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.08),
                  Colors.white.withOpacity(0.04),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        (feature['color'] as Color).withOpacity(0.3),
                        (feature['color'] as Color).withOpacity(0.1),
                      ],
                    ),
                    border: Border.all(
                      color: (feature['color'] as Color).withOpacity(0.5),
                      width: 1,
                    ),
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
                          color: Colors.white.withOpacity(0.7),
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
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingGlassCard(
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
                'Floating Glass Card',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Modern glassmorphism tasarımı ile yumuşak animasyonlar. Minimal ama etkileyici görsel deneyim.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                ),
                child: const Text('Kapat'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
