package com.example.prayly

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.SystemClock
import android.widget.RemoteViews
import android.os.Bundle
import java.text.SimpleDateFormat
import java.util.*
import android.content.SharedPreferences

class PrayerTimesWidget : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (id in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, id)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == ACTION_REFRESH) {
            val mgr = AppWidgetManager.getInstance(context)
            val ids = mgr.getAppWidgetIds(ComponentName(context, PrayerTimesWidget::class.java))
            onUpdate(context, mgr, ids)
        }
    }

    private fun updateAppWidget(context: Context, manager: AppWidgetManager, appWidgetId: Int) {
        val options: Bundle? = manager.getAppWidgetOptions(appWidgetId)
        val minWidth = options?.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH) ?: 0
        val minHeight = options?.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT) ?: 0
        val layoutId = when {
            minWidth >= 250 && minHeight >= 170 -> R.layout.widget_prayer_times_large
            minWidth >= 180 && minHeight >= 120 -> R.layout.widget_prayer_times_medium
            else -> R.layout.widget_prayer_times_small
        }
        val views = RemoteViews(context.packageName, layoutId)
        // Placeholder demo: show time now; in real integration read SharedPreferences cached next prayer & countdown
        val prefs: SharedPreferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val name = prefs.getString("flutter.widget_next_prayer_name", "...")
        val timeIso = prefs.getString("flutter.widget_next_prayer_time", null)
        val countdownSec = prefs.getInt("flutter.widget_next_prayer_countdown", -1)
        val sdf = SimpleDateFormat("HH:mm", Locale.getDefault())
        val timeDisplay = timeIso?.let {
            // Expect ISO string; extract HH:MM safely
            val tIndex = it.indexOf('T')
            if (tIndex > 0 && it.length >= tIndex + 6) {
                it.substring(tIndex + 1, tIndex + 6)
            } else "--:--"
        } ?: "--:--"
        val cdDisplay = if (countdownSec >= 0) {
            val h = countdownSec / 3600
            val m = (countdownSec % 3600) / 60
            val s = countdownSec % 60
            if (h > 0) String.format(Locale.getDefault(), "%02d:%02d:%02d", h, m, s) else String.format(Locale.getDefault(), "%02d:%02d", m, s)
        } else "--:--"
        views.setTextViewText(R.id.txt_next_prayer, "Sonraki: $name $timeDisplay")
        views.setTextViewText(R.id.txt_countdown, cdDisplay)

        // Populate list of today prayer times if medium/large
        if (layoutId != R.layout.widget_prayer_times_small) {
            val listContainerId = R.id.list_times
            val listRaw = prefs.getString("flutter.widget_prayer_times_list", null)
            val items = listRaw?.split(';')?.mapNotNull { seg ->
                val parts = seg.split('|')
                if (parts.size == 2) parts[0] + ": " + parts[1] else null
            } ?: emptyList()
            views.removeAllViews(listContainerId)
            for (line in items) {
                val rvLine = RemoteViews(context.packageName, android.R.layout.simple_list_item_1)
                rvLine.setTextViewText(android.R.id.text1, line)
                views.addView(listContainerId, rvLine)
            }
        }

        // Click opens app
        val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
        val pLaunch = PendingIntent.getActivity(context, 0, launchIntent, PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT)
        views.setOnClickPendingIntent(R.id.txt_next_prayer, pLaunch)
        views.setOnClickPendingIntent(R.id.txt_countdown, pLaunch)

    // (Optional) refresh action removed to avoid overriding launch intent
        manager.updateAppWidget(appWidgetId, views)
    }

    companion object {
        const val ACTION_REFRESH = "com.example.prayly.widget.PRAYER_TIMES_REFRESH"
        fun updateAll(context: Context, manager: AppWidgetManager, ids: IntArray) {
            val provider = PrayerTimesWidget()
            for (id in ids) provider.updateAppWidget(context, manager, id)
        }
    }
}
