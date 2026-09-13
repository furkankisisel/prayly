import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('tr'),
    Locale('zh'),
  ];

  /// No description provided for @navigationPrayerTimes.
  ///
  /// In tr, this message translates to:
  /// **'Vakit'**
  String get navigationPrayerTimes;

  /// No description provided for @searchHintCityCountry.
  ///
  /// In tr, this message translates to:
  /// **'Şehir, Ülke'**
  String get searchHintCityCountry;

  /// No description provided for @navigationTracker.
  ///
  /// In tr, this message translates to:
  /// **'Takip'**
  String get navigationTracker;

  /// No description provided for @navigationQibla.
  ///
  /// In tr, this message translates to:
  /// **'Kıble'**
  String get navigationQibla;

  /// No description provided for @navigationLevel.
  ///
  /// In tr, this message translates to:
  /// **'Seviyem'**
  String get navigationLevel;

  /// No description provided for @navigationProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get navigationProfile;

  /// No description provided for @screenTitlePrayerTimes.
  ///
  /// In tr, this message translates to:
  /// **'Namaz Vakitleri'**
  String get screenTitlePrayerTimes;

  /// No description provided for @screenTitlePrayerTracker.
  ///
  /// In tr, this message translates to:
  /// **'Namaz Takip'**
  String get screenTitlePrayerTracker;

  /// No description provided for @screenTitleQiblaCompass.
  ///
  /// In tr, this message translates to:
  /// **'Kıble Pusulası'**
  String get screenTitleQiblaCompass;

  /// No description provided for @screenTitleLevel.
  ///
  /// In tr, this message translates to:
  /// **'Seviyem'**
  String get screenTitleLevel;

  /// No description provided for @screenTitleProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get screenTitleProfile;

  /// No description provided for @screenTitleNotificationSettings.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim Ayarları'**
  String get screenTitleNotificationSettings;

  /// No description provided for @screenTitleSplash.
  ///
  /// In tr, this message translates to:
  /// **'Prayly'**
  String get screenTitleSplash;

  /// No description provided for @prayerTimesRemainingTime.
  ///
  /// In tr, this message translates to:
  /// **'VAKTE KALAN SÜRE'**
  String get prayerTimesRemainingTime;

  /// No description provided for @prayerTimesLocation.
  ///
  /// In tr, this message translates to:
  /// **'Konum'**
  String get prayerTimesLocation;

  /// No description provided for @prayerTimesAutomatic.
  ///
  /// In tr, this message translates to:
  /// **'OTOMATİK'**
  String get prayerTimesAutomatic;

  /// No description provided for @prayerTimesHide.
  ///
  /// In tr, this message translates to:
  /// **'GİZLE'**
  String get prayerTimesHide;

  /// No description provided for @prayerTimesCity.
  ///
  /// In tr, this message translates to:
  /// **'ŞEHİR'**
  String get prayerTimesCity;

  /// No description provided for @prayerTimesLoading.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor'**
  String get prayerTimesLoading;

  /// No description provided for @prayerTimesNoResults.
  ///
  /// In tr, this message translates to:
  /// **'Sonuç bulunamadı'**
  String get prayerTimesNoResults;

  /// No description provided for @prayerTimesError.
  ///
  /// In tr, this message translates to:
  /// **'Hata: {error}'**
  String prayerTimesError(String error);

  /// No description provided for @prayerTimesLocationText.
  ///
  /// In tr, this message translates to:
  /// **'Konum: {city}, {country}'**
  String prayerTimesLocationText(String city, String country);

  /// No description provided for @prayerTimesLocationGPS.
  ///
  /// In tr, this message translates to:
  /// **'Konum: Cihaz GPS'**
  String get prayerTimesLocationGPS;

  /// No description provided for @prayerFajr.
  ///
  /// In tr, this message translates to:
  /// **'İmsak'**
  String get prayerFajr;

  /// No description provided for @prayerMorning.
  ///
  /// In tr, this message translates to:
  /// **'Sabah'**
  String get prayerMorning;

  /// No description provided for @prayerSunrise.
  ///
  /// In tr, this message translates to:
  /// **'Güneş'**
  String get prayerSunrise;

  /// No description provided for @prayerDhuhr.
  ///
  /// In tr, this message translates to:
  /// **'Öğle'**
  String get prayerDhuhr;

  /// No description provided for @prayerAsr.
  ///
  /// In tr, this message translates to:
  /// **'İkindi'**
  String get prayerAsr;

  /// No description provided for @prayerMaghrib.
  ///
  /// In tr, this message translates to:
  /// **'Akşam'**
  String get prayerMaghrib;

  /// No description provided for @prayerIsha.
  ///
  /// In tr, this message translates to:
  /// **'Yatsı'**
  String get prayerIsha;

  /// No description provided for @trackerSelectDate.
  ///
  /// In tr, this message translates to:
  /// **'Tarih Seç'**
  String get trackerSelectDate;

  /// No description provided for @trackerCancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get trackerCancel;

  /// No description provided for @trackerSelect.
  ///
  /// In tr, this message translates to:
  /// **'Seç'**
  String get trackerSelect;

  /// No description provided for @trackerToday.
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get trackerToday;

  /// No description provided for @trackerYesterday.
  ///
  /// In tr, this message translates to:
  /// **'Dün'**
  String get trackerYesterday;

  /// No description provided for @trackerHint.
  ///
  /// In tr, this message translates to:
  /// **'Namaz üzerine tıklayarak detaylı takip yapabilirsiniz'**
  String get trackerHint;

  /// No description provided for @trackerCompleted.
  ///
  /// In tr, this message translates to:
  /// **'{completed} / {total} tamamlandı'**
  String trackerCompleted(int completed, int total);

  /// No description provided for @trackerDialogHint.
  ///
  /// In tr, this message translates to:
  /// **'Namaz üzerine tıklayarak detaylı takip yapabilirsiniz'**
  String get trackerDialogHint;

  /// No description provided for @trackerPrayerName.
  ///
  /// In tr, this message translates to:
  /// **'{prayerName} Namazı'**
  String trackerPrayerName(String prayerName);

  /// No description provided for @trackerSelectStatus.
  ///
  /// In tr, this message translates to:
  /// **'Durum Seçin:'**
  String get trackerSelectStatus;

  /// No description provided for @trackerWhere.
  ///
  /// In tr, this message translates to:
  /// **'Nerede kıldınız?'**
  String get trackerWhere;

  /// No description provided for @trackerLocationAtHome.
  ///
  /// In tr, this message translates to:
  /// **'Camide değil'**
  String get trackerLocationAtHome;

  /// No description provided for @trackerLocationAtMosque.
  ///
  /// In tr, this message translates to:
  /// **'Camide'**
  String get trackerLocationAtMosque;

  /// No description provided for @locationAtHome.
  ///
  /// In tr, this message translates to:
  /// **'Camide değil'**
  String get locationAtHome;

  /// No description provided for @locationAtMosque.
  ///
  /// In tr, this message translates to:
  /// **'Camide'**
  String get locationAtMosque;

  /// No description provided for @statusNotPrayed.
  ///
  /// In tr, this message translates to:
  /// **'Kılmadı'**
  String get statusNotPrayed;

  /// No description provided for @statusMakeup.
  ///
  /// In tr, this message translates to:
  /// **'Kaza'**
  String get statusMakeup;

  /// No description provided for @statusPrayed.
  ///
  /// In tr, this message translates to:
  /// **'Kıldı'**
  String get statusPrayed;

  /// No description provided for @statusCongregation.
  ///
  /// In tr, this message translates to:
  /// **'Cemaat'**
  String get statusCongregation;

  /// No description provided for @qiblaPermissionRequired.
  ///
  /// In tr, this message translates to:
  /// **'Kıble yönünü hesaplamak için konum izni gerekli'**
  String get qiblaPermissionRequired;

  /// No description provided for @qiblaServiceDisabled.
  ///
  /// In tr, this message translates to:
  /// **'Konum servisi kapalı. Lütfen GPS/konum hizmetini açın'**
  String get qiblaServiceDisabled;

  /// No description provided for @qiblaLocationError.
  ///
  /// In tr, this message translates to:
  /// **'Lokasyon alınamadı: {error}'**
  String qiblaLocationError(String error);

  /// No description provided for @qiblaPermissionDenied.
  ///
  /// In tr, this message translates to:
  /// **'Konum izni reddedildi. Lütfen ayarlardan izin verin'**
  String get qiblaPermissionDenied;

  /// No description provided for @qiblaPermissionPermanentlyDenied.
  ///
  /// In tr, this message translates to:
  /// **'Konum izni kalıcı olarak reddedildi. Lütfen ayarlardan izin verin'**
  String get qiblaPermissionPermanentlyDenied;

  /// No description provided for @qiblaPermissionError.
  ///
  /// In tr, this message translates to:
  /// **'İzin alınırken hata: {error}'**
  String qiblaPermissionError(String error);

  /// No description provided for @qiblaGrantPermission.
  ///
  /// In tr, this message translates to:
  /// **'İzin Ver'**
  String get qiblaGrantPermission;

  /// No description provided for @qiblaOpenSettings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarları Aç'**
  String get qiblaOpenSettings;

  /// No description provided for @qiblaRefresh.
  ///
  /// In tr, this message translates to:
  /// **'Yenile'**
  String get qiblaRefresh;

  /// No description provided for @qiblaDeviceDirection.
  ///
  /// In tr, this message translates to:
  /// **'Cihaz Yönü'**
  String get qiblaDeviceDirection;

  /// No description provided for @qiblaNorth.
  ///
  /// In tr, this message translates to:
  /// **'Kuzey'**
  String get qiblaNorth;

  /// No description provided for @qiblaSouth.
  ///
  /// In tr, this message translates to:
  /// **'Güney'**
  String get qiblaSouth;

  /// No description provided for @qiblaEast.
  ///
  /// In tr, this message translates to:
  /// **'Doğu'**
  String get qiblaEast;

  /// No description provided for @qiblaWest.
  ///
  /// In tr, this message translates to:
  /// **'Batı'**
  String get qiblaWest;

  /// No description provided for @qiblaPermissionPrompt.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen konum izni verin'**
  String get qiblaPermissionPrompt;

  /// No description provided for @qiblaDirectionReading.
  ///
  /// In tr, this message translates to:
  /// **'Yön Okuması'**
  String get qiblaDirectionReading;

  /// No description provided for @qiblaWaitingLocation.
  ///
  /// In tr, this message translates to:
  /// **'Lokasyon bekleniyor...'**
  String get qiblaWaitingLocation;

  /// No description provided for @qiblaCompassSensorUnavailable.
  ///
  /// In tr, this message translates to:
  /// **'Pusula sensörü kullanılamıyor'**
  String get qiblaCompassSensorUnavailable;

  /// No description provided for @qiblaPullToRefresh.
  ///
  /// In tr, this message translates to:
  /// **'Yenilemek için çekin'**
  String get qiblaPullToRefresh;

  /// No description provided for @qiblaDirectionWaiting.
  ///
  /// In tr, this message translates to:
  /// **'Bekleniyor...'**
  String get qiblaDirectionWaiting;

  /// No description provided for @qiblaAligned.
  ///
  /// In tr, this message translates to:
  /// **'Hizalı'**
  String get qiblaAligned;

  /// No description provided for @qiblaTurnRight.
  ///
  /// In tr, this message translates to:
  /// **'Sağa dön'**
  String get qiblaTurnRight;

  /// No description provided for @qiblaTurnLeft.
  ///
  /// In tr, this message translates to:
  /// **'Sola dön'**
  String get qiblaTurnLeft;

  /// No description provided for @weekdayMonday.
  ///
  /// In tr, this message translates to:
  /// **'Pazartesi'**
  String get weekdayMonday;

  /// No description provided for @weekdayTuesday.
  ///
  /// In tr, this message translates to:
  /// **'Salı'**
  String get weekdayTuesday;

  /// No description provided for @weekdayWednesday.
  ///
  /// In tr, this message translates to:
  /// **'Çarşamba'**
  String get weekdayWednesday;

  /// No description provided for @weekdayThursday.
  ///
  /// In tr, this message translates to:
  /// **'Perşembe'**
  String get weekdayThursday;

  /// No description provided for @weekdayFriday.
  ///
  /// In tr, this message translates to:
  /// **'Cuma'**
  String get weekdayFriday;

  /// No description provided for @weekdaySaturday.
  ///
  /// In tr, this message translates to:
  /// **'Cumartesi'**
  String get weekdaySaturday;

  /// No description provided for @weekdaySunday.
  ///
  /// In tr, this message translates to:
  /// **'Pazar'**
  String get weekdaySunday;

  /// No description provided for @profileXpToNextLevel.
  ///
  /// In tr, this message translates to:
  /// **'Seviye {level} — {xp} XP sonraki seviyeye'**
  String profileXpToNextLevel(int level, int xp);

  /// No description provided for @profileUser.
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı'**
  String get profileUser;

  /// No description provided for @profileChangeAvatar.
  ///
  /// In tr, this message translates to:
  /// **'Profil resmini değiştirmek için dokunun'**
  String get profileChangeAvatar;

  /// No description provided for @profileThemeSettings.
  ///
  /// In tr, this message translates to:
  /// **'Tema Ayarları'**
  String get profileThemeSettings;

  /// No description provided for @profileThemeLight.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get profileThemeLight;

  /// No description provided for @profileThemeDark.
  ///
  /// In tr, this message translates to:
  /// **'Koyu'**
  String get profileThemeDark;

  /// No description provided for @profileThemeAmoled.
  ///
  /// In tr, this message translates to:
  /// **'AMOLED'**
  String get profileThemeAmoled;

  /// No description provided for @profileThemeSystem.
  ///
  /// In tr, this message translates to:
  /// **'Sistem'**
  String get profileThemeSystem;

  /// No description provided for @profileNotifications.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get profileNotifications;

  /// No description provided for @profileNotificationSettings.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim Ayarları'**
  String get profileNotificationSettings;

  /// No description provided for @profileClose.
  ///
  /// In tr, this message translates to:
  /// **'KAPAT'**
  String get profileClose;

  /// No description provided for @profileSelectFromGallery.
  ///
  /// In tr, this message translates to:
  /// **'Galeriden Seç'**
  String get profileSelectFromGallery;

  /// No description provided for @profileImageError.
  ///
  /// In tr, this message translates to:
  /// **'Resim seçilirken hata oluştu: {error}'**
  String profileImageError(String error);

  /// No description provided for @profileSave.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get profileSave;

  /// No description provided for @gamificationProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get gamificationProfile;

  /// No description provided for @gamificationCards.
  ///
  /// In tr, this message translates to:
  /// **'Kartlar'**
  String get gamificationCards;

  /// No description provided for @gamificationStatistics.
  ///
  /// In tr, this message translates to:
  /// **'İstatistik'**
  String get gamificationStatistics;

  /// No description provided for @statisticsTitle.
  ///
  /// In tr, this message translates to:
  /// **'İSTATİSTİKLER'**
  String get statisticsTitle;

  /// No description provided for @statisticsTabWeekly.
  ///
  /// In tr, this message translates to:
  /// **'HAFTALIK'**
  String get statisticsTabWeekly;

  /// No description provided for @statisticsTabMonthly.
  ///
  /// In tr, this message translates to:
  /// **'AYLIK'**
  String get statisticsTabMonthly;

  /// No description provided for @statisticsTabYearly.
  ///
  /// In tr, this message translates to:
  /// **'YILLIK'**
  String get statisticsTabYearly;

  /// No description provided for @statisticsSquares.
  ///
  /// In tr, this message translates to:
  /// **'Kareler'**
  String get statisticsSquares;

  /// No description provided for @statisticsSummary.
  ///
  /// In tr, this message translates to:
  /// **'Özet'**
  String get statisticsSummary;

  /// No description provided for @statisticsOverall.
  ///
  /// In tr, this message translates to:
  /// **'Genel Dağılım'**
  String get statisticsOverall;

  /// No description provided for @statisticsMiniLabelDone.
  ///
  /// In tr, this message translates to:
  /// **'Kıldı'**
  String get statisticsMiniLabelDone;

  /// No description provided for @statisticsMiniLabelCongregation.
  ///
  /// In tr, this message translates to:
  /// **'Cemaat'**
  String get statisticsMiniLabelCongregation;

  /// No description provided for @statisticsMiniLabelMakeup.
  ///
  /// In tr, this message translates to:
  /// **'Kaza'**
  String get statisticsMiniLabelMakeup;

  /// No description provided for @statisticsMiniLabelNotPrayed.
  ///
  /// In tr, this message translates to:
  /// **'Kılınmadı'**
  String get statisticsMiniLabelNotPrayed;

  /// No description provided for @statisticsLast7Days.
  ///
  /// In tr, this message translates to:
  /// **'Son 7 Gün'**
  String get statisticsLast7Days;

  /// No description provided for @statisticsLast30Days.
  ///
  /// In tr, this message translates to:
  /// **'Son 30 Gün'**
  String get statisticsLast30Days;

  /// No description provided for @statisticsLast365Days.
  ///
  /// In tr, this message translates to:
  /// **'Son 365 Gün'**
  String get statisticsLast365Days;

  /// No description provided for @gamificationErrorLoading.
  ///
  /// In tr, this message translates to:
  /// **'Profil yüklenirken bir sorun oluştu'**
  String get gamificationErrorLoading;

  /// No description provided for @gamificationPleaseRestart.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen uygulamayı yeniden başlatın.'**
  String get gamificationPleaseRestart;

  /// No description provided for @activeStreaks.
  ///
  /// In tr, this message translates to:
  /// **'Aktif Seriler'**
  String get activeStreaks;

  /// No description provided for @daysUnit.
  ///
  /// In tr, this message translates to:
  /// **'gün'**
  String get daysUnit;

  /// No description provided for @cardsCollection.
  ///
  /// In tr, this message translates to:
  /// **'Kart Koleksiyonu ({count})'**
  String cardsCollection(Object count);

  /// No description provided for @cardsDistribution.
  ///
  /// In tr, this message translates to:
  /// **'Kart Dağılımı'**
  String get cardsDistribution;

  /// No description provided for @categoryDaily.
  ///
  /// In tr, this message translates to:
  /// **'Günlük Namazlar'**
  String get categoryDaily;

  /// No description provided for @categoryFriday.
  ///
  /// In tr, this message translates to:
  /// **'Cuma Namazları'**
  String get categoryFriday;

  /// No description provided for @categoryKandil.
  ///
  /// In tr, this message translates to:
  /// **'Kandil Geceleri'**
  String get categoryKandil;

  /// No description provided for @categoryEid.
  ///
  /// In tr, this message translates to:
  /// **'Bayramlar'**
  String get categoryEid;

  /// No description provided for @categoryMosque.
  ///
  /// In tr, this message translates to:
  /// **'Cami Keşfi'**
  String get categoryMosque;

  /// No description provided for @categoryMilestone.
  ///
  /// In tr, this message translates to:
  /// **'Milestone\'lar'**
  String get categoryMilestone;

  /// No description provided for @cardHomePrayerStreak.
  ///
  /// In tr, this message translates to:
  /// **'Evde Namaz Serisi'**
  String get cardHomePrayerStreak;

  /// No description provided for @cardHomePrayerTotal.
  ///
  /// In tr, this message translates to:
  /// **'Evde Namaz Toplamı'**
  String get cardHomePrayerTotal;

  /// No description provided for @cardQadaPrayerTotal.
  ///
  /// In tr, this message translates to:
  /// **'Kaza Toplamı'**
  String get cardQadaPrayerTotal;

  /// No description provided for @cardCongregationStreak.
  ///
  /// In tr, this message translates to:
  /// **'Cemaat Serisi'**
  String get cardCongregationStreak;

  /// No description provided for @cardCongregationTotal.
  ///
  /// In tr, this message translates to:
  /// **'Cemaat Toplamı'**
  String get cardCongregationTotal;

  /// No description provided for @cardMosqueCongregationStreak.
  ///
  /// In tr, this message translates to:
  /// **'Camide Cemaat Serisi'**
  String get cardMosqueCongregationStreak;

  /// No description provided for @cardMosqueCongregationTotal.
  ///
  /// In tr, this message translates to:
  /// **'Camide Cemaat Toplamı'**
  String get cardMosqueCongregationTotal;

  /// No description provided for @cardFridayStreak.
  ///
  /// In tr, this message translates to:
  /// **'Cuma Serisi'**
  String get cardFridayStreak;

  /// No description provided for @cardFridayTotal.
  ///
  /// In tr, this message translates to:
  /// **'Cuma Toplamı'**
  String get cardFridayTotal;

  /// No description provided for @cardKandilStreak.
  ///
  /// In tr, this message translates to:
  /// **'Kandil Serisi'**
  String get cardKandilStreak;

  /// No description provided for @cardKandilTotal.
  ///
  /// In tr, this message translates to:
  /// **'Kandil Toplamı'**
  String get cardKandilTotal;

  /// No description provided for @cardEidStreak.
  ///
  /// In tr, this message translates to:
  /// **'Bayram Serisi'**
  String get cardEidStreak;

  /// No description provided for @cardEidTotal.
  ///
  /// In tr, this message translates to:
  /// **'Bayram Toplamı'**
  String get cardEidTotal;

  /// No description provided for @cardMosqueDiscovery.
  ///
  /// In tr, this message translates to:
  /// **'Cami Kaşifi'**
  String get cardMosqueDiscovery;

  /// No description provided for @cardMosqueRegular.
  ///
  /// In tr, this message translates to:
  /// **'Cami Müdavimi'**
  String get cardMosqueRegular;

  /// No description provided for @cardFirstPrayer.
  ///
  /// In tr, this message translates to:
  /// **'İlk Adım'**
  String get cardFirstPrayer;

  /// No description provided for @cardHundredPrayers.
  ///
  /// In tr, this message translates to:
  /// **'Yüz Namaz'**
  String get cardHundredPrayers;

  /// No description provided for @cardFiveHundredPrayers.
  ///
  /// In tr, this message translates to:
  /// **'Beş Yüz Namaz'**
  String get cardFiveHundredPrayers;

  /// No description provided for @cardThousandPrayers.
  ///
  /// In tr, this message translates to:
  /// **'Bin Namaz'**
  String get cardThousandPrayers;

  /// No description provided for @cardDescHomePrayerStreak.
  ///
  /// In tr, this message translates to:
  /// **'Aralıksız evde namaz'**
  String get cardDescHomePrayerStreak;

  /// No description provided for @cardDescHomePrayerTotal.
  ///
  /// In tr, this message translates to:
  /// **'Toplam evde kılınan namaz'**
  String get cardDescHomePrayerTotal;

  /// No description provided for @cardDescQadaPrayerTotal.
  ///
  /// In tr, this message translates to:
  /// **'Toplam kaza namazı'**
  String get cardDescQadaPrayerTotal;

  /// No description provided for @cardDescCongregationStreak.
  ///
  /// In tr, this message translates to:
  /// **'Aralıksız cemaat namazı'**
  String get cardDescCongregationStreak;

  /// No description provided for @cardDescCongregationTotal.
  ///
  /// In tr, this message translates to:
  /// **'Toplam cemaat namazı'**
  String get cardDescCongregationTotal;

  /// No description provided for @cardDescMosqueCongregationStreak.
  ///
  /// In tr, this message translates to:
  /// **'Aralıksız camide cemaat'**
  String get cardDescMosqueCongregationStreak;

  /// No description provided for @cardDescMosqueCongregationTotal.
  ///
  /// In tr, this message translates to:
  /// **'Toplam camide cemaat namazı'**
  String get cardDescMosqueCongregationTotal;

  /// No description provided for @cardDescFridayStreak.
  ///
  /// In tr, this message translates to:
  /// **'Aralıksız Cuma namazı'**
  String get cardDescFridayStreak;

  /// No description provided for @cardDescFridayTotal.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Cuma namazı'**
  String get cardDescFridayTotal;

  /// No description provided for @cardDescKandilStreak.
  ///
  /// In tr, this message translates to:
  /// **'Aralıksız kandil namazları'**
  String get cardDescKandilStreak;

  /// No description provided for @cardDescKandilTotal.
  ///
  /// In tr, this message translates to:
  /// **'Toplam kandil namazı'**
  String get cardDescKandilTotal;

  /// No description provided for @cardDescEidStreak.
  ///
  /// In tr, this message translates to:
  /// **'Aralıksız bayram namazları'**
  String get cardDescEidStreak;

  /// No description provided for @cardDescEidTotal.
  ///
  /// In tr, this message translates to:
  /// **'Toplam bayram namazı'**
  String get cardDescEidTotal;

  /// No description provided for @cardDescMosqueDiscovery.
  ///
  /// In tr, this message translates to:
  /// **'Farklı camiler keşfedildi'**
  String get cardDescMosqueDiscovery;

  /// No description provided for @cardDescMosqueRegular.
  ///
  /// In tr, this message translates to:
  /// **'Aynı camide aralıksız namaz'**
  String get cardDescMosqueRegular;

  /// No description provided for @cardDescFirstPrayer.
  ///
  /// In tr, this message translates to:
  /// **'İlk namaz milestone\'ı'**
  String get cardDescFirstPrayer;

  /// No description provided for @cardDescHundredPrayers.
  ///
  /// In tr, this message translates to:
  /// **'100 namaz milestone\'ı (toplam)'**
  String get cardDescHundredPrayers;

  /// No description provided for @cardDescFiveHundredPrayers.
  ///
  /// In tr, this message translates to:
  /// **'500 namaz milestone\'ı (toplam)'**
  String get cardDescFiveHundredPrayers;

  /// No description provided for @cardDescThousandPrayers.
  ///
  /// In tr, this message translates to:
  /// **'1000 namaz milestone\'ı'**
  String get cardDescThousandPrayers;

  /// No description provided for @cardCountUnit.
  ///
  /// In tr, this message translates to:
  /// **'kart'**
  String get cardCountUnit;

  /// No description provided for @statsFailedToLoad.
  ///
  /// In tr, this message translates to:
  /// **'İstatistikler yüklenemedi'**
  String get statsFailedToLoad;

  /// No description provided for @generalStatistics.
  ///
  /// In tr, this message translates to:
  /// **'Genel İstatistikler'**
  String get generalStatistics;

  /// No description provided for @statTotalPrayers.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Namaz'**
  String get statTotalPrayers;

  /// No description provided for @statCongregationPrayers.
  ///
  /// In tr, this message translates to:
  /// **'Cemaat Namazı'**
  String get statCongregationPrayers;

  /// No description provided for @statBestStreak.
  ///
  /// In tr, this message translates to:
  /// **'En Uzun Seri'**
  String get statBestStreak;

  /// No description provided for @statWeeklyXp.
  ///
  /// In tr, this message translates to:
  /// **'Bu Hafta XP'**
  String get statWeeklyXp;

  /// No description provided for @detailProgress.
  ///
  /// In tr, this message translates to:
  /// **'İlerleme'**
  String get detailProgress;

  /// No description provided for @detailXpContribution.
  ///
  /// In tr, this message translates to:
  /// **'XP Katkısı'**
  String get detailXpContribution;

  /// No description provided for @detailRarityScore.
  ///
  /// In tr, this message translates to:
  /// **'Rarity Puanı'**
  String get detailRarityScore;

  /// No description provided for @detailNextThreshold.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki Eşik'**
  String get detailNextThreshold;

  /// No description provided for @gamificationErrorRestart.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen uygulamayı yeniden başlatın'**
  String get gamificationErrorRestart;

  /// No description provided for @gamificationLoading.
  ///
  /// In tr, this message translates to:
  /// **'SEVİYEM'**
  String get gamificationLoading;

  /// No description provided for @gamificationClose.
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get gamificationClose;

  /// No description provided for @milestoneFirstStep.
  ///
  /// In tr, this message translates to:
  /// **'İlk Adım'**
  String get milestoneFirstStep;

  /// No description provided for @milestoneRegular.
  ///
  /// In tr, this message translates to:
  /// **'Düzenli'**
  String get milestoneRegular;

  /// No description provided for @milestoneDetermined.
  ///
  /// In tr, this message translates to:
  /// **'Azimli'**
  String get milestoneDetermined;

  /// No description provided for @milestoneDevoted.
  ///
  /// In tr, this message translates to:
  /// **'Müdavim'**
  String get milestoneDevoted;

  /// No description provided for @milestoneFirstCongregation.
  ///
  /// In tr, this message translates to:
  /// **'İlk Cemaat'**
  String get milestoneFirstCongregation;

  /// No description provided for @milestoneCongregationLover.
  ///
  /// In tr, this message translates to:
  /// **'Cemaat Sevdalısı'**
  String get milestoneCongregationLover;

  /// No description provided for @milestoneCongregationMaster.
  ///
  /// In tr, this message translates to:
  /// **'Cemaat Ustası'**
  String get milestoneCongregationMaster;

  /// No description provided for @milestoneFirstMosque.
  ///
  /// In tr, this message translates to:
  /// **'İlk Ziyaret'**
  String get milestoneFirstMosque;

  /// No description provided for @milestoneMosqueExplorer.
  ///
  /// In tr, this message translates to:
  /// **'Cami Kaşifi'**
  String get milestoneMosqueExplorer;

  /// No description provided for @milestoneRamadanWarrior.
  ///
  /// In tr, this message translates to:
  /// **'Ramazan Savaşçısı'**
  String get milestoneRamadanWarrior;

  /// No description provided for @milestoneNightOwl.
  ///
  /// In tr, this message translates to:
  /// **'Gece Kuşu'**
  String get milestoneNightOwl;

  /// No description provided for @milestoneEarlyRiser.
  ///
  /// In tr, this message translates to:
  /// **'Erken Kalkan'**
  String get milestoneEarlyRiser;

  /// No description provided for @milestoneDescFirstPrayer.
  ///
  /// In tr, this message translates to:
  /// **'İlk namazınızı kaydettiniz'**
  String get milestoneDescFirstPrayer;

  /// No description provided for @milestoneDesc10Prayers.
  ///
  /// In tr, this message translates to:
  /// **'10 namaz kaydettiniz'**
  String get milestoneDesc10Prayers;

  /// No description provided for @milestoneDesc50Prayers.
  ///
  /// In tr, this message translates to:
  /// **'50 namaz kaydettiniz'**
  String get milestoneDesc50Prayers;

  /// No description provided for @milestoneDesc100Prayers.
  ///
  /// In tr, this message translates to:
  /// **'100 namaz kaydettiniz'**
  String get milestoneDesc100Prayers;

  /// No description provided for @milestoneDescFirstCongregation.
  ///
  /// In tr, this message translates to:
  /// **'İlk cemaat namazınızı kaydettiniz'**
  String get milestoneDescFirstCongregation;

  /// No description provided for @milestoneDesc25Congregation.
  ///
  /// In tr, this message translates to:
  /// **'25 cemaat namazı kaydettiniz'**
  String get milestoneDesc25Congregation;

  /// No description provided for @milestoneDesc100Congregation.
  ///
  /// In tr, this message translates to:
  /// **'100 cemaat namazı kaydettiniz'**
  String get milestoneDesc100Congregation;

  /// No description provided for @milestoneDescFirstMosque.
  ///
  /// In tr, this message translates to:
  /// **'İlk cami ziyaretinizi kaydettiniz'**
  String get milestoneDescFirstMosque;

  /// No description provided for @questComplete5Prayers.
  ///
  /// In tr, this message translates to:
  /// **'5 Vakit Tamamla'**
  String get questComplete5Prayers;

  /// No description provided for @quest3Congregation.
  ///
  /// In tr, this message translates to:
  /// **'3 Cemaat'**
  String get quest3Congregation;

  /// No description provided for @questFridayPrayer.
  ///
  /// In tr, this message translates to:
  /// **'Cuma Namazı'**
  String get questFridayPrayer;

  /// No description provided for @quest20Congregation.
  ///
  /// In tr, this message translates to:
  /// **'Cemaat Haftası'**
  String get quest20Congregation;

  /// No description provided for @quest7DaysStreak.
  ///
  /// In tr, this message translates to:
  /// **'7 Gün Seri'**
  String get quest7DaysStreak;

  /// No description provided for @questDescComplete5.
  ///
  /// In tr, this message translates to:
  /// **'Bugün 5 vakit namazı kaydet'**
  String get questDescComplete5;

  /// No description provided for @questDesc3Congregation.
  ///
  /// In tr, this message translates to:
  /// **'Bugün 3 cemaat namazı kaydet'**
  String get questDesc3Congregation;

  /// No description provided for @questDescFriday.
  ///
  /// In tr, this message translates to:
  /// **'Bu hafta Cuma namazını kaydet'**
  String get questDescFriday;

  /// No description provided for @questDesc20Congregation.
  ///
  /// In tr, this message translates to:
  /// **'Bu hafta 20 cemaat namazı kaydet'**
  String get questDesc20Congregation;

  /// No description provided for @questDesc7Days.
  ///
  /// In tr, this message translates to:
  /// **'Bu hafta 7 gün aralıksız namaz kaydet'**
  String get questDesc7Days;

  /// No description provided for @notificationSelectSound.
  ///
  /// In tr, this message translates to:
  /// **'Seç'**
  String get notificationSelectSound;

  /// No description provided for @notificationDefaultSound.
  ///
  /// In tr, this message translates to:
  /// **'Seçilen ses tüm bildirimler için varsayılan olarak kullanılır. Her namaz için ayrı ses belirleyebilirsiniz.'**
  String get notificationDefaultSound;

  /// No description provided for @notificationSoundPicker.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim Sesi Seçin'**
  String get notificationSoundPicker;

  /// No description provided for @notificationSoundNote.
  ///
  /// In tr, this message translates to:
  /// **'Seçtiğiniz ses tüm bildirimler için varsayılan olarak kullanılacak'**
  String get notificationSoundNote;

  /// No description provided for @notificationSoundLabel.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim Sesi'**
  String get notificationSoundLabel;

  /// No description provided for @notificationPerPrayerTitle.
  ///
  /// In tr, this message translates to:
  /// **'Namaza Özel Ayarlar'**
  String get notificationPerPrayerTitle;

  /// No description provided for @notificationPerPrayerSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Her namaz için ayrı bildirim ayarları yapabilirsiniz'**
  String get notificationPerPrayerSubtitle;

  /// No description provided for @notificationPerPrayerDetail.
  ///
  /// In tr, this message translates to:
  /// **'Bu namaz için özel ayarlar'**
  String get notificationPerPrayerDetail;

  /// No description provided for @notificationPreMinutesLabel.
  ///
  /// In tr, this message translates to:
  /// **'Vakit öncesi:'**
  String get notificationPreMinutesLabel;

  /// No description provided for @notificationPreTimeGlobal.
  ///
  /// In tr, this message translates to:
  /// **'Vakit öncesi (Global)'**
  String get notificationPreTimeGlobal;

  /// No description provided for @notificationSoundGlobalPrefix.
  ///
  /// In tr, this message translates to:
  /// **'Genel'**
  String get notificationSoundGlobalPrefix;

  /// No description provided for @notificationUseGlobalSoundTooltip.
  ///
  /// In tr, this message translates to:
  /// **'Global ayarı kullan'**
  String get notificationUseGlobalSoundTooltip;

  /// No description provided for @notificationMuteAllSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Tüm bildirimleri geçici olarak durdur'**
  String get notificationMuteAllSubtitle;

  /// No description provided for @notificationInPrayerMode.
  ///
  /// In tr, this message translates to:
  /// **'Namazdayım Modu'**
  String get notificationInPrayerMode;

  /// No description provided for @notificationInPrayerModeSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Namaz sırasında bildirimleri ertele'**
  String get notificationInPrayerModeSubtitle;

  /// No description provided for @notificationWomenModeInfo.
  ///
  /// In tr, this message translates to:
  /// **'Kadın Özel Modu aktifken tüm bildirimler durdurulur.'**
  String get notificationWomenModeInfo;

  /// No description provided for @notificationInPrayerDelay.
  ///
  /// In tr, this message translates to:
  /// **'Namazdayım Modu aktifken yakın bildirimler {minutes} dakika ertelenir.'**
  String notificationInPrayerDelay(Object minutes);

  /// No description provided for @notificationPreTime.
  ///
  /// In tr, this message translates to:
  /// **'Vakit Öncesi Bildirim'**
  String get notificationPreTime;

  /// No description provided for @notificationSpecialModes.
  ///
  /// In tr, this message translates to:
  /// **'Özel Modlar'**
  String get notificationSpecialModes;

  /// No description provided for @prayerLabelSuffix.
  ///
  /// In tr, this message translates to:
  /// **'Namazı'**
  String get prayerLabelSuffix;

  /// No description provided for @notificationGeneralSettings.
  ///
  /// In tr, this message translates to:
  /// **'Genel Bildirim Ayarları'**
  String get notificationGeneralSettings;

  /// No description provided for @notificationOnTime.
  ///
  /// In tr, this message translates to:
  /// **'Vaktinde bildirim'**
  String get notificationOnTime;

  /// No description provided for @notificationOnTimeSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Namaz vaktinde bildirim gönder'**
  String get notificationOnTimeSubtitle;

  /// No description provided for @notificationPreTimeSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Namaz öncesinde bildirim gönder'**
  String get notificationPreTimeSubtitle;

  /// No description provided for @notificationReturnToGlobal.
  ///
  /// In tr, this message translates to:
  /// **'Global ayarlara dön'**
  String get notificationReturnToGlobal;

  /// No description provided for @notificationGlobal.
  ///
  /// In tr, this message translates to:
  /// **'Global'**
  String get notificationGlobal;

  /// No description provided for @notificationWomenModeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kadın Özel Modu'**
  String get notificationWomenModeTitle;

  /// No description provided for @notificationCustomizedSettings.
  ///
  /// In tr, this message translates to:
  /// **'Özelleştirilmiş ayarlar'**
  String get notificationCustomizedSettings;

  /// No description provided for @notificationUsingGlobalSettings.
  ///
  /// In tr, this message translates to:
  /// **'Global ayarları kullanıyor'**
  String get notificationUsingGlobalSettings;

  /// No description provided for @notificationBadgeCustom.
  ///
  /// In tr, this message translates to:
  /// **'ÖZEL'**
  String get notificationBadgeCustom;

  /// No description provided for @notificationCustomizeButton.
  ///
  /// In tr, this message translates to:
  /// **'Özelleştir'**
  String get notificationCustomizeButton;

  /// No description provided for @notificationToggleOff.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı'**
  String get notificationToggleOff;

  /// No description provided for @notificationToggleOn.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get notificationToggleOn;

  /// No description provided for @minutesShort.
  ///
  /// In tr, this message translates to:
  /// **'{minutes} dk'**
  String minutesShort(int minutes);

  /// No description provided for @soundSystem.
  ///
  /// In tr, this message translates to:
  /// **'Sistem'**
  String get soundSystem;

  /// No description provided for @soundSoft1.
  ///
  /// In tr, this message translates to:
  /// **'Yumuşak 1'**
  String get soundSoft1;

  /// No description provided for @soundSoft2.
  ///
  /// In tr, this message translates to:
  /// **'Yumuşak 2'**
  String get soundSoft2;

  /// No description provided for @soundCheerful.
  ///
  /// In tr, this message translates to:
  /// **'Neşeli'**
  String get soundCheerful;

  /// No description provided for @soundQanun.
  ///
  /// In tr, this message translates to:
  /// **'Kanun'**
  String get soundQanun;

  /// No description provided for @soundSingle.
  ///
  /// In tr, this message translates to:
  /// **'Tekli'**
  String get soundSingle;

  /// No description provided for @soundAiry.
  ///
  /// In tr, this message translates to:
  /// **'Hafif'**
  String get soundAiry;

  /// No description provided for @soundTwoNote.
  ///
  /// In tr, this message translates to:
  /// **'İki Nota'**
  String get soundTwoNote;

  /// No description provided for @soundDesc_system.
  ///
  /// In tr, this message translates to:
  /// **'Cihazın varsayılan bildirim sesi'**
  String get soundDesc_system;

  /// No description provided for @soundNameSystem.
  ///
  /// In tr, this message translates to:
  /// **'Sistem Varsayılanı'**
  String get soundNameSystem;

  /// No description provided for @soundNameSoftBell.
  ///
  /// In tr, this message translates to:
  /// **'Yumuşak Zil'**
  String get soundNameSoftBell;

  /// No description provided for @soundNameSoftBellAlt.
  ///
  /// In tr, this message translates to:
  /// **'Yumuşak Zil (Alternatif)'**
  String get soundNameSoftBellAlt;

  /// No description provided for @soundNameShortAdhan.
  ///
  /// In tr, this message translates to:
  /// **'Kısa Ezan'**
  String get soundNameShortAdhan;

  /// No description provided for @soundNameNatureBell.
  ///
  /// In tr, this message translates to:
  /// **'Doğa Zili'**
  String get soundNameNatureBell;

  /// No description provided for @soundNameGentleChime.
  ///
  /// In tr, this message translates to:
  /// **'Nazik Çan'**
  String get soundNameGentleChime;

  /// No description provided for @soundNameQanun.
  ///
  /// In tr, this message translates to:
  /// **'Qanun / Str'**
  String get soundNameQanun;

  /// No description provided for @soundNameSingle8.
  ///
  /// In tr, this message translates to:
  /// **'Tek Nota 8-bit'**
  String get soundNameSingle8;

  /// No description provided for @soundNameTwoNoteA.
  ///
  /// In tr, this message translates to:
  /// **'İki Nota A'**
  String get soundNameTwoNoteA;

  /// No description provided for @soundNameTwoNoteB.
  ///
  /// In tr, this message translates to:
  /// **'İki Nota B'**
  String get soundNameTwoNoteB;

  /// No description provided for @soundNameSoftMix.
  ///
  /// In tr, this message translates to:
  /// **'Yumuşak Karışık'**
  String get soundNameSoftMix;

  /// No description provided for @soundNameWarm8bitAlt.
  ///
  /// In tr, this message translates to:
  /// **'Sıcak 8-bit (Alternatif)'**
  String get soundNameWarm8bitAlt;

  /// No description provided for @soundNameClearSound.
  ///
  /// In tr, this message translates to:
  /// **'Net Uzun Ses'**
  String get soundNameClearSound;

  /// No description provided for @soundNameSystemAlarm.
  ///
  /// In tr, this message translates to:
  /// **'Sistem Alarmı'**
  String get soundNameSystemAlarm;

  /// No description provided for @soundNameSystemNotification.
  ///
  /// In tr, this message translates to:
  /// **'Sistem Bildirimi'**
  String get soundNameSystemNotification;

  /// No description provided for @soundNameSystemRingtone.
  ///
  /// In tr, this message translates to:
  /// **'Sistem Zil Sesi'**
  String get soundNameSystemRingtone;

  /// No description provided for @soundDesc_softBell.
  ///
  /// In tr, this message translates to:
  /// **'Yumuşak ve sakin bir zil sesi'**
  String get soundDesc_softBell;

  /// No description provided for @soundDesc_softBellAlt.
  ///
  /// In tr, this message translates to:
  /// **'Yumuşak zil (alternatif versiyon)'**
  String get soundDesc_softBellAlt;

  /// No description provided for @soundDesc_shortAdhan.
  ///
  /// In tr, this message translates to:
  /// **'Kısa ezan melodisi'**
  String get soundDesc_shortAdhan;

  /// No description provided for @soundDesc_natureBell.
  ///
  /// In tr, this message translates to:
  /// **'Doğal ses efektli zil'**
  String get soundDesc_natureBell;

  /// No description provided for @soundDesc_gentleChime.
  ///
  /// In tr, this message translates to:
  /// **'Nazik ve melodik çan sesi'**
  String get soundDesc_gentleChime;

  /// No description provided for @soundDesc_qanun.
  ///
  /// In tr, this message translates to:
  /// **'Qanun tarzı melodik parça'**
  String get soundDesc_qanun;

  /// No description provided for @soundDesc_single8.
  ///
  /// In tr, this message translates to:
  /// **'Tek nota, 8-bit tarzı kısa ses'**
  String get soundDesc_single8;

  /// No description provided for @soundDesc_twoNoteA.
  ///
  /// In tr, this message translates to:
  /// **'İki notalı A varyasyonu'**
  String get soundDesc_twoNoteA;

  /// No description provided for @soundDesc_twoNoteB.
  ///
  /// In tr, this message translates to:
  /// **'İki notalı B varyasyonu'**
  String get soundDesc_twoNoteB;

  /// No description provided for @soundDesc_softMix.
  ///
  /// In tr, this message translates to:
  /// **'Karışık yumuşak ses efekti'**
  String get soundDesc_softMix;

  /// No description provided for @soundDesc_warm8bitAlt.
  ///
  /// In tr, this message translates to:
  /// **'Sıcak 8-bit alternatifi'**
  String get soundDesc_warm8bitAlt;

  /// No description provided for @soundDesc_clearSound.
  ///
  /// In tr, this message translates to:
  /// **'Net ve temiz bir bildirim sesi'**
  String get soundDesc_clearSound;

  /// No description provided for @soundDesc_systemAlarm.
  ///
  /// In tr, this message translates to:
  /// **'Cihazın alarm sesi'**
  String get soundDesc_systemAlarm;

  /// No description provided for @soundDesc_systemNotification.
  ///
  /// In tr, this message translates to:
  /// **'Cihazın bildirim tonu'**
  String get soundDesc_systemNotification;

  /// No description provided for @soundDesc_systemRingtone.
  ///
  /// In tr, this message translates to:
  /// **'Cihazın zil sesi (ringtone)'**
  String get soundDesc_systemRingtone;

  /// No description provided for @notificationTitleOnTime.
  ///
  /// In tr, this message translates to:
  /// **'Vakit: {prayerName}'**
  String notificationTitleOnTime(String prayerName);

  /// No description provided for @notificationBodyOnTime.
  ///
  /// In tr, this message translates to:
  /// **'Saat {time}'**
  String notificationBodyOnTime(String time);

  /// No description provided for @notificationTitlePre.
  ///
  /// In tr, this message translates to:
  /// **'Yaklaşıyor: {prayerName}'**
  String notificationTitlePre(String prayerName);

  /// No description provided for @notificationBodyPre.
  ///
  /// In tr, this message translates to:
  /// **'{minutes} dk kaldı'**
  String notificationBodyPre(int minutes);

  /// No description provided for @mosquePickerTitle.
  ///
  /// In tr, this message translates to:
  /// **'CAMİ SEÇİN'**
  String get mosquePickerTitle;

  /// No description provided for @mosquePickerSelectFromGallery.
  ///
  /// In tr, this message translates to:
  /// **'Galeriden Seç'**
  String get mosquePickerSelectFromGallery;

  /// No description provided for @mosquePickerSaveMosque.
  ///
  /// In tr, this message translates to:
  /// **'Camiyi Kaydet'**
  String get mosquePickerSaveMosque;

  /// No description provided for @mosquePickerNote.
  ///
  /// In tr, this message translates to:
  /// **'• Kaydettiğiniz camiler listede görünecek'**
  String get mosquePickerNote;

  /// No description provided for @mosquePickerImageError.
  ///
  /// In tr, this message translates to:
  /// **'Resim seçilemedi: {error}'**
  String mosquePickerImageError(String error);

  /// No description provided for @mosquePickerAddNewLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yeni camii'**
  String get mosquePickerAddNewLabel;

  /// No description provided for @mosquePickerNoSaved.
  ///
  /// In tr, this message translates to:
  /// **'Henüz kayıtlı cami yok'**
  String get mosquePickerNoSaved;

  /// No description provided for @mosquePickerAddNewTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Cami Ekle'**
  String get mosquePickerAddNewTitle;

  /// No description provided for @mosquePickerOptional.
  ///
  /// In tr, this message translates to:
  /// **'(İsteğe bağlı)'**
  String get mosquePickerOptional;

  /// No description provided for @mosquePickerFirstVisit.
  ///
  /// In tr, this message translates to:
  /// **'İlk ziyaret: {day}/{month}/{year}'**
  String mosquePickerFirstVisit(Object day, Object month, Object year);

  /// No description provided for @mosquePickerInfoLabel.
  ///
  /// In tr, this message translates to:
  /// **'Bilgi'**
  String get mosquePickerInfoLabel;

  /// No description provided for @mosquePickerNameExists.
  ///
  /// In tr, this message translates to:
  /// **'Bu isimde bir cami zaten kayıtlı'**
  String get mosquePickerNameExists;

  /// No description provided for @mosquePickerNameUnique.
  ///
  /// In tr, this message translates to:
  /// **'• Aynı isimde cami ekleyemezsiniz'**
  String get mosquePickerNameUnique;

  /// No description provided for @mosquePickerEnterName.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen cami adını girin'**
  String get mosquePickerEnterName;

  /// No description provided for @mosquePickerNameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Cami Adı'**
  String get mosquePickerNameLabel;

  /// No description provided for @mosquePickerHintExample.
  ///
  /// In tr, this message translates to:
  /// **'Örn: Merkez Cami'**
  String get mosquePickerHintExample;

  /// No description provided for @statisticsError.
  ///
  /// In tr, this message translates to:
  /// **'Hata: {error}'**
  String statisticsError(String error);

  /// No description provided for @statisticsToday.
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get statisticsToday;

  /// No description provided for @statisticsWeek.
  ///
  /// In tr, this message translates to:
  /// **'Bu Hafta'**
  String get statisticsWeek;

  /// No description provided for @statisticsMonth.
  ///
  /// In tr, this message translates to:
  /// **'Bu Ay'**
  String get statisticsMonth;

  /// No description provided for @statisticsAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get statisticsAll;

  /// No description provided for @statisticsTotal.
  ///
  /// In tr, this message translates to:
  /// **'Toplam'**
  String get statisticsTotal;

  /// No description provided for @statisticsCongregation.
  ///
  /// In tr, this message translates to:
  /// **'Cemaat'**
  String get statisticsCongregation;

  /// No description provided for @statisticsMakeup.
  ///
  /// In tr, this message translates to:
  /// **'Kaza'**
  String get statisticsMakeup;

  /// No description provided for @statisticsMissed.
  ///
  /// In tr, this message translates to:
  /// **'Kaçırılan'**
  String get statisticsMissed;

  /// No description provided for @dialogCancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get dialogCancel;

  /// No description provided for @dialogSave.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get dialogSave;

  /// No description provided for @dialogClose.
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get dialogClose;

  /// No description provided for @dialogSelect.
  ///
  /// In tr, this message translates to:
  /// **'Seç'**
  String get dialogSelect;

  /// No description provided for @dialogOk.
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get dialogOk;

  /// No description provided for @dialogYes.
  ///
  /// In tr, this message translates to:
  /// **'Evet'**
  String get dialogYes;

  /// No description provided for @dialogNo.
  ///
  /// In tr, this message translates to:
  /// **'Hayır'**
  String get dialogNo;

  /// No description provided for @dialogBack.
  ///
  /// In tr, this message translates to:
  /// **'Geri'**
  String get dialogBack;

  /// No description provided for @loading.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In tr, this message translates to:
  /// **'Hata'**
  String get error;

  /// No description provided for @success.
  ///
  /// In tr, this message translates to:
  /// **'Başarılı'**
  String get success;

  /// No description provided for @failed.
  ///
  /// In tr, this message translates to:
  /// **'Başarısız'**
  String get failed;

  /// No description provided for @warning.
  ///
  /// In tr, this message translates to:
  /// **'Uyarı'**
  String get warning;

  /// No description provided for @confirm.
  ///
  /// In tr, this message translates to:
  /// **'Onayla'**
  String get confirm;

  /// No description provided for @completed.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlandı'**
  String get completed;

  /// No description provided for @level.
  ///
  /// In tr, this message translates to:
  /// **'Seviye'**
  String get level;

  /// No description provided for @xp.
  ///
  /// In tr, this message translates to:
  /// **'XP'**
  String get xp;

  /// No description provided for @points.
  ///
  /// In tr, this message translates to:
  /// **'Puan'**
  String get points;

  /// No description provided for @streak.
  ///
  /// In tr, this message translates to:
  /// **'Seri'**
  String get streak;

  /// No description provided for @statAbbrTotal.
  ///
  /// In tr, this message translates to:
  /// **'TOP'**
  String get statAbbrTotal;

  /// No description provided for @statAbbrCongregation.
  ///
  /// In tr, this message translates to:
  /// **'CEM'**
  String get statAbbrCongregation;

  /// No description provided for @statAbbrActive.
  ///
  /// In tr, this message translates to:
  /// **'AKT'**
  String get statAbbrActive;

  /// No description provided for @statAbbrBest.
  ///
  /// In tr, this message translates to:
  /// **'ENI'**
  String get statAbbrBest;

  /// No description provided for @statAbbrMosques.
  ///
  /// In tr, this message translates to:
  /// **'CAM'**
  String get statAbbrMosques;

  /// No description provided for @statAbbrCards.
  ///
  /// In tr, this message translates to:
  /// **'KRT'**
  String get statAbbrCards;

  /// No description provided for @statAbbrWeekly.
  ///
  /// In tr, this message translates to:
  /// **'HFT'**
  String get statAbbrWeekly;

  /// No description provided for @defaultUser.
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı'**
  String get defaultUser;

  /// No description provided for @progressLabel.
  ///
  /// In tr, this message translates to:
  /// **'İLERLEME'**
  String get progressLabel;

  /// No description provided for @levelAbbr.
  ///
  /// In tr, this message translates to:
  /// **'SEVİYE'**
  String get levelAbbr;

  /// No description provided for @rarityBronze.
  ///
  /// In tr, this message translates to:
  /// **'Bronz'**
  String get rarityBronze;

  /// No description provided for @raritySilver.
  ///
  /// In tr, this message translates to:
  /// **'Gümüş'**
  String get raritySilver;

  /// No description provided for @rarityGold.
  ///
  /// In tr, this message translates to:
  /// **'Altın'**
  String get rarityGold;

  /// No description provided for @rarityPlatinum.
  ///
  /// In tr, this message translates to:
  /// **'Platin'**
  String get rarityPlatinum;

  /// No description provided for @rarityDiamond.
  ///
  /// In tr, this message translates to:
  /// **'Elmas'**
  String get rarityDiamond;

  /// No description provided for @rarityLegendary.
  ///
  /// In tr, this message translates to:
  /// **'Efsanevi'**
  String get rarityLegendary;

  /// No description provided for @rarityMythic.
  ///
  /// In tr, this message translates to:
  /// **'Mitik'**
  String get rarityMythic;

  /// No description provided for @holidayEidAlFitr.
  ///
  /// In tr, this message translates to:
  /// **'Ramazan Bayramı'**
  String get holidayEidAlFitr;

  /// No description provided for @holidayEidAlAdha.
  ///
  /// In tr, this message translates to:
  /// **'Kurban Bayramı'**
  String get holidayEidAlAdha;

  /// No description provided for @holidayMawlid.
  ///
  /// In tr, this message translates to:
  /// **'Mevlid Kandili'**
  String get holidayMawlid;

  /// No description provided for @holidayLailatAlMiraj.
  ///
  /// In tr, this message translates to:
  /// **'Miraç Kandili'**
  String get holidayLailatAlMiraj;

  /// No description provided for @holidayLailatAlBarat.
  ///
  /// In tr, this message translates to:
  /// **'Berat Kandili'**
  String get holidayLailatAlBarat;

  /// No description provided for @holidayLailatAlQadr.
  ///
  /// In tr, this message translates to:
  /// **'Kadir Gecesi'**
  String get holidayLailatAlQadr;

  /// No description provided for @holidayAshura.
  ///
  /// In tr, this message translates to:
  /// **'Aşure Günü'**
  String get holidayAshura;

  /// No description provided for @holidayArafa.
  ///
  /// In tr, this message translates to:
  /// **'Arefe Günü'**
  String get holidayArafa;

  /// No description provided for @holidayRegaib.
  ///
  /// In tr, this message translates to:
  /// **'Regaip Kandili'**
  String get holidayRegaib;

  /// No description provided for @shareSuccess.
  ///
  /// In tr, this message translates to:
  /// **'✅ Paylaşım başarılı!'**
  String get shareSuccess;

  /// No description provided for @shareError.
  ///
  /// In tr, this message translates to:
  /// **'❌ Paylaşım hatası: {error}'**
  String shareError(String error);

  /// No description provided for @shareCompletedSeries.
  ///
  /// In tr, this message translates to:
  /// **'✅ Tamamlanan Seri: {series}'**
  String shareCompletedSeries(String series);

  /// No description provided for @dbSaveProfile.
  ///
  /// In tr, this message translates to:
  /// **'User profile kaydet'**
  String get dbSaveProfile;

  /// No description provided for @dbSaveCard.
  ///
  /// In tr, this message translates to:
  /// **'Kart kaydet'**
  String get dbSaveCard;

  /// No description provided for @dbSaveAllCards.
  ///
  /// In tr, this message translates to:
  /// **'Tüm kartları kaydet'**
  String get dbSaveAllCards;

  /// No description provided for @dbSaveStatistics.
  ///
  /// In tr, this message translates to:
  /// **'İstatistik kaydet'**
  String get dbSaveStatistics;

  /// No description provided for @dbClose.
  ///
  /// In tr, this message translates to:
  /// **'Database\'i kapat'**
  String get dbClose;

  /// No description provided for @debugLoadingComplete.
  ///
  /// In tr, this message translates to:
  /// **'Gamification: Yükleme tamamlandı'**
  String get debugLoadingComplete;

  /// No description provided for @debugProfileError.
  ///
  /// In tr, this message translates to:
  /// **'Gamification profil yükleme hatası: {error}'**
  String debugProfileError(String error);

  /// No description provided for @debugRepoError.
  ///
  /// In tr, this message translates to:
  /// **'Gamification Repository: _getUserProfileFromPrefs hata: {error}'**
  String debugRepoError(String error);

  /// No description provided for @debugSaveError.
  ///
  /// In tr, this message translates to:
  /// **'Gamification Repository: _saveUserProfileToPrefs hata: {error}'**
  String debugSaveError(String error);

  /// No description provided for @storageDescription.
  ///
  /// In tr, this message translates to:
  /// **'Dört durum: kılmadı (none), kaza, kıldı (kilindi), cemaatle.'**
  String get storageDescription;

  /// No description provided for @storageCreateTable.
  ///
  /// In tr, this message translates to:
  /// **'prayer_records'**
  String get storageCreateTable;

  /// No description provided for @storageDeleteOld.
  ///
  /// In tr, this message translates to:
  /// **'30 günden eski kayıtları sil'**
  String get storageDeleteOld;

  /// No description provided for @storageGetRecords.
  ///
  /// In tr, this message translates to:
  /// **'Belirli tarih aralığındaki kayıtları getir'**
  String get storageGetRecords;

  /// No description provided for @storageGetAllRecords.
  ///
  /// In tr, this message translates to:
  /// **'Tüm kayıtları getir'**
  String get storageGetAllRecords;

  /// No description provided for @storageSaveRecord.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt kaydet'**
  String get storageSaveRecord;

  /// No description provided for @storageUpdateRecord.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt güncelle'**
  String get storageUpdateRecord;

  /// No description provided for @storageDeleteRecord.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt sil'**
  String get storageDeleteRecord;

  /// No description provided for @demoCollectionCard.
  ///
  /// In tr, this message translates to:
  /// **'Collection Card Demo'**
  String get demoCollectionCard;

  /// No description provided for @demoModernCard.
  ///
  /// In tr, this message translates to:
  /// **'Modern Card Demo'**
  String get demoModernCard;

  /// No description provided for @demoFloatingGlass.
  ///
  /// In tr, this message translates to:
  /// **'Floating Glass Demo'**
  String get demoFloatingGlass;

  /// No description provided for @demoHolographic.
  ///
  /// In tr, this message translates to:
  /// **'Holographic Demo'**
  String get demoHolographic;

  /// No description provided for @demoNeonOutline.
  ///
  /// In tr, this message translates to:
  /// **'Neon Outline Demo'**
  String get demoNeonOutline;

  /// No description provided for @demoPixelCard.
  ///
  /// In tr, this message translates to:
  /// **'Pixel Card Demo'**
  String get demoPixelCard;

  /// No description provided for @demoPixelFrame.
  ///
  /// In tr, this message translates to:
  /// **'Pixel Frame Demo'**
  String get demoPixelFrame;

  /// No description provided for @demoCardShowcase.
  ///
  /// In tr, this message translates to:
  /// **'Card Showcase Demo'**
  String get demoCardShowcase;

  /// No description provided for @raritySiradan.
  ///
  /// In tr, this message translates to:
  /// **'Sıradan'**
  String get raritySiradan;

  /// No description provided for @rarityNadir.
  ///
  /// In tr, this message translates to:
  /// **'Nadir'**
  String get rarityNadir;

  /// No description provided for @rarityPro.
  ///
  /// In tr, this message translates to:
  /// **'Pro'**
  String get rarityPro;

  /// No description provided for @rarityGizemli.
  ///
  /// In tr, this message translates to:
  /// **'Gizemli'**
  String get rarityGizemli;

  /// No description provided for @rarityEfsane.
  ///
  /// In tr, this message translates to:
  /// **'Efsane'**
  String get rarityEfsane;

  /// No description provided for @rarityEpik.
  ///
  /// In tr, this message translates to:
  /// **'Epik'**
  String get rarityEpik;

  /// No description provided for @rarityTunc.
  ///
  /// In tr, this message translates to:
  /// **'Tunç'**
  String get rarityTunc;

  /// No description provided for @rarityGumus.
  ///
  /// In tr, this message translates to:
  /// **'Gümüş'**
  String get rarityGumus;

  /// No description provided for @rarityAltin.
  ///
  /// In tr, this message translates to:
  /// **'Altın'**
  String get rarityAltin;

  /// No description provided for @rarityPlatin.
  ///
  /// In tr, this message translates to:
  /// **'Platin'**
  String get rarityPlatin;

  /// No description provided for @rarityElmas.
  ///
  /// In tr, this message translates to:
  /// **'Elmas'**
  String get rarityElmas;

  /// No description provided for @rarityNur.
  ///
  /// In tr, this message translates to:
  /// **'Nûr'**
  String get rarityNur;

  /// No description provided for @raritySidre.
  ///
  /// In tr, this message translates to:
  /// **'Sidre'**
  String get raritySidre;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'tr',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
