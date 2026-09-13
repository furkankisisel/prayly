import 'package:flutter/material.dart';
import '../shared/widgets/collection_card_widget.dart';
import 'shared/widgets/card_rarity.dart';
import 'shared/widgets/pixel/pixel_app_bar.dart';

void main() {
  runApp(const CollectionCardDemoApp());
}

class CollectionCardDemoApp extends StatelessWidget {
  const CollectionCardDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Collection Card Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      ),
      home: const CollectionCardDemo(),
    );
  }
}

class CollectionCardDemo extends StatelessWidget {
  const CollectionCardDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PixelAppBar(title: 'KOLEKSİYON KART TASARIMI'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A1A), Color(0xFF2D2D2D), Color(0xFF1A1A1A)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rarity Seviyeleri',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Rarity grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.65,
                ),
                itemCount: _demoCards.length,
                itemBuilder: (context, index) {
                  final card = _demoCards[index];
                  return CollectionCard(
                    title: card['title'],
                    icon: card['icon'],
                    rarity: card['rarity'],
                    xpValue: card['xp'],
                    progressValue: card['progress'],
                    progressType: card['type'],
                    onTap: () => _showCardDetail(context, card),
                  );
                },
              ),

              const SizedBox(height: 40),

              const Text(
                'Özellikler',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              _buildFeatureCard(
                'Glassmorphism Efekti',
                'Cam görünümü ve holografik parıltılar',
                Icons.auto_awesome,
              ),
              _buildFeatureCard(
                'Rarity Sistemi',
                '7 farklı nadir lik seviyesi (Tunç - Sidre)',
                Icons.star,
              ),
              _buildFeatureCard(
                'İslami Motifler',
                'Minimal geometrik desenler',
                Icons.architecture,
              ),
              _buildFeatureCard(
                'Animasyonlar',
                'Shimmer ve pulse efektleri',
                Icons.animation,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(String title, String description, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue[300], size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void _showCardDetail(BuildContext context, Map<String, dynamic> card) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF2D2D2D),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                card['title'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Icon(card['icon'], size: 48, color: Colors.white70),
              const SizedBox(height: 16),
              Builder(
                builder: (context) => Text(
                  'Rarity: ${card['rarity'].displayName(context)}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'XP: ${card['xp']} • ${card['type']}: ${card['progress']}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Kapat'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static final List<Map<String, dynamic>> _demoCards = [
    {
      'title': 'Aralıksız Cemaat Serisi',
      'icon': Icons.mosque,
      'rarity': CardRarity.bronze,
      'xp': 50,
      'progress': 7,
      'type': 'streak',
    },
    {
      'title': 'Sabah Namazı Ustası',
      'icon': Icons.wb_sunny,
      'rarity': CardRarity.silver,
      'xp': 120,
      'progress': 30,
      'type': 'total',
    },
    {
      'title': 'Cuma Namazı Şampiyonu',
      'icon': Icons.calendar_today,
      'rarity': CardRarity.gold,
      'xp': 250,
      'progress': 52,
      'type': 'total',
    },
    {
      'title': 'Kandil Gecesi Kahramanı',
      'icon': Icons.nightlight,
      'rarity': CardRarity.platinum,
      'xp': 500,
      'progress': 12,
      'type': 'streak',
    },
    {
      'title': 'Namaz Mükemmeliyeti',
      'icon': Icons.favorite,
      'rarity': CardRarity.diamond,
      'xp': 1000,
      'progress': 365,
      'type': 'total',
    },
    {
      'title': 'Nur-u İlahi',
      'icon': Icons.auto_awesome,
      'rarity': CardRarity.nur,
      'xp': 2500,
      'progress': 100,
      'type': 'streak',
    },
    {
      'title': 'Sidretü\'l-Müntehâ',
      'icon': Icons.stars,
      'rarity': CardRarity.sidre,
      'xp': 10000,
      'progress': 1000,
      'type': 'total',
    },
  ];
}
