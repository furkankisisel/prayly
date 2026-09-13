import 'package:flutter/material.dart';
import 'shared/widgets/pixel_card.dart';
import 'shared/widgets/pixel/pixel_app_bar.dart';

void main() {
  runApp(const PixelCardDemoApp());
}

class PixelCardDemoApp extends StatelessWidget {
  const PixelCardDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixel Card Demo',
      theme: ThemeData.dark(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const PixelCardDemoPage(),
    );
  }
}

class PixelCardDemoPage extends StatefulWidget {
  const PixelCardDemoPage({super.key});

  @override
  State<PixelCardDemoPage> createState() => _PixelCardDemoPageState();
}

class _PixelCardDemoPageState extends State<PixelCardDemoPage> {
  PixelRarity _selectedRarity = PixelRarity.pro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: const PixelAppBar(title: '8-BIT COLLECTIBLE CARDS'),
      body: Column(
        children: [
          // Rarity selector
          _buildRaritySelector(),

          // Cards grid
          Expanded(child: _buildCardsGrid()),

          // Footer info
          _buildFooterInfo(),
        ],
      ),
    );
  }

  Widget _buildRaritySelector() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF333333), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'RARITY LEVEL:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: PixelRarity.values.map((rarity) {
              final isSelected = rarity == _selectedRarity;
              final colors = _getRarityChipColors(rarity);

              return GestureDetector(
                onTap: () => setState(() => _selectedRarity = rarity),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.background
                        : const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      color: colors.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    rarity.displayName(context).toUpperCase(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[400],
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCardsGrid() {
    final cards = [
      {'title': 'Aralıksız Cemaat', 'icon': Icons.temple_buddhist},
      {'title': 'Kandil Feneri', 'icon': Icons.lightbulb},
      {'title': 'Dua Eden Eller', 'icon': Icons.pan_tool},
      {'title': 'Kıble Pusulası', 'icon': Icons.explore},
      {'title': 'İlk Namaz', 'icon': Icons.star},
      {'title': 'Cuma Namazı', 'icon': Icons.calendar_today},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        return PixelCard(
          title: card['title'] as String,
          icon: card['icon'] as IconData,
          rarity: _selectedRarity,
          xpValue: _getRandomXP(),
          progressValue: _getRandomProgress(),
          progressType: index % 2 == 0 ? 'streak' : 'total',
          onTap: () => _showCardDetail(card),
        );
      },
    );
  }

  Widget _buildFooterInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border(top: BorderSide(color: Color(0xFF333333), width: 2)),
      ),
      child: Column(
        children: [
          const Text(
            'RETRO COLLECTIBLE CARDS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '8-bit pixel art • Islamic themes • Six rarity levels',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 10,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  int _getRandomXP() {
    final base = [50, 100, 150, 250, 350, 500];
    return base[_selectedRarity.index];
  }

  int _getRandomProgress() {
    return 45 + (_selectedRarity.index * 10);
  }

  RarityChipColors _getRarityChipColors(PixelRarity rarity) {
    switch (rarity) {
      case PixelRarity.siradan:
        return RarityChipColors(
          background: const Color(0xFF8B4513),
          border: const Color(0xFFCD853F),
        );
      case PixelRarity.nadir:
        return RarityChipColors(
          background: const Color(0xFF708090),
          border: const Color(0xFFC0C0C0),
        );
      case PixelRarity.pro:
        return RarityChipColors(
          background: const Color(0xFFB8860B),
          border: const Color(0xFFFFD700),
        );
      case PixelRarity.gizemli:
        return RarityChipColors(
          background: const Color(0xFF1E3A8A),
          border: const Color(0xFF3B82F6),
        );
      case PixelRarity.efsane:
        return RarityChipColors(
          background: const Color(0xFF7C3AED),
          border: const Color(0xFFA855F7),
        );
      case PixelRarity.epik:
        return RarityChipColors(
          background: const Color(0xFFDC2626),
          border: const Color(0xFFEF4444),
        );
    }
  }

  void _showCardDetail(Map<String, dynamic> card) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF0F0F0F),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFF333333), width: 3),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PixelCard(
                title: card['title'] as String,
                icon: card['icon'] as IconData,
                rarity: _selectedRarity,
                xpValue: _getRandomXP(),
                progressValue: _getRandomProgress(),
                progressType: 'streak',
                width: 250,
                height: 350,
              ),
              const SizedBox(height: 16),
              const Text(
                '8-BIT COLLECTIBLE CARD',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Retro pixel art trading card with Islamic themes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF333333),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                child: const Text(
                  'CLOSE',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RarityChipColors {
  final Color background;
  final Color border;

  RarityChipColors({required this.background, required this.border});
}
