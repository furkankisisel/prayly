// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get navigationPrayerTimes => 'Vakit';

  @override
  String get searchHintCityCountry => 'Şehir, Ülke';

  @override
  String get navigationTracker => 'Takip';

  @override
  String get navigationQibla => 'Kıble';

  @override
  String get navigationLevel => 'Seviyem';

  @override
  String get navigationProfile => 'Profil';

  @override
  String get screenTitlePrayerTimes => 'Namaz Vakitleri';

  @override
  String get screenTitlePrayerTracker => 'Namaz Takip';

  @override
  String get screenTitleQiblaCompass => 'Kıble Pusulası';

  @override
  String get screenTitleLevel => 'Seviyem';

  @override
  String get screenTitleProfile => 'Profil';

  @override
  String get screenTitleNotificationSettings => 'Bildirim Ayarları';

  @override
  String get screenTitleSplash => 'Prayly';

  @override
  String get prayerTimesRemainingTime => 'VAKTE KALAN SÜRE';

  @override
  String get prayerTimesLocation => 'Konum';

  @override
  String get prayerTimesAutomatic => 'OTOMATİK';

  @override
  String get prayerTimesHide => 'GİZLE';

  @override
  String get prayerTimesCity => 'ŞEHİR';

  @override
  String get prayerTimesLoading => 'Yükleniyor';

  @override
  String get prayerTimesNoResults => 'Sonuç bulunamadı';

  @override
  String prayerTimesError(String error) {
    return 'Hata: $error';
  }

  @override
  String prayerTimesLocationText(String city, String country) {
    return 'Konum: $city, $country';
  }

  @override
  String get prayerTimesLocationGPS => 'Konum: Cihaz GPS';

  @override
  String get prayerFajr => 'İmsak';

  @override
  String get prayerMorning => 'Sabah';

  @override
  String get prayerSunrise => 'Güneş';

  @override
  String get prayerDhuhr => 'Öğle';

  @override
  String get prayerAsr => 'İkindi';

  @override
  String get prayerMaghrib => 'Akşam';

  @override
  String get prayerIsha => 'Yatsı';

  @override
  String get trackerSelectDate => 'Tarih Seç';

  @override
  String get trackerCancel => 'İptal';

  @override
  String get trackerSelect => 'Seç';

  @override
  String get trackerToday => 'Bugün';

  @override
  String get trackerYesterday => 'Dün';

  @override
  String get trackerHint =>
      'Namaz üzerine tıklayarak detaylı takip yapabilirsiniz';

  @override
  String trackerCompleted(int completed, int total) {
    return '$completed / $total tamamlandı';
  }

  @override
  String get trackerDialogHint =>
      'Namaz üzerine tıklayarak detaylı takip yapabilirsiniz';

  @override
  String trackerPrayerName(String prayerName) {
    return '$prayerName Namazı';
  }

  @override
  String get trackerSelectStatus => 'Durum Seçin:';

  @override
  String get trackerWhere => 'Nerede kıldınız?';

  @override
  String get trackerLocationAtHome => 'Camide değil';

  @override
  String get trackerLocationAtMosque => 'Camide';

  @override
  String get locationAtHome => 'Camide değil';

  @override
  String get locationAtMosque => 'Camide';

  @override
  String get statusNotPrayed => 'Kılmadı';

  @override
  String get statusMakeup => 'Kaza';

  @override
  String get statusPrayed => 'Kıldı';

  @override
  String get statusCongregation => 'Cemaat';

  @override
  String get qiblaPermissionRequired =>
      'Kıble yönünü hesaplamak için konum izni gerekli';

  @override
  String get qiblaServiceDisabled =>
      'Konum servisi kapalı. Lütfen GPS/konum hizmetini açın';

  @override
  String qiblaLocationError(String error) {
    return 'Lokasyon alınamadı: $error';
  }

  @override
  String get qiblaPermissionDenied =>
      'Konum izni reddedildi. Lütfen ayarlardan izin verin';

  @override
  String get qiblaPermissionPermanentlyDenied =>
      'Konum izni kalıcı olarak reddedildi. Lütfen ayarlardan izin verin';

  @override
  String qiblaPermissionError(String error) {
    return 'İzin alınırken hata: $error';
  }

  @override
  String get qiblaGrantPermission => 'İzin Ver';

  @override
  String get qiblaOpenSettings => 'Ayarları Aç';

  @override
  String get qiblaRefresh => 'Yenile';

  @override
  String get qiblaDeviceDirection => 'Cihaz Yönü';

  @override
  String get qiblaNorth => 'Kuzey';

  @override
  String get qiblaSouth => 'Güney';

  @override
  String get qiblaEast => 'Doğu';

  @override
  String get qiblaWest => 'Batı';

  @override
  String get qiblaPermissionPrompt => 'Lütfen konum izni verin';

  @override
  String get qiblaDirectionReading => 'Yön Okuması';

  @override
  String get qiblaWaitingLocation => 'Lokasyon bekleniyor...';

  @override
  String get qiblaCompassSensorUnavailable => 'Pusula sensörü kullanılamıyor';

  @override
  String get qiblaPullToRefresh => 'Yenilemek için çekin';

  @override
  String get qiblaDirectionWaiting => 'Bekleniyor...';

  @override
  String get qiblaAligned => 'Hizalı';

  @override
  String get qiblaTurnRight => 'Sağa dön';

  @override
  String get qiblaTurnLeft => 'Sola dön';

  @override
  String get weekdayMonday => 'Pazartesi';

  @override
  String get weekdayTuesday => 'Salı';

  @override
  String get weekdayWednesday => 'Çarşamba';

  @override
  String get weekdayThursday => 'Perşembe';

  @override
  String get weekdayFriday => 'Cuma';

  @override
  String get weekdaySaturday => 'Cumartesi';

  @override
  String get weekdaySunday => 'Pazar';

  @override
  String profileXpToNextLevel(int level, int xp) {
    return 'Seviye $level — $xp XP sonraki seviyeye';
  }

  @override
  String get profileUser => 'Kullanıcı';

  @override
  String get profileChangeAvatar => 'Profil resmini değiştirmek için dokunun';

  @override
  String get profileThemeSettings => 'Tema Ayarları';

  @override
  String get profileThemeLight => 'Açık';

  @override
  String get profileThemeDark => 'Koyu';

  @override
  String get profileThemeAmoled => 'AMOLED';

  @override
  String get profileThemeSystem => 'Sistem';

  @override
  String get profileNotifications => 'Bildirimler';

  @override
  String get profileNotificationSettings => 'Bildirim Ayarları';

  @override
  String get profileClose => 'KAPAT';

  @override
  String get profileSelectFromGallery => 'Galeriden Seç';

  @override
  String profileImageError(String error) {
    return 'Resim seçilirken hata oluştu: $error';
  }

  @override
  String get profileSave => 'Kaydet';

  @override
  String get gamificationProfile => 'Profil';

  @override
  String get gamificationCards => 'Kartlar';

  @override
  String get gamificationStatistics => 'İstatistik';

  @override
  String get statisticsTitle => 'İSTATİSTİKLER';

  @override
  String get statisticsTabWeekly => 'HAFTALIK';

  @override
  String get statisticsTabMonthly => 'AYLIK';

  @override
  String get statisticsTabYearly => 'YILLIK';

  @override
  String get statisticsSquares => 'Kareler';

  @override
  String get statisticsSummary => 'Özet';

  @override
  String get statisticsOverall => 'Genel Dağılım';

  @override
  String get statisticsMiniLabelDone => 'Kıldı';

  @override
  String get statisticsMiniLabelCongregation => 'Cemaat';

  @override
  String get statisticsMiniLabelMakeup => 'Kaza';

  @override
  String get statisticsMiniLabelNotPrayed => 'Kılınmadı';

  @override
  String get statisticsLast7Days => 'Son 7 Gün';

  @override
  String get statisticsLast30Days => 'Son 30 Gün';

  @override
  String get statisticsLast365Days => 'Son 365 Gün';

  @override
  String get gamificationErrorLoading => 'Profil yüklenirken bir sorun oluştu';

  @override
  String get gamificationPleaseRestart => 'Lütfen uygulamayı yeniden başlatın.';

  @override
  String get activeStreaks => 'Aktif Seriler';

  @override
  String get daysUnit => 'gün';

  @override
  String cardsCollection(Object count) {
    return 'Kart Koleksiyonu ($count)';
  }

  @override
  String get cardsDistribution => 'Kart Dağılımı';

  @override
  String get categoryDaily => 'Günlük Namazlar';

  @override
  String get categoryFriday => 'Cuma Namazları';

  @override
  String get categoryKandil => 'Kandil Geceleri';

  @override
  String get categoryEid => 'Bayramlar';

  @override
  String get categoryMosque => 'Cami Keşfi';

  @override
  String get categoryMilestone => 'Milestone\'lar';

  @override
  String get cardHomePrayerStreak => 'Evde Namaz Serisi';

  @override
  String get cardHomePrayerTotal => 'Evde Namaz Toplamı';

  @override
  String get cardQadaPrayerTotal => 'Kaza Toplamı';

  @override
  String get cardCongregationStreak => 'Cemaat Serisi';

  @override
  String get cardCongregationTotal => 'Cemaat Toplamı';

  @override
  String get cardMosqueCongregationStreak => 'Camide Cemaat Serisi';

  @override
  String get cardMosqueCongregationTotal => 'Camide Cemaat Toplamı';

  @override
  String get cardFridayStreak => 'Cuma Serisi';

  @override
  String get cardFridayTotal => 'Cuma Toplamı';

  @override
  String get cardKandilStreak => 'Kandil Serisi';

  @override
  String get cardKandilTotal => 'Kandil Toplamı';

  @override
  String get cardEidStreak => 'Bayram Serisi';

  @override
  String get cardEidTotal => 'Bayram Toplamı';

  @override
  String get cardMosqueDiscovery => 'Cami Kaşifi';

  @override
  String get cardMosqueRegular => 'Cami Müdavimi';

  @override
  String get cardFirstPrayer => 'İlk Adım';

  @override
  String get cardHundredPrayers => 'Yüz Namaz';

  @override
  String get cardFiveHundredPrayers => 'Beş Yüz Namaz';

  @override
  String get cardThousandPrayers => 'Bin Namaz';

  @override
  String get cardDescHomePrayerStreak => 'Aralıksız evde namaz';

  @override
  String get cardDescHomePrayerTotal => 'Toplam evde kılınan namaz';

  @override
  String get cardDescQadaPrayerTotal => 'Toplam kaza namazı';

  @override
  String get cardDescCongregationStreak => 'Aralıksız cemaat namazı';

  @override
  String get cardDescCongregationTotal => 'Toplam cemaat namazı';

  @override
  String get cardDescMosqueCongregationStreak => 'Aralıksız camide cemaat';

  @override
  String get cardDescMosqueCongregationTotal => 'Toplam camide cemaat namazı';

  @override
  String get cardDescFridayStreak => 'Aralıksız Cuma namazı';

  @override
  String get cardDescFridayTotal => 'Toplam Cuma namazı';

  @override
  String get cardDescKandilStreak => 'Aralıksız kandil namazları';

  @override
  String get cardDescKandilTotal => 'Toplam kandil namazı';

  @override
  String get cardDescEidStreak => 'Aralıksız bayram namazları';

  @override
  String get cardDescEidTotal => 'Toplam bayram namazı';

  @override
  String get cardDescMosqueDiscovery => 'Farklı camiler keşfedildi';

  @override
  String get cardDescMosqueRegular => 'Aynı camide aralıksız namaz';

  @override
  String get cardDescFirstPrayer => 'İlk namaz milestone\'ı';

  @override
  String get cardDescHundredPrayers => '100 namaz milestone\'ı (toplam)';

  @override
  String get cardDescFiveHundredPrayers => '500 namaz milestone\'ı (toplam)';

  @override
  String get cardDescThousandPrayers => '1000 namaz milestone\'ı';

  @override
  String get cardCountUnit => 'kart';

  @override
  String get statsFailedToLoad => 'İstatistikler yüklenemedi';

  @override
  String get generalStatistics => 'Genel İstatistikler';

  @override
  String get statTotalPrayers => 'Toplam Namaz';

  @override
  String get statCongregationPrayers => 'Cemaat Namazı';

  @override
  String get statBestStreak => 'En Uzun Seri';

  @override
  String get statWeeklyXp => 'Bu Hafta XP';

  @override
  String get detailProgress => 'İlerleme';

  @override
  String get detailXpContribution => 'XP Katkısı';

  @override
  String get detailRarityScore => 'Rarity Puanı';

  @override
  String get detailNextThreshold => 'Sonraki Eşik';

  @override
  String get gamificationErrorRestart => 'Lütfen uygulamayı yeniden başlatın';

  @override
  String get gamificationLoading => 'SEVİYEM';

  @override
  String get gamificationClose => 'Kapat';

  @override
  String get milestoneFirstStep => 'İlk Adım';

  @override
  String get milestoneRegular => 'Düzenli';

  @override
  String get milestoneDetermined => 'Azimli';

  @override
  String get milestoneDevoted => 'Müdavim';

  @override
  String get milestoneFirstCongregation => 'İlk Cemaat';

  @override
  String get milestoneCongregationLover => 'Cemaat Sevdalısı';

  @override
  String get milestoneCongregationMaster => 'Cemaat Ustası';

  @override
  String get milestoneFirstMosque => 'İlk Ziyaret';

  @override
  String get milestoneMosqueExplorer => 'Cami Kaşifi';

  @override
  String get milestoneRamadanWarrior => 'Ramazan Savaşçısı';

  @override
  String get milestoneNightOwl => 'Gece Kuşu';

  @override
  String get milestoneEarlyRiser => 'Erken Kalkan';

  @override
  String get milestoneDescFirstPrayer => 'İlk namazınızı kaydettiniz';

  @override
  String get milestoneDesc10Prayers => '10 namaz kaydettiniz';

  @override
  String get milestoneDesc50Prayers => '50 namaz kaydettiniz';

  @override
  String get milestoneDesc100Prayers => '100 namaz kaydettiniz';

  @override
  String get milestoneDescFirstCongregation =>
      'İlk cemaat namazınızı kaydettiniz';

  @override
  String get milestoneDesc25Congregation => '25 cemaat namazı kaydettiniz';

  @override
  String get milestoneDesc100Congregation => '100 cemaat namazı kaydettiniz';

  @override
  String get milestoneDescFirstMosque => 'İlk cami ziyaretinizi kaydettiniz';

  @override
  String get questComplete5Prayers => '5 Vakit Tamamla';

  @override
  String get quest3Congregation => '3 Cemaat';

  @override
  String get questFridayPrayer => 'Cuma Namazı';

  @override
  String get quest20Congregation => 'Cemaat Haftası';

  @override
  String get quest7DaysStreak => '7 Gün Seri';

  @override
  String get questDescComplete5 => 'Bugün 5 vakit namazı kaydet';

  @override
  String get questDesc3Congregation => 'Bugün 3 cemaat namazı kaydet';

  @override
  String get questDescFriday => 'Bu hafta Cuma namazını kaydet';

  @override
  String get questDesc20Congregation => 'Bu hafta 20 cemaat namazı kaydet';

  @override
  String get questDesc7Days => 'Bu hafta 7 gün aralıksız namaz kaydet';

  @override
  String get notificationSelectSound => 'Seç';

  @override
  String get notificationDefaultSound =>
      'Seçilen ses tüm bildirimler için varsayılan olarak kullanılır. Her namaz için ayrı ses belirleyebilirsiniz.';

  @override
  String get notificationSoundPicker => 'Bildirim Sesi Seçin';

  @override
  String get notificationSoundNote =>
      'Seçtiğiniz ses tüm bildirimler için varsayılan olarak kullanılacak';

  @override
  String get notificationSoundLabel => 'Bildirim Sesi';

  @override
  String get notificationPerPrayerTitle => 'Namaza Özel Ayarlar';

  @override
  String get notificationPerPrayerSubtitle =>
      'Her namaz için ayrı bildirim ayarları yapabilirsiniz';

  @override
  String get notificationPerPrayerDetail => 'Bu namaz için özel ayarlar';

  @override
  String get notificationPreMinutesLabel => 'Vakit öncesi:';

  @override
  String get notificationPreTimeGlobal => 'Vakit öncesi (Global)';

  @override
  String get notificationSoundGlobalPrefix => 'Genel';

  @override
  String get notificationUseGlobalSoundTooltip => 'Global ayarı kullan';

  @override
  String get notificationMuteAllSubtitle =>
      'Tüm bildirimleri geçici olarak durdur';

  @override
  String get notificationInPrayerMode => 'Namazdayım Modu';

  @override
  String get notificationInPrayerModeSubtitle =>
      'Namaz sırasında bildirimleri ertele';

  @override
  String get notificationWomenModeInfo =>
      'Kadın Özel Modu aktifken tüm bildirimler durdurulur.';

  @override
  String notificationInPrayerDelay(Object minutes) {
    return 'Namazdayım Modu aktifken yakın bildirimler $minutes dakika ertelenir.';
  }

  @override
  String get notificationPreTime => 'Vakit Öncesi Bildirim';

  @override
  String get notificationSpecialModes => 'Özel Modlar';

  @override
  String get prayerLabelSuffix => 'Namazı';

  @override
  String get notificationGeneralSettings => 'Genel Bildirim Ayarları';

  @override
  String get notificationOnTime => 'Vaktinde bildirim';

  @override
  String get notificationOnTimeSubtitle => 'Namaz vaktinde bildirim gönder';

  @override
  String get notificationPreTimeSubtitle => 'Namaz öncesinde bildirim gönder';

  @override
  String get notificationReturnToGlobal => 'Global ayarlara dön';

  @override
  String get notificationGlobal => 'Global';

  @override
  String get notificationWomenModeTitle => 'Kadın Özel Modu';

  @override
  String get notificationCustomizedSettings => 'Özelleştirilmiş ayarlar';

  @override
  String get notificationUsingGlobalSettings => 'Global ayarları kullanıyor';

  @override
  String get notificationBadgeCustom => 'ÖZEL';

  @override
  String get notificationCustomizeButton => 'Özelleştir';

  @override
  String get notificationToggleOff => 'Kapalı';

  @override
  String get notificationToggleOn => 'Açık';

  @override
  String minutesShort(int minutes) {
    return '$minutes dk';
  }

  @override
  String get soundSystem => 'Sistem';

  @override
  String get soundSoft1 => 'Yumuşak 1';

  @override
  String get soundSoft2 => 'Yumuşak 2';

  @override
  String get soundCheerful => 'Neşeli';

  @override
  String get soundQanun => 'Kanun';

  @override
  String get soundSingle => 'Tekli';

  @override
  String get soundAiry => 'Hafif';

  @override
  String get soundTwoNote => 'İki Nota';

  @override
  String get soundDesc_system => 'Cihazın varsayılan bildirim sesi';

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
  String get soundDesc_softBell => 'Yumuşak ve sakin bir zil sesi';

  @override
  String get soundDesc_softBellAlt => 'Yumuşak zil (alternatif versiyon)';

  @override
  String get soundDesc_shortAdhan => 'Kısa ezan melodisi';

  @override
  String get soundDesc_natureBell => 'Doğal ses efektli zil';

  @override
  String get soundDesc_gentleChime => 'Nazik ve melodik çan sesi';

  @override
  String get soundDesc_qanun => 'Qanun tarzı melodik parça';

  @override
  String get soundDesc_single8 => 'Tek nota, 8-bit tarzı kısa ses';

  @override
  String get soundDesc_twoNoteA => 'İki notalı A varyasyonu';

  @override
  String get soundDesc_twoNoteB => 'İki notalı B varyasyonu';

  @override
  String get soundDesc_softMix => 'Karışık yumuşak ses efekti';

  @override
  String get soundDesc_warm8bitAlt => 'Sıcak 8-bit alternatifi';

  @override
  String get soundDesc_clearSound => 'Net ve temiz bir bildirim sesi';

  @override
  String get soundDesc_systemAlarm => 'Cihazın alarm sesi';

  @override
  String get soundDesc_systemNotification => 'Cihazın bildirim tonu';

  @override
  String get soundDesc_systemRingtone => 'Cihazın zil sesi (ringtone)';

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
  String get mosquePickerTitle => 'CAMİ SEÇİN';

  @override
  String get mosquePickerSelectFromGallery => 'Galeriden Seç';

  @override
  String get mosquePickerSaveMosque => 'Camiyi Kaydet';

  @override
  String get mosquePickerNote => '• Kaydettiğiniz camiler listede görünecek';

  @override
  String mosquePickerImageError(String error) {
    return 'Resim seçilemedi: $error';
  }

  @override
  String get mosquePickerAddNewLabel => 'Yeni camii';

  @override
  String get mosquePickerNoSaved => 'Henüz kayıtlı cami yok';

  @override
  String get mosquePickerAddNewTitle => 'Yeni Cami Ekle';

  @override
  String get mosquePickerOptional => '(İsteğe bağlı)';

  @override
  String mosquePickerFirstVisit(Object day, Object month, Object year) {
    return 'İlk ziyaret: $day/$month/$year';
  }

  @override
  String get mosquePickerInfoLabel => 'Bilgi';

  @override
  String get mosquePickerNameExists => 'Bu isimde bir cami zaten kayıtlı';

  @override
  String get mosquePickerNameUnique => '• Aynı isimde cami ekleyemezsiniz';

  @override
  String get mosquePickerEnterName => 'Lütfen cami adını girin';

  @override
  String get mosquePickerNameLabel => 'Cami Adı';

  @override
  String get mosquePickerHintExample => 'Örn: Merkez Cami';

  @override
  String statisticsError(String error) {
    return 'Hata: $error';
  }

  @override
  String get statisticsToday => 'Bugün';

  @override
  String get statisticsWeek => 'Bu Hafta';

  @override
  String get statisticsMonth => 'Bu Ay';

  @override
  String get statisticsAll => 'Tümü';

  @override
  String get statisticsTotal => 'Toplam';

  @override
  String get statisticsCongregation => 'Cemaat';

  @override
  String get statisticsMakeup => 'Kaza';

  @override
  String get statisticsMissed => 'Kaçırılan';

  @override
  String get dialogCancel => 'İptal';

  @override
  String get dialogSave => 'Kaydet';

  @override
  String get dialogClose => 'Kapat';

  @override
  String get dialogSelect => 'Seç';

  @override
  String get dialogOk => 'Tamam';

  @override
  String get dialogYes => 'Evet';

  @override
  String get dialogNo => 'Hayır';

  @override
  String get dialogBack => 'Geri';

  @override
  String get loading => 'Yükleniyor...';

  @override
  String get error => 'Hata';

  @override
  String get success => 'Başarılı';

  @override
  String get failed => 'Başarısız';

  @override
  String get warning => 'Uyarı';

  @override
  String get confirm => 'Onayla';

  @override
  String get completed => 'Tamamlandı';

  @override
  String get level => 'Seviye';

  @override
  String get xp => 'XP';

  @override
  String get points => 'Puan';

  @override
  String get streak => 'Seri';

  @override
  String get statAbbrTotal => 'TOP';

  @override
  String get statAbbrCongregation => 'CEM';

  @override
  String get statAbbrActive => 'AKT';

  @override
  String get statAbbrBest => 'ENI';

  @override
  String get statAbbrMosques => 'CAM';

  @override
  String get statAbbrCards => 'KRT';

  @override
  String get statAbbrWeekly => 'HFT';

  @override
  String get defaultUser => 'Kullanıcı';

  @override
  String get progressLabel => 'İLERLEME';

  @override
  String get levelAbbr => 'SEVİYE';

  @override
  String get rarityBronze => 'Bronz';

  @override
  String get raritySilver => 'Gümüş';

  @override
  String get rarityGold => 'Altın';

  @override
  String get rarityPlatinum => 'Platin';

  @override
  String get rarityDiamond => 'Elmas';

  @override
  String get rarityLegendary => 'Efsanevi';

  @override
  String get rarityMythic => 'Mitik';

  @override
  String get holidayEidAlFitr => 'Ramazan Bayramı';

  @override
  String get holidayEidAlAdha => 'Kurban Bayramı';

  @override
  String get holidayMawlid => 'Mevlid Kandili';

  @override
  String get holidayLailatAlMiraj => 'Miraç Kandili';

  @override
  String get holidayLailatAlBarat => 'Berat Kandili';

  @override
  String get holidayLailatAlQadr => 'Kadir Gecesi';

  @override
  String get holidayAshura => 'Aşure Günü';

  @override
  String get holidayArafa => 'Arefe Günü';

  @override
  String get holidayRegaib => 'Regaip Kandili';

  @override
  String get shareSuccess => '✅ Paylaşım başarılı!';

  @override
  String shareError(String error) {
    return '❌ Paylaşım hatası: $error';
  }

  @override
  String shareCompletedSeries(String series) {
    return '✅ Tamamlanan Seri: $series';
  }

  @override
  String get dbSaveProfile => 'User profile kaydet';

  @override
  String get dbSaveCard => 'Kart kaydet';

  @override
  String get dbSaveAllCards => 'Tüm kartları kaydet';

  @override
  String get dbSaveStatistics => 'İstatistik kaydet';

  @override
  String get dbClose => 'Database\'i kapat';

  @override
  String get debugLoadingComplete => 'Gamification: Yükleme tamamlandı';

  @override
  String debugProfileError(String error) {
    return 'Gamification profil yükleme hatası: $error';
  }

  @override
  String debugRepoError(String error) {
    return 'Gamification Repository: _getUserProfileFromPrefs hata: $error';
  }

  @override
  String debugSaveError(String error) {
    return 'Gamification Repository: _saveUserProfileToPrefs hata: $error';
  }

  @override
  String get storageDescription =>
      'Dört durum: kılmadı (none), kaza, kıldı (kilindi), cemaatle.';

  @override
  String get storageCreateTable => 'prayer_records';

  @override
  String get storageDeleteOld => '30 günden eski kayıtları sil';

  @override
  String get storageGetRecords => 'Belirli tarih aralığındaki kayıtları getir';

  @override
  String get storageGetAllRecords => 'Tüm kayıtları getir';

  @override
  String get storageSaveRecord => 'Kayıt kaydet';

  @override
  String get storageUpdateRecord => 'Kayıt güncelle';

  @override
  String get storageDeleteRecord => 'Kayıt sil';

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
  String get raritySiradan => 'Sıradan';

  @override
  String get rarityNadir => 'Nadir';

  @override
  String get rarityPro => 'Pro';

  @override
  String get rarityGizemli => 'Gizemli';

  @override
  String get rarityEfsane => 'Efsane';

  @override
  String get rarityEpik => 'Epik';

  @override
  String get rarityTunc => 'Tunç';

  @override
  String get rarityGumus => 'Gümüş';

  @override
  String get rarityAltin => 'Altın';

  @override
  String get rarityPlatin => 'Platin';

  @override
  String get rarityElmas => 'Elmas';

  @override
  String get rarityNur => 'Nûr';

  @override
  String get raritySidre => 'Sidre';
}
