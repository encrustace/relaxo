package `in`.encrust.relaxo

import android.app.*
import android.content.Context
import android.content.Intent
import android.media.AudioManager
import android.media.MediaPlayer
import android.os.Binder
import android.os.Handler
import android.os.HandlerThread
import android.os.IBinder
import android.telephony.PhoneStateListener
import kotlin.system.exitProcess

class AudioService : Service(), AudioManager.OnAudioFocusChangeListener {
    private val binder = LocalBinder()
    private var rainPlayer: MediaPlayer? = null
    private var rainVolume: String = "1.0"
    private var birdPlayer: MediaPlayer? = null
    private var birdVolume: String = "1.0"
    private var tentPlayer: MediaPlayer? = null
    private var tentVolume: String = "1.0"
    private var thunderPlayer: MediaPlayer? = null
    private var thunderVolume: String = "1.0"
    private var grassPlayer: MediaPlayer? = null
    private var grassVolume: String = "1.0"
    private var audioManager: AudioManager? = null
    private var wasRainPlaying = false
    private var wasBirdPlaying = false
    private var wasTentPlaying = false
    private var wasThunderPlaying = false
    private var wasGrassPlaying = false

    private  var timer = 0
    private val handler = Handler()

    private var notificationManager: NotificationManager? = null

    inner class LocalBinder : Binder() {
        fun getService(): AudioService = this@AudioService
    }

    override fun onBind(intent: Intent): IBinder? {
        return binder
    }

    override fun onCreate() {
        super.onCreate()
        initMediaPlayers()
        audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        audioManager?.requestAudioFocus(this, AudioManager.STREAM_MUSIC, AudioManager.AUDIOFOCUS_GAIN)
    }

    override fun onAudioFocusChange(focusChange: Int) {
        if (focusChange <=0){
            wasRainPlaying = isRainPlaying()
            wasBirdPlaying = isBirdPlaying()
            wasTentPlaying = isTentPlaying()
            wasThunderPlaying = isThunderPlaying()
            wasGrassPlaying = isGrassPlaying()
            if (isRainPlaying()) rainPlayer?.pause()
            if (isBirdPlaying()) birdPlayer?.pause()
            if (isTentPlaying()) tentPlayer?.pause()
            if (isThunderPlaying()) thunderPlayer?.pause()
            if (isGrassPlaying()) grassPlayer?.pause()
          //  deleteNotification()
        }else{
            if (wasRainPlaying){
                rainPlayer?.start()
                initNotification()
            }
            if (wasBirdPlaying){
                birdPlayer?.start()
                initNotification()
            }
            if (wasTentPlaying){
                tentPlayer?.start()
                initNotification()
            }
            if (wasThunderPlaying){
                thunderPlayer?.start()
                initNotification()
            }
            if (wasGrassPlaying){
                grassPlayer?.start()
                initNotification()
            }
        }
    }

    private fun initMediaPlayers() {
        rainPlayer = MediaPlayer.create(this, R.raw.rain_main)
        rainPlayer?.isLooping = true
        birdPlayer = MediaPlayer.create(this, R.raw.birds_main)
        birdPlayer?.isLooping = true
        tentPlayer = MediaPlayer.create(this, R.raw.rain_on_tent)
        tentPlayer?.isLooping = true
        thunderPlayer = MediaPlayer.create(this, R.raw.thunder)
        thunderPlayer?.isLooping = true
        grassPlayer = MediaPlayer.create(this, R.raw.rain_on_grass)
        grassPlayer?.isLooping = true
        createChannel()
    }

    fun rainPlayPause() {
        if (rainPlayer!!.isPlaying) {
            rainPlayer?.pause()
           // deleteNotification()
        } else {
            rainPlayer?.start()
            initNotification()
        }
    }

    fun birdPlayPause() {
        if (birdPlayer!!.isPlaying) {
            birdPlayer?.pause()
           // deleteNotification()
        } else {
            birdPlayer?.start()
            initNotification()
        }
    }

    fun tentPlayPause() {
        if (tentPlayer!!.isPlaying) {
            tentPlayer?.pause()
            //deleteNotification()
        } else {
            tentPlayer?.start()
            initNotification()
        }
    }
    fun thunderPlayPause() {
        if (thunderPlayer!!.isPlaying) {
            thunderPlayer?.pause()
            //deleteNotification()
        } else {
            thunderPlayer?.start()
            initNotification()
        }
    }
    fun grassPlayPause() {
        if (grassPlayer!!.isPlaying) {
            grassPlayer?.pause()
           // deleteNotification()
        } else {
            grassPlayer?.start()
            initNotification()
        }
    }

    fun isRainPlaying(): Boolean {
        return rainPlayer!!.isPlaying
    }

    fun isBirdPlaying(): Boolean {
        return birdPlayer!!.isPlaying
    }

    fun isTentPlaying(): Boolean {
        return tentPlayer!!.isPlaying
    }
    fun isThunderPlaying(): Boolean {
        return thunderPlayer!!.isPlaying
    }
    fun isGrassPlaying(): Boolean {
        return grassPlayer!!.isPlaying
    }

    fun setRainVolume(value: String) {
        rainPlayer!!.setVolume(value.toFloat(), value.toFloat())
        rainVolume = value
    }

    fun setBirdVolume(value: String) {
        birdPlayer!!.setVolume(value.toFloat(), value.toFloat())
        birdVolume = value
    }

    fun setTentVolume(value: String) {
        tentPlayer!!.setVolume(value.toFloat(), value.toFloat())
        tentVolume = value
    }
    fun setThunderVolume(value: String) {
        thunderPlayer!!.setVolume(value.toFloat(), value.toFloat())
        thunderVolume = value
    }
    fun setGrassVolume(value: String) {
        grassPlayer!!.setVolume(value.toFloat(), value.toFloat())
        grassVolume = value
    }

    fun getRainVolume(): String {
        return rainVolume
    }

    fun getBirdVolume(): String {
        return birdVolume
    }

    fun getTentVolume(): String {
        return tentVolume
    }
    fun getThunderVolume(): String {
        return thunderVolume
    }
    fun getGrassVolume(): String {
        return grassVolume
    }

    private fun createChannel(){
        val channel = NotificationChannel("nature", "Nature", NotificationManager.IMPORTANCE_LOW)
        notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager!!.createNotificationChannel(channel)

    }

    private fun initNotification() {
        val intent = Intent(this, MainActivity::class.java)
        intent.putExtra("", 0)
        val pendingIntent = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT)
        val notification = Notification.Builder(this, "nature")
                .setShowWhen(false)
                .setSmallIcon(android.R.drawable.ic_media_play)
                .setContentTitle("Playing")
                .setAutoCancel(false)
                .setOngoing(true)
                .setContentIntent(pendingIntent)
                .build()
        notificationManager?.notify(0, notification)
    }

     fun deleteNotification(){
        if (!isRainPlaying() && !isBirdPlaying() && !isThunderPlaying() && !isTentPlaying() && !isGrassPlaying()){
            notificationManager?.cancelAll()
        }

    }

    fun setTimer(t: String){
        timer = t.toInt()
        handler.post(object : Runnable{
            override fun run() {
                if (timer > 0){
                    timer--
                    handler.postDelayed(this, 1000)
                }else{
                    exitProcess(0)
                }
            }
        })
    }

    fun getTimer(): String{
        return timer.toString()
    }

    fun cancelTimer(){
        handler.removeCallbacksAndMessages(null)
    }

}