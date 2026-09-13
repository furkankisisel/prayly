package com.example.prayly

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.appwidget.AppWidgetManager
import android.content.ComponentName

class WidgetRefreshReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val mgr = AppWidgetManager.getInstance(context)
        val ids1 = mgr.getAppWidgetIds(ComponentName(context, PrayerTimesWidget::class.java))
        if (ids1.isNotEmpty()) PrayerTimesWidget().onUpdate(context, mgr, ids1)
        val ids2 = mgr.getAppWidgetIds(ComponentName(context, PrayerTrackerWidget::class.java))
        if (ids2.isNotEmpty()) PrayerTrackerWidget().onUpdate(context, mgr, ids2)
    }
}