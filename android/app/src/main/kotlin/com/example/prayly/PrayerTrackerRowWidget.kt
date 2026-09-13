package com.example.prayly

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews

class PrayerTrackerRowWidget : AppWidgetProvider() {

    companion object {
        const val ACTION_REFRESH = "com.example.prayly.widget.PRAYER_TRACKER_ROW_REFRESH"
        fun updateAll(context: Context, manager: AppWidgetManager, ids: IntArray) {
            val provider = PrayerTrackerRowWidget()
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
            val ids = mgr.getAppWidgetIds(ComponentName(context, PrayerTrackerRowWidget::class.java))
            onUpdate(context, mgr, ids)
        }
    }
    private fun statusSymbol(code: String?): String = when (code) {
        "kilindi" -> "✔"
        "cemaat" -> "👥"
        "kaza" -> "↻"
        else -> "-"
    }
    private fun updateWidget(context: Context, manager: AppWidgetManager, id: Int) {
        val prefs: SharedPreferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val views = RemoteViews(context.packageName, R.layout.widget_prayer_tracker_row)
        val statuses = prefs.getString("flutter.widget_tracker_statuses", null)?.split("|") ?: emptyList()
        fun statusChar(index: Int): Pair<String, Int> {
            return statuses.getOrNull(index)?.let {
                when (it) {
                    "done" -> "✔" to 0xFF4CAF50.toInt()
                    "jamaat" -> "👥" to 0xFF42A5F5.toInt()
                    "retry" -> "↻" to 0xFFFFC107.toInt()
                    else -> "-" to 0xFFFFFFFF.toInt()
                }
            } ?: ("-" to 0xFFFFFFFF.toInt())
        }
        val idPairs = listOf(
            R.id.track_sabah to "S:",
            R.id.track_ogle to "Ö:",
            R.id.track_ikindi to "İ:",
            R.id.track_aksam to "A:",
            R.id.track_yatsi to "Y:",
        )
        idPairs.forEachIndexed { idx, (viewId, prefix) ->
            val (symbol, color) = statusChar(idx)
            views.setTextViewText(viewId, prefix + symbol)
            views.setTextColor(viewId, color)
        }
        val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
        val pLaunch = PendingIntent.getActivity(context, 202, launchIntent, PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT)
            views.setOnClickPendingIntent(R.id.root_row_tracker, pLaunch)
        manager.updateAppWidget(id, views)
    }
}
