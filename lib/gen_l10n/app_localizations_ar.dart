// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get navigationPrayerTimes => 'المواقيت';

  @override
  String get searchHintCityCountry => 'Şehir, Ülke';

  @override
  String get navigationTracker => 'المتابعة';

  @override
  String get navigationQibla => 'القبلة';

  @override
  String get navigationLevel => 'المستوى';

  @override
  String get navigationProfile => 'الملف الشخصي';

  @override
  String get screenTitlePrayerTimes => 'مواقيت الصلاة';

  @override
  String get screenTitlePrayerTracker => 'متابعة الصلاة';

  @override
  String get screenTitleQiblaCompass => 'بوصلة القبلة';

  @override
  String get screenTitleLevel => 'مستواي';

  @override
  String get screenTitleProfile => 'الملف الشخصي';

  @override
  String get screenTitleNotificationSettings => 'إعدادات الإشعارات';

  @override
  String get screenTitleSplash => 'Prayly';

  @override
  String get prayerTimesRemainingTime => 'الوقت المتبقي';

  @override
  String get prayerTimesLocation => 'الموقع';

  @override
  String get prayerTimesAutomatic => 'تلقائي';

  @override
  String get prayerTimesHide => 'إخفاء';

  @override
  String get prayerTimesCity => 'المدينة';

  @override
  String get prayerTimesLoading => 'جاري التحميل';

  @override
  String get prayerTimesNoResults => 'لم يتم العثور على نتائج';

  @override
  String prayerTimesError(String error) {
    return 'خطأ: $error';
  }

  @override
  String prayerTimesLocationText(String city, String country) {
    return 'الموقع: $city، $country';
  }

  @override
  String get prayerTimesLocationGPS => 'الموقع: GPS الجهاز';

  @override
  String get prayerFajr => 'الفجر';

  @override
  String get prayerMorning => 'الصبح';

  @override
  String get prayerSunrise => 'الشروق';

  @override
  String get prayerDhuhr => 'الظهر';

  @override
  String get prayerAsr => 'العصر';

  @override
  String get prayerMaghrib => 'المغرب';

  @override
  String get prayerIsha => 'العشاء';

  @override
  String get trackerSelectDate => 'اختر التاريخ';

  @override
  String get trackerCancel => 'إلغاء';

  @override
  String get trackerSelect => 'اختر';

  @override
  String get trackerToday => 'اليوم';

  @override
  String get trackerYesterday => 'أمس';

  @override
  String get trackerHint => 'اضغط على الصلاة لمتابعتها بالتفصيل';

  @override
  String trackerCompleted(int completed, int total) {
    return '$completed / $total مكتملة';
  }

  @override
  String get trackerDialogHint => 'اضغط على الصلاة للمتابعة التفصيلية';

  @override
  String trackerPrayerName(String prayerName) {
    return 'صلاة $prayerName';
  }

  @override
  String get trackerSelectStatus => 'اختر الحالة:';

  @override
  String get trackerWhere => 'أين صليت؟';

  @override
  String get trackerLocationAtHome => 'بالمنزل';

  @override
  String get trackerLocationAtMosque => 'في المسجد';

  @override
  String get locationAtHome => 'بالمنزل';

  @override
  String get locationAtMosque => 'في المسجد';

  @override
  String get statusNotPrayed => 'لم يصل';

  @override
  String get statusMakeup => 'قضاء';

  @override
  String get statusPrayed => 'صلى';

  @override
  String get statusCongregation => 'جماعة';

  @override
  String get qiblaPermissionRequired => 'مطلوب إذن الموقع لحساب اتجاه القبلة';

  @override
  String get qiblaServiceDisabled =>
      'خدمة الموقع معطلة. يرجى تفعيل خدمة GPS/الموقع';

  @override
  String qiblaLocationError(String error) {
    return 'لا يمكن الحصول على الموقع: $error';
  }

  @override
  String get qiblaPermissionDenied =>
      'تم رفض إذن الموقع. يرجى منح الإذن من الإعدادات';

  @override
  String get qiblaPermissionPermanentlyDenied =>
      'تم رفض إذن الموقع نهائياً. يرجى منح الإذن من الإعدادات';

  @override
  String qiblaPermissionError(String error) {
    return 'خطأ في الحصول على الإذن: $error';
  }

  @override
  String get qiblaGrantPermission => 'منح الإذن';

  @override
  String get qiblaOpenSettings => 'فتح الإعدادات';

  @override
  String get qiblaRefresh => 'تحديث';

  @override
  String get qiblaDeviceDirection => 'اتجاه الجهاز';

  @override
  String get qiblaNorth => 'شمال';

  @override
  String get qiblaSouth => 'جنوب';

  @override
  String get qiblaEast => 'شرق';

  @override
  String get qiblaWest => 'غرب';

  @override
  String get qiblaPermissionPrompt => 'الرجاء منح إذن الموقع';

  @override
  String get qiblaDirectionReading => 'قراءة الاتجاه';

  @override
  String get qiblaWaitingLocation => 'انتظار الموقع...';

  @override
  String get qiblaCompassSensorUnavailable => 'مستشعر البوصلة غير متاح';

  @override
  String get qiblaPullToRefresh => 'اسحب للتحديث';

  @override
  String get qiblaDirectionWaiting => 'انتظار...';

  @override
  String get qiblaAligned => 'متجه';

  @override
  String get qiblaTurnRight => 'استدر يمينًا';

  @override
  String get qiblaTurnLeft => 'استدر يسارًا';

  @override
  String get weekdayMonday => 'الاثنين';

  @override
  String get weekdayTuesday => 'الثلاثاء';

  @override
  String get weekdayWednesday => 'الأربعاء';

  @override
  String get weekdayThursday => 'الخميس';

  @override
  String get weekdayFriday => 'الجمعة';

  @override
  String get weekdaySaturday => 'السبت';

  @override
  String get weekdaySunday => 'الأحد';

  @override
  String profileXpToNextLevel(int level, int xp) {
    return 'المستوى $level — $xp XP إلى المستوى التالي';
  }

  @override
  String get profileUser => 'المستخدم';

  @override
  String get profileChangeAvatar => 'اضغط لتغيير صورة الملف الشخصي';

  @override
  String get profileThemeSettings => 'إعدادات المظهر';

  @override
  String get profileThemeLight => 'فاتح';

  @override
  String get profileThemeDark => 'داكن';

  @override
  String get profileThemeAmoled => 'AMOLED';

  @override
  String get profileThemeSystem => 'النظام';

  @override
  String get profileNotifications => 'الإشعارات';

  @override
  String get profileNotificationSettings => 'إعدادات الإشعارات';

  @override
  String get profileClose => 'إغلاق';

  @override
  String get profileSelectFromGallery => 'اختر من المعرض';

  @override
  String profileImageError(String error) {
    return 'خطأ في اختيار الصورة: $error';
  }

  @override
  String get profileSave => 'حفظ';

  @override
  String get gamificationProfile => 'الملف الشخصي';

  @override
  String get gamificationCards => 'البطاقات';

  @override
  String get gamificationStatistics => 'الإحصائيات';

  @override
  String get statisticsTitle => 'الإحصائيات';

  @override
  String get statisticsTabWeekly => 'أسبوعي';

  @override
  String get statisticsTabMonthly => 'شهري';

  @override
  String get statisticsTabYearly => 'سنوي';

  @override
  String get statisticsSquares => 'مربعات';

  @override
  String get statisticsSummary => 'ملخص';

  @override
  String get statisticsOverall => 'التوزيع العام';

  @override
  String get statisticsMiniLabelDone => 'مكتمل';

  @override
  String get statisticsMiniLabelCongregation => 'جماعة';

  @override
  String get statisticsMiniLabelMakeup => 'قضاء';

  @override
  String get statisticsMiniLabelNotPrayed => 'لم يصل';

  @override
  String get statisticsLast7Days => 'آخر 7 أيام';

  @override
  String get statisticsLast30Days => 'آخر 30 يومًا';

  @override
  String get statisticsLast365Days => 'آخر 365 يومًا';

  @override
  String get gamificationErrorLoading => 'مشكلة في تحميل الملف الشخصي';

  @override
  String get gamificationPleaseRestart => 'يرجى إعادة تشغيل التطبيق.';

  @override
  String get activeStreaks => 'سلاسل نشطة';

  @override
  String get daysUnit => 'أيام';

  @override
  String cardsCollection(Object count) {
    return 'مجموعة البطاقات ($count)';
  }

  @override
  String get cardsDistribution => 'توزيع البطاقات';

  @override
  String get categoryDaily => 'صلوات يومية';

  @override
  String get categoryFriday => 'صلوات الجمعة';

  @override
  String get categoryKandil => 'ليالي كانديل';

  @override
  String get categoryEid => 'عطلات العيد';

  @override
  String get categoryMosque => 'استكشاف المسجد';

  @override
  String get categoryMilestone => 'المعالم';

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
  String get cardCountUnit => 'بطاقات';

  @override
  String get statsFailedToLoad => 'فشل تحميل الإحصاءات';

  @override
  String get generalStatistics => 'إحصاءات عامة';

  @override
  String get statTotalPrayers => 'مجموع الصلوات';

  @override
  String get statCongregationPrayers => 'صلوات الجماعة';

  @override
  String get statBestStreak => 'أطول سلسلة';

  @override
  String get statWeeklyXp => 'XP هذا الأسبوع';

  @override
  String get detailProgress => 'التقدم';

  @override
  String get detailXpContribution => 'مساهمة XP';

  @override
  String get detailRarityScore => 'درجة الندرة';

  @override
  String get detailNextThreshold => 'العتبة التالية';

  @override
  String get gamificationErrorRestart => 'يرجى إعادة تشغيل التطبيق';

  @override
  String get gamificationLoading => 'مستواي';

  @override
  String get gamificationClose => 'إغلاق';

  @override
  String get milestoneFirstStep => 'الخطوة الأولى';

  @override
  String get milestoneRegular => 'منتظم';

  @override
  String get milestoneDetermined => 'مصمم';

  @override
  String get milestoneDevoted => 'مخلص';

  @override
  String get milestoneFirstCongregation => 'أول جماعة';

  @override
  String get milestoneCongregationLover => 'محب الجماعة';

  @override
  String get milestoneCongregationMaster => 'أستاذ الجماعة';

  @override
  String get milestoneFirstMosque => 'أول زيارة';

  @override
  String get milestoneMosqueExplorer => 'مستكشف المساجد';

  @override
  String get milestoneRamadanWarrior => 'محارب رمضان';

  @override
  String get milestoneNightOwl => 'بومة الليل';

  @override
  String get milestoneEarlyRiser => 'النهوض المبكر';

  @override
  String get milestoneDescFirstPrayer => 'سجلت صلاتك الأولى';

  @override
  String get milestoneDesc10Prayers => 'سجلت 10 صلوات';

  @override
  String get milestoneDesc50Prayers => 'سجلت 50 صلاة';

  @override
  String get milestoneDesc100Prayers => 'سجلت 100 صلاة';

  @override
  String get milestoneDescFirstCongregation => 'سجلت أول صلاة جماعة';

  @override
  String get milestoneDesc25Congregation => 'سجلت 25 صلاة جماعة';

  @override
  String get milestoneDesc100Congregation => 'سجلت 100 صلاة جماعة';

  @override
  String get milestoneDescFirstMosque => 'سجلت أول زيارة مسجد';

  @override
  String get questComplete5Prayers => 'أكمل 5 صلوات';

  @override
  String get quest3Congregation => '3 جماعات';

  @override
  String get questFridayPrayer => 'صلاة الجمعة';

  @override
  String get quest20Congregation => 'أسبوع الجماعة';

  @override
  String get quest7DaysStreak => 'سلسلة 7 أيام';

  @override
  String get questDescComplete5 => 'سجل 5 صلوات اليوم';

  @override
  String get questDesc3Congregation => 'سجل 3 صلوات جماعة اليوم';

  @override
  String get questDescFriday => 'سجل صلاة الجمعة هذا الأسبوع';

  @override
  String get questDesc20Congregation => 'سجل 20 صلاة جماعة هذا الأسبوع';

  @override
  String get questDesc7Days => 'سجل الصلوات لمدة 7 أيام متتالية هذا الأسبوع';

  @override
  String get notificationSelectSound => 'اختر';

  @override
  String get notificationDefaultSound =>
      'الصوت المختار سيُستخدم كافتراضي لجميع الإشعارات. يمكنك تعيين أصوات مختلفة لكل صلاة.';

  @override
  String get notificationSoundPicker => 'اختر صوت الإشعار';

  @override
  String get notificationSoundNote =>
      'صوتك المختار سيُستخدم كافتراضي لجميع الإشعارات';

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
  String get soundSystem => 'النظام';

  @override
  String get soundSoft1 => 'ناعم 1';

  @override
  String get soundSoft2 => 'ناعم 2';

  @override
  String get soundCheerful => 'مرح';

  @override
  String get soundQanun => 'قانون';

  @override
  String get soundSingle => 'مفرد';

  @override
  String get soundAiry => 'هوائي';

  @override
  String get soundTwoNote => 'نوتتان';

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
  String get mosquePickerTitle => 'اختر المسجد';

  @override
  String get mosquePickerSelectFromGallery => 'اختر من المعرض';

  @override
  String get mosquePickerSaveMosque => 'احفظ المسجد';

  @override
  String get mosquePickerNote => '• المساجد المحفوظة ستظهر في القائمة';

  @override
  String mosquePickerImageError(String error) {
    return 'لا يمكن اختيار الصورة: $error';
  }

  @override
  String get mosquePickerAddNewLabel => 'مسجد جديد +';

  @override
  String get mosquePickerNoSaved => 'لا توجد مساجد محفوظة بعد';

  @override
  String get mosquePickerAddNewTitle => 'إضافة مسجد جديد';

  @override
  String get mosquePickerOptional => '(اختياري)';

  @override
  String mosquePickerFirstVisit(Object day, Object month, Object year) {
    return 'الزيارة الأولى: $day/$month/$year';
  }

  @override
  String get mosquePickerInfoLabel => 'معلومة';

  @override
  String get mosquePickerNameExists => 'مسجد بهذا الاسم موجود بالفعل';

  @override
  String get mosquePickerNameUnique => '• لا يمكنك إضافة مسجد بنفس الاسم';

  @override
  String get mosquePickerEnterName => 'Please enter mosque name';

  @override
  String get mosquePickerNameLabel => 'Mosque Name';

  @override
  String get mosquePickerHintExample => 'e.g. Central Mosque';

  @override
  String statisticsError(String error) {
    return 'خطأ: $error';
  }

  @override
  String get statisticsToday => 'اليوم';

  @override
  String get statisticsWeek => 'هذا الأسبوع';

  @override
  String get statisticsMonth => 'هذا الشهر';

  @override
  String get statisticsAll => 'الكل';

  @override
  String get statisticsTotal => 'المجموع';

  @override
  String get statisticsCongregation => 'جماعة';

  @override
  String get statisticsMakeup => 'قضاء';

  @override
  String get statisticsMissed => 'فائتة';

  @override
  String get dialogCancel => 'إلغاء';

  @override
  String get dialogSave => 'حفظ';

  @override
  String get dialogClose => 'إغلاق';

  @override
  String get dialogSelect => 'اختر';

  @override
  String get dialogOk => 'موافق';

  @override
  String get dialogYes => 'نعم';

  @override
  String get dialogNo => 'لا';

  @override
  String get dialogBack => 'Geri';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get error => 'خطأ';

  @override
  String get success => 'نجح';

  @override
  String get failed => 'فشل';

  @override
  String get warning => 'تحذير';

  @override
  String get confirm => 'تأكيد';

  @override
  String get completed => 'مكتمل';

  @override
  String get level => 'المستوى';

  @override
  String get xp => 'XP';

  @override
  String get points => 'النقاط';

  @override
  String get streak => 'السلسلة';

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
  String get rarityBronze => 'برونزي';

  @override
  String get raritySilver => 'فضي';

  @override
  String get rarityGold => 'ذهبي';

  @override
  String get rarityPlatinum => 'بلاتيني';

  @override
  String get rarityDiamond => 'ماسي';

  @override
  String get rarityLegendary => 'أسطوري';

  @override
  String get rarityMythic => 'خرافي';

  @override
  String get holidayEidAlFitr => 'عيد الفطر';

  @override
  String get holidayEidAlAdha => 'عيد الأضحى';

  @override
  String get holidayMawlid => 'المولد النبوي';

  @override
  String get holidayLailatAlMiraj => 'ليلة الإسراء والمعراج';

  @override
  String get holidayLailatAlBarat => 'ليلة البراءة';

  @override
  String get holidayLailatAlQadr => 'ليلة القدر';

  @override
  String get holidayAshura => 'يوم عاشوراء';

  @override
  String get holidayArafa => 'يوم عرفة';

  @override
  String get holidayRegaib => 'ليلة الرغائب';

  @override
  String get shareSuccess => '✅ المشاركة نجحت!';

  @override
  String shareError(String error) {
    return '❌ خطأ في المشاركة: $error';
  }

  @override
  String shareCompletedSeries(String series) {
    return '✅ السلسلة المكتملة: $series';
  }

  @override
  String get dbSaveProfile => 'حفظ ملف المستخدم';

  @override
  String get dbSaveCard => 'حفظ البطاقة';

  @override
  String get dbSaveAllCards => 'حفظ جميع البطاقات';

  @override
  String get dbSaveStatistics => 'حفظ الإحصائيات';

  @override
  String get dbClose => 'إغلاق قاعدة البيانات';

  @override
  String get debugLoadingComplete => 'التحفيز: التحميل مكتمل';

  @override
  String debugProfileError(String error) {
    return 'خطأ في تحميل ملف التحفيز: $error';
  }

  @override
  String debugRepoError(String error) {
    return 'مستودع التحفيز: خطأ _getUserProfileFromPrefs: $error';
  }

  @override
  String debugSaveError(String error) {
    return 'مستودع التحفيز: خطأ _saveUserProfileToPrefs: $error';
  }

  @override
  String get storageDescription =>
      'أربع حالات: لم يصل (لا شيء)، قضاء، صلى، جماعة.';

  @override
  String get storageCreateTable => 'prayer_records';

  @override
  String get storageDeleteOld => 'حذف السجلات الأقدم من 30 يوماً';

  @override
  String get storageGetRecords => 'الحصول على السجلات لنطاق تاريخ محدد';

  @override
  String get storageGetAllRecords => 'الحصول على جميع السجلات';

  @override
  String get storageSaveRecord => 'حفظ السجل';

  @override
  String get storageUpdateRecord => 'تحديث السجل';

  @override
  String get storageDeleteRecord => 'حذف السجل';

  @override
  String get demoCollectionCard => 'عرض بطاقة المجموعة';

  @override
  String get demoModernCard => 'عرض البطاقة الحديثة';

  @override
  String get demoFloatingGlass => 'عرض الزجاج العائم';

  @override
  String get demoHolographic => 'عرض هولوغرافي';

  @override
  String get demoNeonOutline => 'عرض الخطوط النيون';

  @override
  String get demoPixelCard => 'عرض بطاقة البكسل';

  @override
  String get demoPixelFrame => 'عرض إطار البكسل';

  @override
  String get demoCardShowcase => 'عرض واجهة البطاقات';

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
