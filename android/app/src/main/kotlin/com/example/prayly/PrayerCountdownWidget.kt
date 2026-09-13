package com.example.prayly

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews
import java.util.Locale

class PrayerCountdownWidget : AppWidgetProvider() {

    companion object {
        const val ACTION_REFRESH = "com.example.prayly.widget.PRAYER_COUNTDOWN_REFRESH"
        fun updateAll(context: Context, manager: AppWidgetManager, ids: IntArray) {
            val provider = PrayerCountdownWidget()
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
            val ids = mgr.getAppWidgetIds(ComponentName(context, PrayerCountdownWidget::class.java))
            onUpdate(context, mgr, ids)
        }
    }
    private fun updateWidget(context: Context, manager: AppWidgetManager, id: Int) {
        val prefs: SharedPreferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val name = prefs.getString("flutter.widget_next_prayer_name", "...")
        val countdownSec = prefs.getInt("flutter.widget_next_prayer_countdown", -1)
        val line = if (countdownSec >= 0) {
            val h = countdownSec / 3600
            val m = (countdownSec % 3600) / 60
            val s = countdownSec % 60
            val base = if (h > 0) String.format(Locale.getDefault(), "%02d:%02d:%02d", h, m, s) else String.format(Locale.getDefault(), "%02d:%02d", m, s)
            "$name $base"
        } else "..."
        val views = RemoteViews(context.packageName, R.layout.widget_prayer_countdown)
        views.setTextViewText(R.id.countdown_line, line)
        val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
        val pLaunch = PendingIntent.getActivity(context, 201, launchIntent, PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT)
        views.setOnClickPendingIntent(R.id.countdown_line, pLaunch)
        manager.updateAppWidget(id, views)
    }
}
