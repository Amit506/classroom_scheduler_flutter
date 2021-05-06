package com.example.classroom_scheduler_flutter

import android.content.Context
import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.provider.Settings


class MainActivity: FlutterActivity() {
    private val mContext: Context? = context;
    private val CHANNEL = "settings"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {

            call, result ->
            if (call.method == "notification_channel") {
                val chanId = call.argument<String>("chanId")

                 openAppNotificationSettings(chanId)


            } else {

                result.notImplemented()
            }

        }

    }
    private fun openAppNotificationSettings(chanId:String?) {
        val intent = Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS)
        intent.putExtra(Settings.EXTRA_APP_PACKAGE, mContext!!.packageName)
//        intent.putExtra(Settings.EXTRA_CHANNEL_ID, chanId)

        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        mContext!!.startActivity(intent)
    }
}
