package com.example.prayly

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.os.Bundle
import java.util.*
import android.content.SharedPreferences

class PrayerTrackerWidget : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (id in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, id)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == ACTION_REFRESH) {
            val mgr = AppWidgetManager.getInstance(context)
            val ids = mgr.getAppWidgetIds(ComponentName(context, PrayerTrackerWidget::class.java))
            onUpdate(context, mgr, ids)
        }
    }

    private fun updateAppWidget(context: Context, manager: AppWidgetManager, appWidgetId: Int) {
        val options: Bundle? = manager.getAppWidgetOptions(appWidgetId)
        val minWidth = options?.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH) ?: 0
        val minHeight = options?.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT) ?: 0
        val layoutId = when {
            minWidth >= 250 && minHeight >= 170 -> R.layout.widget_prayer_tracker_large
            minWidth >= 180 && minHeight >= 120 -> R.layout.widget_prayer_tracker_medium
            else -> R.layout.widget_prayer_tracker_small
        }
        val views = RemoteViews(context.packageName, layoutId)
        // Placeholder: show 0/5. Later read SharedPreferences for persisted day statuses.
        val prefs: SharedPreferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val completed = prefs.getInt("flutter.widget_tracker_completed", 0)
        val total = prefs.getInt("flutter.widget_tracker_total", 5)
        val first = prefs.getString("flutter.widget_tracker_first", "Sabah")
        val status = prefs.getString("flutter.widget_tracker_first_status", "none")
        val statusLabel = when (status) {
            "kilindi" -> "Kıldı"
            "cemaat" -> "Cemaat"
            "kaza" -> "Kaza"
            else -> "-"
        }
        views.setTextViewText(R.id.txt_day_progress, "$completed/$total")
        if (layoutId == R.layout.widget_prayer_tracker_small) {
            views.setTextViewText(R.id.txt_detail, "$first: $statusLabel")
        } else {
            val containerId = R.id.list_statuses
            val names = listOf("Sabah","Öğle","İkindi","Akşam","Yatsı")
            views.removeAllViews(containerId)
            for (n in names) {
                val stat = prefs.getString("flutter.tracker_status_$n", "none") ?: "none"
                val label = when (stat) {
                    "kilindi" -> "✔"
                    "cemaat" -> "👥"
                    "kaza" -> "↻"
                    else -> "-"
                }
                val row = RemoteViews(context.packageName, android.R.layout.simple_list_item_1)
                row.setTextViewText(android.R.id.text1, "$n: $label")
                views.addView(containerId, row)
            }
        }

        val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
        val pLaunch = PendingIntent.getActivity(context, 1, launchIntent, PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT)
        views.setOnClickPendingIntent(R.id.txt_day_progress, pLaunch)
    // (Optional) removed refresh broadcast pending intent to keep launch action
        manager.updateAppWidget(appWidgetId, views)
    }

    companion object {
        const val ACTION_REFRESH = "com.example.prayly.widget.PRAYER_TRACKER_REFRESH"
        fun updateAll(context: Context, manager: AppWidgetManager, ids: IntArray) {
            val provider = PrayerTrackerWidget()
            for (id in ids) provider.updateAppWidget(context, manager, id)
        }
    }
}
