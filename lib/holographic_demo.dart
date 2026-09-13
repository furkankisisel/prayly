import 'package:flutter/material.dart';
import 'shared/widgets/holographic_card.dart';
import 'shared/widgets/card_rarity.dart';

void main() {
  runApp(const HolographicDemoApp());
}

class HolographicDemoApp extends StatelessWidget {
  const HolographicDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Holographic Demo',
      theme: ThemeData.dark(useMaterial3: true),
      home: const HolographicDemoPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HolographicDemoPage extends StatelessWidget {
  const HolographicDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F1419),
              Color(0xFF000000),
            ],
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
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [
                Color(0xFFFF6B6B),
                Color(0xFFFFE66D),
                Color(0xFF4ECDC4),
                Color(0xFF45B7D1),
                Color(0xFF9B59B6),
              ],
            ).createShader(bounds);
          },
          child: const Text(
            'Holographic Cards',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Rainbow gradients with dynamic holographic effects',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.7),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: 100,
          height: 4,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFF6B6B),
                Color(0xFFFFE66D),
                Color(0xFF4ECDC4),
                Color(0xFF45B7D1),
              ],
            ),
            borderRadius: BorderRadius.all(Radius.circular(2)),
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
        return HolographicCard(
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
        'title': 'Sabah Duası',
        'icon': Icons.wb_sunny,
        'rarity': CardRarity.gold,
        'xp': 250,
        'progress': 85,
        'progressType': 'streak',
      },
      {
        'title': 'Kuran Hatmi',
        'icon': Icons.menu_book,
        'rarity': CardRarity.diamond,
        'xp': 180,
        'progress': 65,
        'progressType': 'daily',
      },
      {
        'title': 'Meditasyon',
        'icon': Icons.self_improvement,
        'rarity': CardRarity.platinum,
        'xp': 120,
        'progress': 92,
        'progressType': 'streak',
      },
      {
        'title': 'Dua Koleksiyonu',
        'icon': Icons.favorite,
        'rarity': CardRarity.nur,
        'xp': 300,
        'progress': 78,
        'progressType': 'total',
      },
      {
        'title': 'Gece İbadeti',
        'icon': Icons.nightlight,
        'rarity': CardRarity.silver,
        'xp': 150,
        'progress': 45,
        'progressType': 'daily',
      },
      {
        'title': 'Özel Seviye',
        'icon': Icons.auto_awesome,
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
        'icon': Icons.gradient,
        'title': 'Rainbow Gradients',
        'desc': 'Dinamik renk geçişleri ve holografik efektler',
        'color': const Color(0xFFFF6B6B),
      },
      {
        'icon': Icons.auto_fix_high,
        'title': 'Animated Sparkles',
        'desc': 'Parıldayan parçacık animasyonları',
        'color': const Color(0xFFFFE66D),
      },
      {
        'icon': Icons.waves,
        'title': 'Wave Effects',
        'desc': 'Dalga görsel efektleri',
        'color': const Color(0xFF4ECDC4),
      },
      {
        'icon': Icons.palette,
        'title': 'Colorful Design',
        'desc': 'Renkli ve canlı tasarım dili',
        'color': const Color(0xFF9B59B6),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
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
                  (feature['color'] as Color).withOpacity(0.1),
                  (feature['color'] as Color).withOpacity(0.05),
                  Colors.transparent,
                ],
              ),
              border: Border.all(
                color: (feature['color'] as Color).withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: (feature['color'] as Color).withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
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
                        (feature['color'] as Color).withOpacity(0.4),
                        (feature['color'] as Color).withOpacity(0.1),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (feature['color'] as Color).withOpacity(0.5),
                        blurRadius: 10,
                      ),
                    ],
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
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F1419)],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HolographicCard(
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
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: [
                      Color(0xFFFF6B6B),
                      Color(0xFFFFE66D),
                      Color(0xFF4ECDC4),
                    ],
                  ).createShader(bounds);
                },
                child: const Text(
                  'Holographic Card',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Renkli holografik tasarım ile dinamik gradyan efektleri. Canlı renk paleti ile modern görünüm.',
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
                  backgroundColor: const Color(0xFF4ECDC4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 10,
                  shadowColor: const Color(0xFF4ECDC4),
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
