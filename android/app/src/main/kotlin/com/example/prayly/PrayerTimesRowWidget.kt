package com.example.prayly

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews

class PrayerTimesRowWidget : AppWidgetProvider() {

    companion object {
        const val ACTION_REFRESH = "com.example.prayly.widget.PRAYER_TIMES_ROW_REFRESH"
        fun updateAll(context: Context, manager: AppWidgetManager, ids: IntArray) {
            val provider = PrayerTimesRowWidget()
            for (id in ids) provider.updateWidget(context, manager, id)
        }
    }

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (id in appWidgetIds) updateWidget(context, appWidgetManager, id)
    }
    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == ACTION_REFRESH) {
            val mgr = AppWidgetManager.getInstance(context)
            val ids = mgr.getAppWidgetIds(ComponentName(context, PrayerTimesRowWidget::class.java))
            onUpdate(context, mgr, ids)
        }
    }
    private fun updateWidget(context: Context, manager: AppWidgetManager, id: Int) {
        val prefs: SharedPreferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val listRaw = prefs.getString("flutter.widget_prayer_times_list", null)
        val pairs = listRaw?.split(';')?.mapNotNull { seg ->
            val p = seg.split('|'); if (p.size == 2) p[0] to p[1] else null
        } ?: emptyList()
        val views = RemoteViews(context.packageName, R.layout.widget_prayer_times_row)
        val nextName = prefs.getString("flutter.widget_next_prayer_name", null)
        fun findTime(name: String) = pairs.firstOrNull { it.first == name }?.second ?: "--:--"
        val labels = listOf(
            R.id.row_sabah to ("Sab " to "Sabah"),
            R.id.row_ogle to ("Öğl " to "Öğle"),
            R.id.row_ikindi to ("İkn " to "İkindi"),
            R.id.row_aksam to ("Aks " to "Akşam"),
            R.id.row_yatsi to ("Yts " to "Yatsı"),
        )
        for ((viewId, pair) in labels) {
            val short = pair.first
            val full = pair.second
            val time = findTime(full)
            val text = "$short$time"
            views.setTextViewText(viewId, text)
            if (full == nextName) {
                // accent color
                views.setTextColor(viewId, 0xFFC79A32.toInt())
            } else {
                views.setTextColor(viewId, 0xFFFFFFFF.toInt())
            }
        }
        val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
        val pLaunch = PendingIntent.getActivity(context, 200, launchIntent, PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT)
        views.setOnClickPendingIntent(R.id.root_row_times, pLaunch)
        manager.updateAppWidget(id, views)
    }
}
