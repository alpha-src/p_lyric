package com.foundy.p_lyric

import android.content.Context
import android.content.Intent
import android.os.Bundle
import com.gomes.nowplaying.FloatingWindowService
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setAppVisibleKey(true)
    }

    override fun onResume() {
        super.onResume()
        setAppVisibleKey(true)

        stopService(Intent(context, FloatingWindowService::class.java))
    }

    override fun onPause() {
        super.onPause()
        setAppVisibleKey(false)
    }

    private fun setAppVisibleKey(state: Boolean) {
        val prefs = context.getSharedPreferences(FloatingWindowService.SHARED_PREFS_KEY, Context.MODE_PRIVATE)
        prefs.edit().putBoolean(FloatingWindowService.IS_APP_VISIBLE_KEY, state).apply()
    }
}