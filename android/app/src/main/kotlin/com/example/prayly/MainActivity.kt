package com.example.prayly

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.media.AudioManager
import android.content.Context
import android.app.NotificationManager
import android.content.Intent
import android.provider.Settings
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.app.AlarmManager
import android.app.PendingIntent
import android.os.SystemClock

class MainActivity : FlutterActivity() {
	private val CHANNEL = "device_ringer"
	private var previousMode: Int? = null
	private var previousInterruptionFilter: Int? = null

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)

		// Schedule periodic widget refresh (every 15 minutes)
		setupWidgetRefreshAlarm()

		// Channel for home screen widgets refresh
		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "home_widgets").setMethodCallHandler { call, result ->
			when (call.method) {
				"refreshPrayerTimes" -> {
					refreshPrayerTimesWidgets()
					result.success(null)
				}
				"refreshPrayerTracker" -> {
					refreshPrayerTrackerWidgets()
					result.success(null)
				}
				else -> result.notImplemented()
			}
		}
		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
			val audio = getSystemService(Context.AUDIO_SERVICE) as AudioManager
			val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
			when (call.method) {
				"setMode" -> {
					val mode = call.argument<String>("mode")
					try {
						if (mode == "silent" && !nm.isNotificationPolicyAccessGranted) {
							// Request policy access; send intent so user can grant (cannot auto-grant)
							val intent = Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS)
							intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
							startActivity(intent)
							result.error("NO_PERMISSION", "Notification policy access not granted", null)
							return@setMethodCallHandler
						}
						if (previousMode == null) {
							previousMode = audio.ringerMode
						}
						when (mode) {
							"normal" -> {
								audio.ringerMode = AudioManager.RINGER_MODE_NORMAL
								if (nm.isNotificationPolicyAccessGranted && previousInterruptionFilter != null) {
									nm.setInterruptionFilter(previousInterruptionFilter!!)
									previousInterruptionFilter = null
								} else if (nm.isNotificationPolicyAccessGranted) {
									nm.setInterruptionFilter(NotificationManager.INTERRUPTION_FILTER_ALL)
								}
								result.success(null)
							}
							"vibrate" -> {
								audio.ringerMode = AudioManager.RINGER_MODE_VIBRATE
								if (nm.isNotificationPolicyAccessGranted && previousInterruptionFilter != null) {
									nm.setInterruptionFilter(previousInterruptionFilter!!)
									previousInterruptionFilter = null
								} else if (nm.isNotificationPolicyAccessGranted) {
									nm.setInterruptionFilter(NotificationManager.INTERRUPTION_FILTER_ALL)
								}
								result.success(null)
							}
							"silent" -> {
								audio.ringerMode = AudioManager.RINGER_MODE_SILENT
								if (nm.isNotificationPolicyAccessGranted) {
									if (previousInterruptionFilter == null) {
										previousInterruptionFilter = nm.currentInterruptionFilter
									}
									nm.setInterruptionFilter(NotificationManager.INTERRUPTION_FILTER_NONE)
								}
								result.success(null)
							}
							"restore" -> {
								previousMode?.let { audio.ringerMode = it }
								previousMode = null
								if (nm.isNotificationPolicyAccessGranted && previousInterruptionFilter != null) {
									nm.setInterruptionFilter(previousInterruptionFilter!!)
									previousInterruptionFilter = null
								} else if (nm.isNotificationPolicyAccessGranted) {
									nm.setInterruptionFilter(NotificationManager.INTERRUPTION_FILTER_ALL)
								}
								result.success(null)
							}
							else -> {
								result.error("BAD_MODE", "Unknown mode $mode", null)
							}
						}
					} catch (e: Exception) {
						result.error("FAIL", e.message, null)
					}
				}
				"getMode" -> {
					val current = when (audio.ringerMode) {
						AudioManager.RINGER_MODE_VIBRATE -> "vibrate"
						AudioManager.RINGER_MODE_SILENT -> "silent"
						else -> "normal"
					}
					result.success(current)
				}
				else -> result.notImplemented()
			}
		}
	}

	private fun refreshPrayerTimesWidgets() {
		val mgr = AppWidgetManager.getInstance(this)
		val ids = mgr.getAppWidgetIds(ComponentName(this, PrayerTimesWidget::class.java))
		if (ids.isNotEmpty()) {
			PrayerTimesWidget().onUpdate(this, mgr, ids)
		}
	}

	private fun refreshPrayerTrackerWidgets() {
		val mgr = AppWidgetManager.getInstance(this)
		val ids = mgr.getAppWidgetIds(ComponentName(this, PrayerTrackerWidget::class.java))
		if (ids.isNotEmpty()) {
			PrayerTrackerWidget().onUpdate(this, mgr, ids)
		}
	}
}

private const val WIDGET_REFRESH_REQUEST_CODE = 9911

fun MainActivity.setupWidgetRefreshAlarm() {
	val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
	val intent = Intent(this, WidgetRefreshReceiver::class.java)
	val pi = PendingIntent.getBroadcast(
		this,
		WIDGET_REFRESH_REQUEST_CODE,
		intent,
		PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
	)
	// 15 dakikalık periyot - inexact repeating
	val interval = 15 * 60 * 1000L
	alarmManager.setInexactRepeating(
		AlarmManager.ELAPSED_REALTIME_WAKEUP,
		SystemClock.elapsedRealtime() + interval,
		interval,
		pi
	)
		// Additional minute-level alarm for countdown widget freshness
		val minuteIntent = Intent(this, PrayerWidgetRefreshReceiver::class.java).apply {
			putExtra("minute_tick", true)
		}
		val minutePending = PendingIntent.getBroadcast(this, 1002, minuteIntent, PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT)
		val now = System.currentTimeMillis()
		val nextMinute = now + (60_000L - (now % 60_000L))
		alarmManager.setRepeating(AlarmManager.RTC_WAKEUP, nextMinute, 60_000L, minutePending)
}
