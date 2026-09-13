// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get navigationPrayerTimes => '时间';

  @override
  String get searchHintCityCountry => 'Şehir, Ülke';

  @override
  String get navigationTracker => '跟踪';

  @override
  String get navigationQibla => '朝拜方向';

  @override
  String get navigationLevel => '等级';

  @override
  String get navigationProfile => '个人资料';

  @override
  String get screenTitlePrayerTimes => '祈祷时间';

  @override
  String get screenTitlePrayerTracker => '祈祷跟踪';

  @override
  String get screenTitleQiblaCompass => '朝拜方向指南针';

  @override
  String get screenTitleLevel => '我的等级';

  @override
  String get screenTitleProfile => '个人资料';

  @override
  String get screenTitleNotificationSettings => '通知设置';

  @override
  String get screenTitleSplash => 'Prayly';

  @override
  String get prayerTimesRemainingTime => '剩余时间';

  @override
  String get prayerTimesLocation => '位置';

  @override
  String get prayerTimesAutomatic => '自动';

  @override
  String get prayerTimesHide => '隐藏';

  @override
  String get prayerTimesCity => '城市';

  @override
  String get prayerTimesLoading => '加载中';

  @override
  String get prayerTimesNoResults => '未找到结果';

  @override
  String prayerTimesError(String error) {
    return '错误：$error';
  }

  @override
  String prayerTimesLocationText(String city, String country) {
    return '位置：$city，$country';
  }

  @override
  String get prayerTimesLocationGPS => '位置：设备GPS';

  @override
  String get prayerFajr => '晨礼';

  @override
  String get prayerMorning => '黎明';

  @override
  String get prayerSunrise => '日出';

  @override
  String get prayerDhuhr => '晌礼';

  @override
  String get prayerAsr => '晡礼';

  @override
  String get prayerMaghrib => '昏礼';

  @override
  String get prayerIsha => '宵礼';

  @override
  String get trackerSelectDate => '选择日期';

  @override
  String get trackerCancel => '取消';

  @override
  String get trackerSelect => '选择';

  @override
  String get trackerToday => '今天';

  @override
  String get trackerYesterday => '昨天';

  @override
  String get trackerHint => '点击祈祷以进行详细跟踪';

  @override
  String trackerCompleted(int completed, int total) {
    return '$completed / $total 已完成';
  }

  @override
  String get trackerDialogHint => '点击祈祷进行详细跟踪';

  @override
  String trackerPrayerName(String prayerName) {
    return '$prayerName 祈祷';
  }

  @override
  String get trackerSelectStatus => '选择状态：';

  @override
  String get trackerWhere => '您在哪里祈祷？';

  @override
  String get trackerLocationAtHome => '在家';

  @override
  String get trackerLocationAtMosque => '在清真寺';

  @override
  String get locationAtHome => 'At home';

  @override
  String get locationAtMosque => 'At mosque';

  @override
  String get statusNotPrayed => '未祈祷';

  @override
  String get statusMakeup => '补祈';

  @override
  String get statusPrayed => '已祈祷';

  @override
  String get statusCongregation => '集体';

  @override
  String get qiblaPermissionRequired => '需要位置权限来计算朝拜方向';

  @override
  String get qiblaServiceDisabled => '位置服务已禁用。请启用GPS/位置服务';

  @override
  String qiblaLocationError(String error) {
    return '无法获取位置：$error';
  }

  @override
  String get qiblaPermissionDenied => '位置权限被拒绝。请从设置中授予权限';

  @override
  String get qiblaPermissionPermanentlyDenied => '位置权限被永久拒绝。请从设置中授予权限';

  @override
  String qiblaPermissionError(String error) {
    return '获取权限时出错：$error';
  }

  @override
  String get qiblaGrantPermission => '授予权限';

  @override
  String get qiblaOpenSettings => '打开设置';

  @override
  String get qiblaRefresh => '刷新';

  @override
  String get qiblaDeviceDirection => '设备方向';

  @override
  String get qiblaNorth => '北';

  @override
  String get qiblaSouth => '南';

  @override
  String get qiblaEast => '东';

  @override
  String get qiblaWest => '西';

  @override
  String get qiblaPermissionPrompt => '请授予位置权限';

  @override
  String get qiblaDirectionReading => '方向读数';

  @override
  String get qiblaWaitingLocation => '等待位置...';

  @override
  String get qiblaCompassSensorUnavailable => '指南针传感器不可用';

  @override
  String get qiblaPullToRefresh => '下拉刷新';

  @override
  String get qiblaDirectionWaiting => '等待中...';

  @override
  String get qiblaAligned => '已对准';

  @override
  String get qiblaTurnRight => '向右转';

  @override
  String get qiblaTurnLeft => '向左转';

  @override
  String get weekdayMonday => '星期一';

  @override
  String get weekdayTuesday => '星期二';

  @override
  String get weekdayWednesday => '星期三';

  @override
  String get weekdayThursday => '星期四';

  @override
  String get weekdayFriday => '星期五';

  @override
  String get weekdaySaturday => '星期六';

  @override
  String get weekdaySunday => '星期日';

  @override
  String profileXpToNextLevel(int level, int xp) {
    return '等级 $level — 还需 $xp XP 到下一级';
  }

  @override
  String get profileUser => '用户';

  @override
  String get profileChangeAvatar => '点击更改个人头像';

  @override
  String get profileThemeSettings => '主题设置';

  @override
  String get profileThemeLight => '浅色';

  @override
  String get profileThemeDark => '深色';

  @override
  String get profileThemeAmoled => 'AMOLED';

  @override
  String get profileThemeSystem => '系统';

  @override
  String get profileNotifications => '通知';

  @override
  String get profileNotificationSettings => '通知设置';

  @override
  String get profileClose => '关闭';

  @override
  String get profileSelectFromGallery => '从相册选择';

  @override
  String profileImageError(String error) {
    return '选择图片时出错：$error';
  }

  @override
  String get profileSave => '保存';

  @override
  String get gamificationProfile => '个人资料';

  @override
  String get gamificationCards => '卡片';

  @override
  String get gamificationStatistics => '统计';

  @override
  String get statisticsTitle => '统计';

  @override
  String get statisticsTabWeekly => '每周';

  @override
  String get statisticsTabMonthly => '每月';

  @override
  String get statisticsTabYearly => '每年';

  @override
  String get statisticsSquares => '方格';

  @override
  String get statisticsSummary => '摘要';

  @override
  String get statisticsOverall => '总体分布';

  @override
  String get statisticsMiniLabelDone => '已完成';

  @override
  String get statisticsMiniLabelCongregation => '集体';

  @override
  String get statisticsMiniLabelMakeup => '补祈';

  @override
  String get statisticsMiniLabelNotPrayed => '未祈祷';

  @override
  String get statisticsLast7Days => '过去7天';

  @override
  String get statisticsLast30Days => '过去30天';

  @override
  String get statisticsLast365Days => '过去365天';

  @override
  String get gamificationErrorLoading => '加载个人资料时出现问题';

  @override
  String get gamificationPleaseRestart => '请重新启动应用。';

  @override
  String get activeStreaks => '活跃连胜';

  @override
  String get daysUnit => '天';

  @override
  String cardsCollection(Object count) {
    return '卡片收藏 ($count)';
  }

  @override
  String get cardsDistribution => '卡片分布';

  @override
  String get categoryDaily => '每日祈祷';

  @override
  String get categoryFriday => '周五祈祷';

  @override
  String get categoryKandil => '坎迪尔之夜';

  @override
  String get categoryEid => '开斋节/宰牲节';

  @override
  String get categoryMosque => '清真寺发现';

  @override
  String get categoryMilestone => '里程碑';

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
  String get cardCountUnit => '张';

  @override
  String get statsFailedToLoad => '统计信息加载失败';

  @override
  String get generalStatistics => '总体统计';

  @override
  String get statTotalPrayers => '总祈祷次数';

  @override
  String get statCongregationPrayers => '集体祈祷';

  @override
  String get statBestStreak => '最长连胜';

  @override
  String get statWeeklyXp => '本周 XP';

  @override
  String get detailProgress => '进度';

  @override
  String get detailXpContribution => 'XP 贡献';

  @override
  String get detailRarityScore => '稀有度分数';

  @override
  String get detailNextThreshold => '下一个阈值';

  @override
  String get gamificationErrorRestart => '请重启应用程序';

  @override
  String get gamificationLoading => '我的等级';

  @override
  String get gamificationClose => '关闭';

  @override
  String get milestoneFirstStep => '第一步';

  @override
  String get milestoneRegular => '常规';

  @override
  String get milestoneDetermined => '坚定';

  @override
  String get milestoneDevoted => '虔诚';

  @override
  String get milestoneFirstCongregation => '第一次集体';

  @override
  String get milestoneCongregationLover => '集体爱好者';

  @override
  String get milestoneCongregationMaster => '集体大师';

  @override
  String get milestoneFirstMosque => '第一次访问';

  @override
  String get milestoneMosqueExplorer => '清真寺探索者';

  @override
  String get milestoneRamadanWarrior => '斋月战士';

  @override
  String get milestoneNightOwl => '夜猫子';

  @override
  String get milestoneEarlyRiser => '早起者';

  @override
  String get milestoneDescFirstPrayer => '您记录了第一次祈祷';

  @override
  String get milestoneDesc10Prayers => '您记录了10次祈祷';

  @override
  String get milestoneDesc50Prayers => '您记录了50次祈祷';

  @override
  String get milestoneDesc100Prayers => '您记录了100次祈祷';

  @override
  String get milestoneDescFirstCongregation => '您记录了第一次集体祈祷';

  @override
  String get milestoneDesc25Congregation => '您记录了25次集体祈祷';

  @override
  String get milestoneDesc100Congregation => '您记录了100次集体祈祷';

  @override
  String get milestoneDescFirstMosque => '您记录了第一次清真寺访问';

  @override
  String get questComplete5Prayers => '完成5次祈祷';

  @override
  String get quest3Congregation => '3次集体';

  @override
  String get questFridayPrayer => '主麻祈祷';

  @override
  String get quest20Congregation => '集体周';

  @override
  String get quest7DaysStreak => '7天连续';

  @override
  String get questDescComplete5 => '今天记录5次祈祷';

  @override
  String get questDesc3Congregation => '今天记录3次集体祈祷';

  @override
  String get questDescFriday => '本周记录主麻祈祷';

  @override
  String get questDesc20Congregation => '本周记录20次集体祈祷';

  @override
  String get questDesc7Days => '本周连续7天记录祈祷';

  @override
  String get notificationSelectSound => '选择';

  @override
  String get notificationDefaultSound => '选择的声音将用作所有通知的默认声音。您可以为每次祈祷设置不同的声音。';

  @override
  String get notificationSoundPicker => '选择通知声音';

  @override
  String get notificationSoundNote => '您选择的声音将用作所有通知的默认声音';

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
  String get soundSystem => '系统';

  @override
  String get soundSoft1 => '柔和1';

  @override
  String get soundSoft2 => '柔和2';

  @override
  String get soundCheerful => '欢快';

  @override
  String get soundQanun => '卡农';

  @override
  String get soundSingle => '单音';

  @override
  String get soundAiry => '空灵';

  @override
  String get soundTwoNote => '双音';

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
  String get mosquePickerTitle => '选择清真寺';

  @override
  String get mosquePickerSelectFromGallery => '从相册选择';

  @override
  String get mosquePickerSaveMosque => '保存清真寺';

  @override
  String get mosquePickerNote => '• 您保存的清真寺将出现在列表中';

  @override
  String mosquePickerImageError(String error) {
    return '无法选择图片：$error';
  }

  @override
  String get mosquePickerAddNewLabel => '新 清真寺 +';

  @override
  String get mosquePickerNoSaved => '尚无已保存的清真寺';

  @override
  String get mosquePickerAddNewTitle => '添加新清真寺';

  @override
  String get mosquePickerOptional => '(可选)';

  @override
  String mosquePickerFirstVisit(Object day, Object month, Object year) {
    return '首次访问：$day/$month/$year';
  }

  @override
  String get mosquePickerInfoLabel => '信息';

  @override
  String get mosquePickerNameExists => '具有此名称的清真寺已存在';

  @override
  String get mosquePickerNameUnique => '• 您不能添加具有相同名称的清真寺';

  @override
  String get mosquePickerEnterName => 'Please enter mosque name';

  @override
  String get mosquePickerNameLabel => 'Mosque Name';

  @override
  String get mosquePickerHintExample => 'e.g. Central Mosque';

  @override
  String statisticsError(String error) {
    return '错误：$error';
  }

  @override
  String get statisticsToday => '今天';

  @override
  String get statisticsWeek => '本周';

  @override
  String get statisticsMonth => '本月';

  @override
  String get statisticsAll => '全部';

  @override
  String get statisticsTotal => '总计';

  @override
  String get statisticsCongregation => '集体';

  @override
  String get statisticsMakeup => '补祈';

  @override
  String get statisticsMissed => '错过';

  @override
  String get dialogCancel => '取消';

  @override
  String get dialogSave => '保存';

  @override
  String get dialogClose => '关闭';

  @override
  String get dialogSelect => '选择';

  @override
  String get dialogOk => '确定';

  @override
  String get dialogYes => '是';

  @override
  String get dialogNo => '否';

  @override
  String get dialogBack => '返回';

  @override
  String get loading => '加载中...';

  @override
  String get error => '错误';

  @override
  String get success => '成功';

  @override
  String get failed => '失败';

  @override
  String get warning => '警告';

  @override
  String get confirm => '确认';

  @override
  String get completed => '已完成';

  @override
  String get level => '等级';

  @override
  String get xp => '经验值';

  @override
  String get points => '积分';

  @override
  String get streak => '连击';

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
  String get rarityBronze => '青铜';

  @override
  String get raritySilver => '白银';

  @override
  String get rarityGold => '黄金';

  @override
  String get rarityPlatinum => '铂金';

  @override
  String get rarityDiamond => '钻石';

  @override
  String get rarityLegendary => '传奇';

  @override
  String get rarityMythic => '神话';

  @override
  String get holidayEidAlFitr => '开斋节';

  @override
  String get holidayEidAlAdha => '古尔邦节';

  @override
  String get holidayMawlid => '圣纪节';

  @override
  String get holidayLailatAlMiraj => '登霄节';

  @override
  String get holidayLailatAlBarat => '中夜节';

  @override
  String get holidayLailatAlQadr => '盖德尔夜';

  @override
  String get holidayAshura => '阿舒拉日';

  @override
  String get holidayArafa => '阿拉法日';

  @override
  String get holidayRegaib => '拉杰布夜';

  @override
  String get shareSuccess => '✅ 分享成功！';

  @override
  String shareError(String error) {
    return '❌ 分享错误：$error';
  }

  @override
  String shareCompletedSeries(String series) {
    return '✅ 完成系列：$series';
  }

  @override
  String get dbSaveProfile => '保存用户资料';

  @override
  String get dbSaveCard => '保存卡片';

  @override
  String get dbSaveAllCards => '保存所有卡片';

  @override
  String get dbSaveStatistics => '保存统计';

  @override
  String get dbClose => '关闭数据库';

  @override
  String get debugLoadingComplete => '游戏化：加载完成';

  @override
  String debugProfileError(String error) {
    return '游戏化资料加载错误：$error';
  }

  @override
  String debugRepoError(String error) {
    return '游戏化仓库：_getUserProfileFromPrefs错误：$error';
  }

  @override
  String debugSaveError(String error) {
    return '游戏化仓库：_saveUserProfileToPrefs错误：$error';
  }

  @override
  String get storageDescription => '四种状态：未祈祷（无），补祈，已祈祷，集体。';

  @override
  String get storageCreateTable => 'prayer_records';

  @override
  String get storageDeleteOld => '删除30天以上的记录';

  @override
  String get storageGetRecords => '获取特定日期范围的记录';

  @override
  String get storageGetAllRecords => '获取所有记录';

  @override
  String get storageSaveRecord => '保存记录';

  @override
  String get storageUpdateRecord => '更新记录';

  @override
  String get storageDeleteRecord => '删除记录';

  @override
  String get demoCollectionCard => '收藏卡片演示';

  @override
  String get demoModernCard => '现代卡片演示';

  @override
  String get demoFloatingGlass => '浮动玻璃演示';

  @override
  String get demoHolographic => '全息演示';

  @override
  String get demoNeonOutline => '霓虹轮廓演示';

  @override
  String get demoPixelCard => '像素卡片演示';

  @override
  String get demoPixelFrame => '像素框架演示';

  @override
  String get demoCardShowcase => '卡片展示演示';

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
