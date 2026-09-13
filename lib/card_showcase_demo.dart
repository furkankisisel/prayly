import 'package:flutter/material.dart';
import 'shared/widgets/modern_collection_card.dart';
import 'shared/widgets/floating_glass_card.dart';
import 'shared/widgets/neon_outline_card.dart';
import 'shared/widgets/holographic_card.dart';
import 'shared/widgets/pixel_card.dart';
import 'shared/widgets/card_rarity.dart';
import 'shared/widgets/pixel/pixel_app_bar.dart';

enum CardStyle { modern, glass, neon, holo, pixel }

class CardShowcaseDemoApp extends StatelessWidget {
  const CardShowcaseDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Showcase',
      theme: ThemeData.dark(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const CardShowcasePage(),
    );
  }
}

class CardShowcasePage extends StatefulWidget {
  const CardShowcasePage({super.key});

  @override
  State<CardShowcasePage> createState() => _CardShowcasePageState();
}

class _CardShowcasePageState extends State<CardShowcasePage> {
  CardStyle _style = CardStyle.modern;
  CardRarity _rarity = CardRarity.gold;

  final _cards = const [
    {'title': 'Aralıksız Cemaat Serisi', 'icon': Icons.temple_buddhist},
    {'title': 'Kandil Feneri', 'icon': Icons.light_mode},
    {'title': 'Dua Eden Eller', 'icon': Icons.pan_tool_alt},
    {'title': 'Kıble Pusulası', 'icon': Icons.explore},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PixelAppBar(
        title: 'KOLEKSİYON KARTLARI — SHOWCASE',
        actions: [
          IconButton(
            tooltip: 'Tema',
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildControls(),
          const Divider(height: 1),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.65,
              ),
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                final c = _cards[index];
                return _buildCard(
                  title: c['title'] as String,
                  icon: c['icon'] as IconData,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Style chooser
          Expanded(
            child: SegmentedButton<CardStyle>(
              segments: const [
                ButtonSegment(value: CardStyle.modern, label: Text('Modern')),
                ButtonSegment(value: CardStyle.glass, label: Text('Glass')),
                ButtonSegment(value: CardStyle.neon, label: Text('Neon')),
                ButtonSegment(value: CardStyle.holo, label: Text('Holo')),
                ButtonSegment(value: CardStyle.pixel, label: Text('Pixel')),
              ],
              selected: {_style},
              onSelectionChanged: (s) => setState(() => _style = s.first),
            ),
          ),
          const SizedBox(width: 12),
          // Rarity chooser
          DropdownButton<CardRarity>(
            value: _rarity,
            onChanged: (v) => setState(() => _rarity = v!),
            items: CardRarity.values
                .map(
                  (r) => DropdownMenuItem(
                    value: r,
                    child: Text(r.displayName(context)),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required IconData icon}) {
    switch (_style) {
      case CardStyle.modern:
        return ModernCollectionCard(
          title: title,
          icon: icon,
          rarity: _rarity,
          xpValue: 250,
          progressValue: 80,
          progressType: 'streak',
        );
      case CardStyle.glass:
        return FloatingGlassCard(
          title: title,
          icon: icon,
          rarity: _rarity,
          xpValue: 250,
          progressValue: 80,
          progressType: 'streak',
        );
      case CardStyle.neon:
        return NeonOutlineCard(
          title: title,
          icon: icon,
          rarity: _rarity,
          xpValue: 250,
          progressValue: 80,
          progressType: 'streak',
        );
      case CardStyle.holo:
        return HolographicCard(
          title: title,
          icon: icon,
          rarity: _rarity,
          xpValue: 250,
          progressValue: 80,
          progressType: 'streak',
        );
      case CardStyle.pixel:
        return PixelCard(
          title: title,
          icon: icon,
          rarity: _mapToPixelRarity(_rarity),
          xpValue: 250,
          progressValue: 80,
          progressType: 'streak',
        );
    }
  }

  PixelRarity _mapToPixelRarity(CardRarity rarity) {
    switch (rarity) {
      case CardRarity.bronze:
        return PixelRarity.siradan;
      case CardRarity.silver:
        return PixelRarity.nadir;
      case CardRarity.gold:
        return PixelRarity.pro;
      case CardRarity.platinum:
        return PixelRarity.gizemli;
      case CardRarity.diamond:
        return PixelRarity.efsane;
      case CardRarity.nur:
        return PixelRarity.epik;
      case CardRarity.sidre:
        return PixelRarity.epik;
    }
  }
}
