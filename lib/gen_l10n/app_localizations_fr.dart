// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get navigationPrayerTimes => 'Times';

  @override
  String get searchHintCityCountry => 'Şehir, Ülke';

  @override
  String get navigationTracker => 'Tracker';

  @override
  String get navigationQibla => 'Qibla';

  @override
  String get navigationLevel => 'Level';

  @override
  String get navigationProfile => 'Profile';

  @override
  String get screenTitlePrayerTimes => 'Horaires de Prière';

  @override
  String get screenTitlePrayerTracker => 'Prayer Tracker';

  @override
  String get screenTitleQiblaCompass => 'Boussole Qibla';

  @override
  String get screenTitleLevel => 'Mon Niveau';

  @override
  String get screenTitleProfile => 'Profil';

  @override
  String get screenTitleNotificationSettings => 'Notification Settings';

  @override
  String get screenTitleSplash => 'Prayly';

  @override
  String get prayerTimesRemainingTime => 'TEMPS RESTANT';

  @override
  String get prayerTimesLocation => 'Emplacement';

  @override
  String get prayerTimesAutomatic => 'AUTOMATIQUE';

  @override
  String get prayerTimesHide => 'MASQUER';

  @override
  String get prayerTimesCity => 'VILLE';

  @override
  String get prayerTimesLoading => 'Chargement';

  @override
  String get prayerTimesNoResults => 'Aucun résultat trouvé';

  @override
  String prayerTimesError(String error) {
    return 'Erreur : $error';
  }

  @override
  String prayerTimesLocationText(String city, String country) {
    return 'Emplacement : $city, $country';
  }

  @override
  String get prayerTimesLocationGPS => 'Emplacement : GPS de l\'appareil';

  @override
  String get prayerFajr => 'Fajr';

  @override
  String get prayerMorning => 'Aube';

  @override
  String get prayerSunrise => 'Lever du soleil';

  @override
  String get prayerDhuhr => 'Dhuhr';

  @override
  String get prayerAsr => 'Asr';

  @override
  String get prayerMaghrib => 'Maghrib';

  @override
  String get prayerIsha => 'Isha';

  @override
  String get trackerSelectDate => 'Sélectionner la date';

  @override
  String get trackerCancel => 'Annuler';

  @override
  String get trackerSelect => 'Sélectionner';

  @override
  String get trackerToday => 'Aujourd\'hui';

  @override
  String get trackerYesterday => 'Hier';

  @override
  String get trackerHint => 'Appuyez sur une prière pour la suivre en détail';

  @override
  String trackerCompleted(int completed, int total) {
    return '$completed / $total terminées';
  }

  @override
  String get trackerDialogHint =>
      'Appuyez sur une prière pour un suivi détaillé';

  @override
  String trackerPrayerName(String prayerName) {
    return 'Prière $prayerName';
  }

  @override
  String get trackerSelectStatus => 'Sélectionner le statut :';

  @override
  String get trackerWhere => 'Où avez-vous prié ?';

  @override
  String get trackerLocationAtHome => 'À la maison';

  @override
  String get trackerLocationAtMosque => 'À la mosquée';

  @override
  String get locationAtHome => 'At home';

  @override
  String get locationAtMosque => 'At mosque';

  @override
  String get statusNotPrayed => 'Not Prayed';

  @override
  String get statusMakeup => 'Makeup';

  @override
  String get statusPrayed => 'Prayed';

  @override
  String get statusCongregation => 'Congregation';

  @override
  String get qiblaPermissionRequired =>
      'Location permission required to calculate Qibla direction';

  @override
  String get qiblaServiceDisabled =>
      'Location service is disabled. Please enable GPS/location service';

  @override
  String qiblaLocationError(String error) {
    return 'Could not get location: $error';
  }

  @override
  String get qiblaPermissionDenied =>
      'Location permission denied. Please grant permission from settings';

  @override
  String get qiblaPermissionPermanentlyDenied =>
      'Location permission permanently denied. Please grant permission from settings';

  @override
  String qiblaPermissionError(String error) {
    return 'Error getting permission: $error';
  }

  @override
  String get qiblaGrantPermission => 'Grant Permission';

  @override
  String get qiblaOpenSettings => 'Open Settings';

  @override
  String get qiblaRefresh => 'Refresh';

  @override
  String get qiblaDeviceDirection => 'Device Direction';

  @override
  String get qiblaNorth => 'North';

  @override
  String get qiblaSouth => 'South';

  @override
  String get qiblaEast => 'East';

  @override
  String get qiblaWest => 'West';

  @override
  String get qiblaPermissionPrompt =>
      'Veuillez accorder l\'autorisation de localisation';

  @override
  String get qiblaDirectionReading => 'Lecture de la direction';

  @override
  String get qiblaWaitingLocation => 'En attente de la localisation...';

  @override
  String get qiblaCompassSensorUnavailable =>
      'Capteur de boussole indisponible';

  @override
  String get qiblaPullToRefresh => 'Tirer pour actualiser';

  @override
  String get qiblaDirectionWaiting => 'En attente...';

  @override
  String get qiblaAligned => 'Aligné';

  @override
  String get qiblaTurnRight => 'Tourner à droite';

  @override
  String get qiblaTurnLeft => 'Tourner à gauche';

  @override
  String get weekdayMonday => 'Lundi';

  @override
  String get weekdayTuesday => 'Mardi';

  @override
  String get weekdayWednesday => 'Mercredi';

  @override
  String get weekdayThursday => 'Jeudi';

  @override
  String get weekdayFriday => 'Vendredi';

  @override
  String get weekdaySaturday => 'Samedi';

  @override
  String get weekdaySunday => 'Dimanche';

  @override
  String profileXpToNextLevel(int level, int xp) {
    return 'Niveau $level — $xp XP pour le suivant';
  }

  @override
  String get profileUser => 'User';

  @override
  String get profileChangeAvatar => 'Tap to change profile picture';

  @override
  String get profileThemeSettings => 'Theme Settings';

  @override
  String get profileThemeLight => 'Light';

  @override
  String get profileThemeDark => 'Dark';

  @override
  String get profileThemeAmoled => 'AMOLED';

  @override
  String get profileThemeSystem => 'System';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profileNotificationSettings => 'Notification Settings';

  @override
  String get profileClose => 'CLOSE';

  @override
  String get profileSelectFromGallery => 'Select from Gallery';

  @override
  String profileImageError(String error) {
    return 'Error selecting image: $error';
  }

  @override
  String get profileSave => 'Save';

  @override
  String get gamificationProfile => 'Profile';

  @override
  String get gamificationCards => 'Cards';

  @override
  String get gamificationStatistics => 'Statistics';

  @override
  String get statisticsTitle => 'STATISTIQUES';

  @override
  String get statisticsTabWeekly => 'HEBDOMADAIRE';

  @override
  String get statisticsTabMonthly => 'MENSUEL';

  @override
  String get statisticsTabYearly => 'ANNUEL';

  @override
  String get statisticsSquares => 'Carrés';

  @override
  String get statisticsSummary => 'Résumé';

  @override
  String get statisticsOverall => 'Répartition générale';

  @override
  String get statisticsMiniLabelDone => 'Fait';

  @override
  String get statisticsMiniLabelCongregation => 'Congrégation';

  @override
  String get statisticsMiniLabelMakeup => 'Rattrapage';

  @override
  String get statisticsMiniLabelNotPrayed => 'Non prié';

  @override
  String get statisticsLast7Days => '7 derniers jours';

  @override
  String get statisticsLast30Days => '30 derniers jours';

  @override
  String get statisticsLast365Days => '365 derniers jours';

  @override
  String get gamificationErrorLoading =>
      'Problème lors du chargement du profil';

  @override
  String get gamificationPleaseRestart => 'Veuillez redémarrer l\'application.';

  @override
  String get activeStreaks => 'Séries actives';

  @override
  String get daysUnit => 'jours';

  @override
  String cardsCollection(Object count) {
    return 'Collection de cartes ($count)';
  }

  @override
  String get cardsDistribution => 'Répartition des cartes';

  @override
  String get categoryDaily => 'Prières quotidiennes';

  @override
  String get categoryFriday => 'Prières du vendredi';

  @override
  String get categoryKandil => 'Nuits Kandil';

  @override
  String get categoryEid => 'Vacances d\'Eid';

  @override
  String get categoryMosque => 'Découverte de mosquées';

  @override
  String get categoryMilestone => 'Jalons';

  @override
  String get cardHomePrayerStreak => 'Home Prayer Streak';

  @override
  String get cardHomePrayerTotal => 'Home Prayer Total';

  @override
  String get cardQadaPrayerTotal => 'Makeup Prayer Total';

  @override
  String get cardCongregationStreak => 'Congregation Streak';

  @override
  String get cardCongregationTotal => 'Congregation Total';

  @override
  String get cardMosqueCongregationStreak => 'Mosque Congregation Streak';

  @override
  String get cardMosqueCongregationTotal => 'Mosque Congregation Total';

  @override
  String get cardFridayStreak => 'Friday Prayer Streak';

  @override
  String get cardFridayTotal => 'Friday Prayer Total';

  @override
  String get cardKandilStreak => 'Holy Night Streak';

  @override
  String get cardKandilTotal => 'Holy Night Total';

  @override
  String get cardEidStreak => 'Eid Prayer Streak';

  @override
  String get cardEidTotal => 'Eid Prayer Total';

  @override
  String get cardMosqueDiscovery => 'Mosque Explorer';

  @override
  String get cardMosqueRegular => 'Mosque Regular';

  @override
  String get cardFirstPrayer => 'First Step';

  @override
  String get cardHundredPrayers => 'Hundred Prayers';

  @override
  String get cardFiveHundredPrayers => 'Five Hundred Prayers';

  @override
  String get cardThousandPrayers => 'Thousand Prayers';

  @override
  String get cardDescHomePrayerStreak => 'Consecutive home prayers';

  @override
  String get cardDescHomePrayerTotal => 'Total home prayers performed';

  @override
  String get cardDescQadaPrayerTotal => 'Total makeup prayers';

  @override
  String get cardDescCongregationStreak => 'Consecutive congregation prayers';

  @override
  String get cardDescCongregationTotal => 'Total congregation prayers';

  @override
  String get cardDescMosqueCongregationStreak =>
      'Consecutive mosque congregation prayers';

  @override
  String get cardDescMosqueCongregationTotal =>
      'Total mosque congregation prayers';

  @override
  String get cardDescFridayStreak => 'Consecutive Friday prayers';

  @override
  String get cardDescFridayTotal => 'Total Friday prayers';

  @override
  String get cardDescKandilStreak => 'Consecutive holy night prayers';

  @override
  String get cardDescKandilTotal => 'Total holy night prayers';

  @override
  String get cardDescEidStreak => 'Consecutive Eid prayers';

  @override
  String get cardDescEidTotal => 'Total Eid prayers';

  @override
  String get cardDescMosqueDiscovery => 'Different mosques discovered';

  @override
  String get cardDescMosqueRegular => 'Consecutive prayers at same mosque';

  @override
  String get cardDescFirstPrayer => 'First prayer milestone';

  @override
  String get cardDescHundredPrayers => '100 prayers milestone (total)';

  @override
  String get cardDescFiveHundredPrayers => '500 prayers milestone (total)';

  @override
  String get cardDescThousandPrayers => '1000 prayers milestone';

  @override
  String get cardCountUnit => 'cartes';

  @override
  String get statsFailedToLoad => 'Échec du chargement des statistiques';

  @override
  String get generalStatistics => 'Statistiques générales';

  @override
  String get statTotalPrayers => 'Total des prières';

  @override
  String get statCongregationPrayers => 'Prières en congrégation';

  @override
  String get statBestStreak => 'Meilleure série';

  @override
  String get statWeeklyXp => 'XP cette semaine';

  @override
  String get detailProgress => 'Progression';

  @override
  String get detailXpContribution => 'Contribution XP';

  @override
  String get detailRarityScore => 'Score de rareté';

  @override
  String get detailNextThreshold => 'Seuil suivant';

  @override
  String get gamificationErrorRestart => 'Please restart the application';

  @override
  String get gamificationLoading => 'MY LEVEL';

  @override
  String get gamificationClose => 'Close';

  @override
  String get milestoneFirstStep => 'First Step';

  @override
  String get milestoneRegular => 'Regular';

  @override
  String get milestoneDetermined => 'Determined';

  @override
  String get milestoneDevoted => 'Devoted';

  @override
  String get milestoneFirstCongregation => 'First Congregation';

  @override
  String get milestoneCongregationLover => 'Congregation Lover';

  @override
  String get milestoneCongregationMaster => 'Congregation Master';

  @override
  String get milestoneFirstMosque => 'First Visit';

  @override
  String get milestoneMosqueExplorer => 'Mosque Explorer';

  @override
  String get milestoneRamadanWarrior => 'Ramadan Warrior';

  @override
  String get milestoneNightOwl => 'Night Owl';

  @override
  String get milestoneEarlyRiser => 'Early Riser';

  @override
  String get milestoneDescFirstPrayer => 'You recorded your first prayer';

  @override
  String get milestoneDesc10Prayers => 'You recorded 10 prayers';

  @override
  String get milestoneDesc50Prayers => 'You recorded 50 prayers';

  @override
  String get milestoneDesc100Prayers => 'You recorded 100 prayers';

  @override
  String get milestoneDescFirstCongregation =>
      'You recorded your first congregation prayer';

  @override
  String get milestoneDesc25Congregation =>
      'You recorded 25 congregation prayers';

  @override
  String get milestoneDesc100Congregation =>
      'You recorded 100 congregation prayers';

  @override
  String get milestoneDescFirstMosque => 'You recorded your first mosque visit';

  @override
  String get questComplete5Prayers => 'Complete 5 Prayers';

  @override
  String get quest3Congregation => '3 Congregations';

  @override
  String get questFridayPrayer => 'Friday Prayer';

  @override
  String get quest20Congregation => 'Congregation Week';

  @override
  String get quest7DaysStreak => '7-Day Streak';

  @override
  String get questDescComplete5 => 'Record 5 prayers today';

  @override
  String get questDesc3Congregation => 'Record 3 congregation prayers today';

  @override
  String get questDescFriday => 'Record Friday prayer this week';

  @override
  String get questDesc20Congregation =>
      'Record 20 congregation prayers this week';

  @override
  String get questDesc7Days =>
      'Record prayers for 7 consecutive days this week';

  @override
  String get notificationSelectSound => 'Select';

  @override
  String get notificationDefaultSound =>
      'Selected sound will be used as default for all notifications. You can set different sounds for each prayer.';

  @override
  String get notificationSoundPicker => 'Select Notification Sound';

  @override
  String get notificationSoundNote =>
      'Your selected sound will be used as default for all notifications';

  @override
  String get notificationSoundLabel => 'Notification Sound';

  @override
  String get notificationPerPrayerTitle => 'Per-prayer Settings';

  @override
  String get notificationPerPrayerSubtitle =>
      'You can set separate notification preferences for each prayer';

  @override
  String get notificationPerPrayerDetail =>
      'Per-prayer customization for this prayer';

  @override
  String get notificationPreMinutesLabel => 'Pre-time:';

  @override
  String get notificationPreTimeGlobal => 'Pre-time (Global)';

  @override
  String get notificationSoundGlobalPrefix => 'Global';

  @override
  String get notificationUseGlobalSoundTooltip => 'Use global setting';

  @override
  String get notificationMuteAllSubtitle =>
      'Temporarily mute all notifications';

  @override
  String get notificationInPrayerMode => 'In-Prayer Mode';

  @override
  String get notificationInPrayerModeSubtitle =>
      'Snooze notifications during prayer';

  @override
  String get notificationWomenModeInfo =>
      'Women-only mode mutes all notifications when active.';

  @override
  String notificationInPrayerDelay(Object minutes) {
    return 'In-prayer mode delays nearby notifications by $minutes minutes.';
  }

  @override
  String get notificationPreTime => 'Pre-time Notification';

  @override
  String get notificationSpecialModes => 'Special Modes';

  @override
  String get prayerLabelSuffix => 'Prayer';

  @override
  String get notificationGeneralSettings => 'General notification settings';

  @override
  String get notificationOnTime => 'On-time notification';

  @override
  String get notificationOnTimeSubtitle => 'Send notification at prayer time';

  @override
  String get notificationPreTimeSubtitle =>
      'Send notification before prayer time';

  @override
  String get notificationReturnToGlobal => 'Return to global settings';

  @override
  String get notificationGlobal => 'Global';

  @override
  String get notificationWomenModeTitle => 'Women-only mode';

  @override
  String get notificationCustomizedSettings => 'Customized settings';

  @override
  String get notificationUsingGlobalSettings => 'Using global settings';

  @override
  String get notificationBadgeCustom => 'CUSTOM';

  @override
  String get notificationCustomizeButton => 'Customize';

  @override
  String get notificationToggleOff => 'Off';

  @override
  String get notificationToggleOn => 'On';

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String get soundSystem => 'System';

  @override
  String get soundSoft1 => 'Soft 1';

  @override
  String get soundSoft2 => 'Soft 2';

  @override
  String get soundCheerful => 'Cheerful';

  @override
  String get soundQanun => 'Qanun';

  @override
  String get soundSingle => 'Single';

  @override
  String get soundAiry => 'Airy';

  @override
  String get soundTwoNote => 'Two Note';

  @override
  String get soundDesc_system => 'Device default notification sound';

  @override
  String get soundNameSystem => 'Sistem Varsayılanı';

  @override
  String get soundNameSoftBell => 'Yumuşak Zil';

  @override
  String get soundNameSoftBellAlt => 'Yumuşak Zil (Alternatif)';

  @override
  String get soundNameShortAdhan => 'Kısa Ezan';

  @override
  String get soundNameNatureBell => 'Doğa Zili';

  @override
  String get soundNameGentleChime => 'Nazik Çan';

  @override
  String get soundNameQanun => 'Qanun / Str';

  @override
  String get soundNameSingle8 => 'Tek Nota 8-bit';

  @override
  String get soundNameTwoNoteA => 'İki Nota A';

  @override
  String get soundNameTwoNoteB => 'İki Nota B';

  @override
  String get soundNameSoftMix => 'Yumuşak Karışık';

  @override
  String get soundNameWarm8bitAlt => 'Sıcak 8-bit (Alternatif)';

  @override
  String get soundNameClearSound => 'Net Uzun Ses';

  @override
  String get soundNameSystemAlarm => 'Sistem Alarmı';

  @override
  String get soundNameSystemNotification => 'Sistem Bildirimi';

  @override
  String get soundNameSystemRingtone => 'Sistem Zil Sesi';

  @override
  String get soundDesc_softBell => 'A soft and calm bell tone';

  @override
  String get soundDesc_softBellAlt => 'Soft bell (alternate version)';

  @override
  String get soundDesc_shortAdhan => 'Short adhan melody';

  @override
  String get soundDesc_natureBell => 'Bell with natural sound effects';

  @override
  String get soundDesc_gentleChime => 'A gentle melodic chime';

  @override
  String get soundDesc_qanun => 'Qanun-style melodic piece';

  @override
  String get soundDesc_single8 => 'Single note, short 8-bit style sound';

  @override
  String get soundDesc_twoNoteA => 'Two-note variation A';

  @override
  String get soundDesc_twoNoteB => 'Two-note variation B';

  @override
  String get soundDesc_softMix => 'Soft mixed sound effect';

  @override
  String get soundDesc_warm8bitAlt => 'Warm 8-bit alternative';

  @override
  String get soundDesc_clearSound => 'A clear and clean notification sound';

  @override
  String get soundDesc_systemAlarm => 'Device alarm sound';

  @override
  String get soundDesc_systemNotification => 'Device notification tone';

  @override
  String get soundDesc_systemRingtone => 'Device ringtone sound';

  @override
  String notificationTitleOnTime(String prayerName) {
    return 'Vakit: $prayerName';
  }

  @override
  String notificationBodyOnTime(String time) {
    return 'Saat $time';
  }

  @override
  String notificationTitlePre(String prayerName) {
    return 'Yaklaşıyor: $prayerName';
  }

  @override
  String notificationBodyPre(int minutes) {
    return '$minutes dk kaldı';
  }

  @override
  String get mosquePickerTitle => 'SÉLECTIONNER LA MOSQUÉE';

  @override
  String get mosquePickerSelectFromGallery => 'Sélectionner depuis la galerie';

  @override
  String get mosquePickerSaveMosque => 'Enregistrer la mosquée';

  @override
  String get mosquePickerNote =>
      '• Vos mosquées enregistrées apparaîtront dans la liste';

  @override
  String mosquePickerImageError(String error) {
    return 'Impossible de sélectionner l\'image : $error';
  }

  @override
  String get mosquePickerAddNewLabel => 'Nouvelle mosquée +';

  @override
  String get mosquePickerNoSaved => 'Aucune mosquée enregistrée pour le moment';

  @override
  String get mosquePickerAddNewTitle => 'Ajouter une nouvelle mosquée';

  @override
  String get mosquePickerOptional => '(Optionnel)';

  @override
  String mosquePickerFirstVisit(Object day, Object month, Object year) {
    return 'Première visite : $day/$month/$year';
  }

  @override
  String get mosquePickerInfoLabel => 'Info';

  @override
  String get mosquePickerNameExists => 'Une mosquée portant ce nom existe déjà';

  @override
  String get mosquePickerNameUnique =>
      '• Vous ne pouvez pas ajouter une mosquée avec le même nom';

  @override
  String get mosquePickerEnterName => 'Veuillez saisir le nom de la mosquée';

  @override
  String get mosquePickerNameLabel => 'Nom de la mosquée';

  @override
  String get mosquePickerHintExample => 'ex : Mosquée centrale';

  @override
  String statisticsError(String error) {
    return 'Error: $error';
  }

  @override
  String get statisticsToday => 'Today';

  @override
  String get statisticsWeek => 'This Week';

  @override
  String get statisticsMonth => 'This Month';

  @override
  String get statisticsAll => 'All';

  @override
  String get statisticsTotal => 'Total';

  @override
  String get statisticsCongregation => 'Congregation';

  @override
  String get statisticsMakeup => 'Makeup';

  @override
  String get statisticsMissed => 'Missed';

  @override
  String get dialogCancel => 'Cancel';

  @override
  String get dialogSave => 'Save';

  @override
  String get dialogClose => 'Close';

  @override
  String get dialogSelect => 'Select';

  @override
  String get dialogOk => 'OK';

  @override
  String get dialogYes => 'Yes';

  @override
  String get dialogNo => 'No';

  @override
  String get dialogBack => 'Retour';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get failed => 'Failed';

  @override
  String get warning => 'Warning';

  @override
  String get confirm => 'Confirm';

  @override
  String get completed => 'Completed';

  @override
  String get level => 'Level';

  @override
  String get xp => 'XP';

  @override
  String get points => 'Points';

  @override
  String get streak => 'Streak';

  @override
  String get statAbbrTotal => 'TOT';

  @override
  String get statAbbrCongregation => 'CON';

  @override
  String get statAbbrActive => 'ACT';

  @override
  String get statAbbrBest => 'BST';

  @override
  String get statAbbrMosques => 'MSQ';

  @override
  String get statAbbrCards => 'CRD';

  @override
  String get statAbbrWeekly => 'WKY';

  @override
  String get defaultUser => 'User';

  @override
  String get progressLabel => 'PROGRESS';

  @override
  String get levelAbbr => 'LEVEL';

  @override
  String get rarityBronze => 'Bronze';

  @override
  String get raritySilver => 'Silver';

  @override
  String get rarityGold => 'Gold';

  @override
  String get rarityPlatinum => 'Platinum';

  @override
  String get rarityDiamond => 'Diamond';

  @override
  String get rarityLegendary => 'Legendary';

  @override
  String get rarityMythic => 'Mythic';

  @override
  String get holidayEidAlFitr => 'Eid al-Fitr';

  @override
  String get holidayEidAlAdha => 'Eid al-Adha';

  @override
  String get holidayMawlid => 'Mawlid an-Nabi';

  @override
  String get holidayLailatAlMiraj => 'Lailat al-Miraj';

  @override
  String get holidayLailatAlBarat => 'Lailat al-Bara\'at';

  @override
  String get holidayLailatAlQadr => 'Lailat al-Qadr';

  @override
  String get holidayAshura => 'Day of Ashura';

  @override
  String get holidayArafa => 'Day of Arafah';

  @override
  String get holidayRegaib => 'Lailat ar-Raghaib';

  @override
  String get shareSuccess => '✅ Sharing successful!';

  @override
  String shareError(String error) {
    return '❌ Sharing error: $error';
  }

  @override
  String shareCompletedSeries(String series) {
    return '✅ Completed Series: $series';
  }

  @override
  String get dbSaveProfile => 'Save user profile';

  @override
  String get dbSaveCard => 'Save card';

  @override
  String get dbSaveAllCards => 'Save all cards';

  @override
  String get dbSaveStatistics => 'Save statistics';

  @override
  String get dbClose => 'Close database';

  @override
  String get debugLoadingComplete => 'Gamification: Loading complete';

  @override
  String debugProfileError(String error) {
    return 'Gamification profile loading error: $error';
  }

  @override
  String debugRepoError(String error) {
    return 'Gamification Repository: _getUserProfileFromPrefs error: $error';
  }

  @override
  String debugSaveError(String error) {
    return 'Gamification Repository: _saveUserProfileToPrefs error: $error';
  }

  @override
  String get storageDescription =>
      'Four statuses: not prayed (none), makeup, prayed, congregation.';

  @override
  String get storageCreateTable => 'prayer_records';

  @override
  String get storageDeleteOld => 'Delete records older than 30 days';

  @override
  String get storageGetRecords => 'Get records for specific date range';

  @override
  String get storageGetAllRecords => 'Get all records';

  @override
  String get storageSaveRecord => 'Save record';

  @override
  String get storageUpdateRecord => 'Update record';

  @override
  String get storageDeleteRecord => 'Delete record';

  @override
  String get demoCollectionCard => 'Collection Card Demo';

  @override
  String get demoModernCard => 'Modern Card Demo';

  @override
  String get demoFloatingGlass => 'Floating Glass Demo';

  @override
  String get demoHolographic => 'Holographic Demo';

  @override
  String get demoNeonOutline => 'Neon Outline Demo';

  @override
  String get demoPixelCard => 'Pixel Card Demo';

  @override
  String get demoPixelFrame => 'Pixel Frame Demo';

  @override
  String get demoCardShowcase => 'Card Showcase Demo';

  @override
  String get raritySiradan => 'Common';

  @override
  String get rarityNadir => 'Rare';

  @override
  String get rarityPro => 'Pro';

  @override
  String get rarityGizemli => 'Mysterious';

  @override
  String get rarityEfsane => 'Legendary';

  @override
  String get rarityEpik => 'Epic';

  @override
  String get rarityTunc => 'Bronze';

  @override
  String get rarityGumus => 'Silver';

  @override
  String get rarityAltin => 'Gold';

  @override
  String get rarityPlatin => 'Platinum';

  @override
  String get rarityElmas => 'Diamond';

  @override
  String get rarityNur => 'Divine Light';

  @override
  String get raritySidre => 'Celestial';
}
