package com.example.prayly

import android.appwidget.AppWidgetManager
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent

class PrayerWidgetRefreshReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        // Delegate to existing providers to force update (main snapshot already in SharedPreferences)
        val manager = AppWidgetManager.getInstance(context)
        val classes = listOf(
            PrayerTimesRowWidget::class.java,
            PrayerCountdownWidget::class.java,
            PrayerTrackerRowWidget::class.java,
            PrayerTimesWidget::class.java,
            PrayerTrackerWidget::class.java,
        )
        for (cls in classes) {
            val ids = manager.getAppWidgetIds(ComponentName(context, cls))
            if (ids.isNotEmpty()) {
                try {
                    when (cls) {
                        PrayerTimesRowWidget::class.java -> PrayerTimesRowWidget.updateAll(context, manager, ids)
                        PrayerCountdownWidget::class.java -> PrayerCountdownWidget.updateAll(context, manager, ids)
                        PrayerTrackerRowWidget::class.java -> PrayerTrackerRowWidget.updateAll(context, manager, ids)
                        PrayerTimesWidget::class.java -> PrayerTimesWidget.updateAll(context, manager, ids)
                        PrayerTrackerWidget::class.java -> PrayerTrackerWidget.updateAll(context, manager, ids)
                    }
                } catch (_: Exception) {}
            }
        }
    }
}