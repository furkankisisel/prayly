import 'package:flutter/material.dart';
import 'shared/widgets/modern_collection_card.dart';
import 'shared/widgets/card_rarity.dart';
import 'shared/widgets/pixel/pixel_app_bar.dart';

void main() {
  runApp(const ModernCardDemoApp());
}

class ModernCardDemoApp extends StatelessWidget {
  const ModernCardDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modern Card Demo',
      theme: ThemeData.dark(useMaterial3: true),
      home: const ModernCardDemoPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ModernCardDemoPage extends StatelessWidget {
  const ModernCardDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: const PixelAppBar(title: 'MODERN KOLEKSİYON KARTLARI'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Futuristik Tasarım Konsepti',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  shadows: [
                    Shadow(color: Colors.cyan.withOpacity(0.5), blurRadius: 10),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Neon efektleri, orbital animasyonlar ve cyberpunk estetiği',
                style: TextStyle(fontSize: 16, color: Colors.grey[400]),
              ),
              const SizedBox(height: 30),

              // Kart grid'i
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.65,
                ),
                itemCount: _getCardData().length,
                itemBuilder: (context, index) {
                  final cardData = _getCardData()[index];
                  return ModernCollectionCard(
                    title: cardData['title'],
                    icon: cardData['icon'],
                    rarity: cardData['rarity'],
                    xpValue: cardData['xp'],
                    progressValue: cardData['progress'],
                    progressType: cardData['progressType'],
                    onTap: () => _showCardDetails(context, cardData),
                  );
                },
              ),

              const SizedBox(height: 40),

              // Özellikler
              _buildFeaturesList(),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getCardData() {
    return [
      {
        'title': 'Sabah Namazı',
        'icon': Icons.wb_sunny,
        'rarity': CardRarity.gold,
        'xp': 250,
        'progress': 85,
        'progressType': 'streak',
      },
      {
        'title': 'Kuran Okuma',
        'icon': Icons.menu_book,
        'rarity': CardRarity.diamond,
        'xp': 180,
        'progress': 65,
        'progressType': 'daily',
      },
      {
        'title': 'Zikir Saati',
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
        'progressType': 'collection',
      },
      {
        'title': 'Akşam İbadeti',
        'icon': Icons.nightlight,
        'rarity': CardRarity.silver,
        'xp': 150,
        'progress': 45,
        'progressType': 'daily',
      },
      {
        'title': 'Özel Sûre',
        'icon': Icons.auto_awesome,
        'rarity': CardRarity.sidre,
        'xp': 500,
        'progress': 100,
        'progressType': 'mastery',
      },
    ];
  }

  Widget _buildFeaturesList() {
    final features = [
      {
        'icon': Icons.blur_circular,
        'title': 'Orbital Animasyonlar',
        'desc': 'Dönen halka efektleri',
      },
      {
        'icon': Icons.lightbulb,
        'title': 'Neon Aydınlatma',
        'desc': 'Dinamik parlaklık sistemleri',
      },
      {
        'icon': Icons.category,
        'title': 'Hexagon Rarity',
        'desc': 'Geometrik nadir seviye göstergesi',
      },
      {
        'icon': Icons.grain,
        'title': 'Floating Particles',
        'desc': 'Hareket eden parçacık efektleri',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tasarım Özellikleri',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ...features.map(
          (feature) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.cyan.withOpacity(0.2), width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.cyan.withOpacity(0.3),
                        Colors.blue.withOpacity(0.3),
                      ],
                    ),
                  ),
                  child: Icon(
                    feature['icon'] as IconData,
                    color: Colors.cyan,
                    size: 20,
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
                      Text(
                        feature['desc'] as String,
                        style: TextStyle(fontSize: 14, color: Colors.grey[400]),
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
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.cyan.withOpacity(0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.cyan.withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ModernCollectionCard(
                title: cardData['title'],
                icon: cardData['icon'],
                rarity: cardData['rarity'],
                xpValue: cardData['xp'],
                progressValue: cardData['progress'],
                progressType: cardData['progressType'],
                width: 250,
                height: 350,
              ),
              const SizedBox(height: 20),
              Text(
                'Cyberpunk Koleksiyon Kartı',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Futuristik tasarım dili ile geliştirilmiş modern koleksiyon kartı. Neon efektleri ve orbital animasyonlarla desteklenmiştir.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan.withOpacity(0.2),
                  foregroundColor: Colors.cyan,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.cyan.withOpacity(0.5)),
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
