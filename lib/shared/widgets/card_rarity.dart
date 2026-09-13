// Card rarity used by demo and card widgets.
// Provides a display name for quick demo rendering.
import 'package:flutter/material.dart';
import '../../gen_l10n/app_localizations.dart';

enum CardRarity {
  bronze,
  silver,
  gold,
  platinum,
  diamond,
  nur,
  sidre;

  String displayName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case CardRarity.bronze:
        return l10n?.rarityTunc ?? 'Tunç';
      case CardRarity.silver:
        return l10n?.rarityGumus ?? 'Gümüş';
      case CardRarity.gold:
        return l10n?.rarityAltin ?? 'Altın';
      case CardRarity.platinum:
        return l10n?.rarityPlatin ?? 'Platin';
      case CardRarity.diamond:
        return l10n?.rarityElmas ?? 'Elmas';
      case CardRarity.nur:
        return l10n?.rarityNur ?? 'Nûr';
      case CardRarity.sidre:
        return l10n?.raritySidre ?? 'Sidre';
    }
  }
}
