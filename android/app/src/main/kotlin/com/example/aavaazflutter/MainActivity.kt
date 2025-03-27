package com.example.aavaazflutter

import android.Manifest
import android.content.pm.PackageManager
import android.media.MediaPlayer
import android.media.MediaRecorder
import android.os.Build
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.IOException

class MainActivity : FlutterActivity() {
    private val CHANNEL = "audio_recorder"
    private var mediaRecorder: MediaRecorder? = null
    private var mediaPlayer: MediaPlayer? = null
    private var filePath: String = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Initialize Flutter MethodChannel
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startRecording" -> {
                    if (checkPermissions()) {
                        startRecording(result)
                    } else {
                        result.error("PERMISSION_DENIED", "Microphone permission denied", null)
                    }
                }
                "stopRecording" -> stopRecording(result)
                "playRecording" -> playRecording(result)
                else -> result.notImplemented()
            }
        }
    }

    // Request and check microphone permission
    private fun checkPermissions(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (checkSelfPermission(Manifest.permission.RECORD_AUDIO) != PackageManager.PERMISSION_GRANTED) {
                requestPermissions(arrayOf(Manifest.permission.RECORD_AUDIO), 200)
                return false
            }
        }
        return true
    }

    // Start recording
    private fun startRecording(result: MethodChannel.Result) {
        try {
            filePath = "${externalCacheDir?.absolutePath}/recording.mp3"

            mediaRecorder = MediaRecorder().apply {
                setAudioSource(MediaRecorder.AudioSource.MIC)
                setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
                setAudioEncoder(MediaRecorder.AudioEncoder.AAC)
                setOutputFile(filePath)
                prepare()
                start()
            }

            Log.d("AudioRecorder", "Recording started: $filePath")
            result.success("Recording started")
        } catch (e: Exception) {
            result.error("RECORDING_FAILED", "Failed to start recording", e.localizedMessage)
            Log.e("AudioRecorder", "Error starting recording: ${e.localizedMessage}")
        }
    }

    // Stop recording
    private fun stopRecording(result: MethodChannel.Result) {
        try {
            mediaRecorder?.apply {
                stop()
                release()
            }
            mediaRecorder = null

            Log.d("AudioRecorder", "Recording stopped: $filePath")
            result.success("Recording stopped")
        } catch (e: Exception) {
            result.error("STOP_FAILED", "Failed to stop recording", e.localizedMessage)
            Log.e("AudioRecorder", "Error stopping recording: ${e.localizedMessage}")
        }
    }

    // Play recorded audio
    private fun playRecording(result: MethodChannel.Result) {
        val audioFile = File(filePath)

        if (audioFile.exists()) {
            try {
                mediaPlayer = MediaPlayer().apply {
                    setDataSource(filePath)
                    prepare()
                    start()
                }

                Log.d("AudioRecorder", "Playing recording: $filePath")
                result.success("Playing recording")
            } catch (e: IOException) {
                result.error("PLAY_FAILED", "Failed to play recording", e.localizedMessage)
                Log.e("AudioRecorder", "Error playing recording: ${e.localizedMessage}")
            }
        } else {
            result.error("FILE_NOT_FOUND", "Recording file does not exist", null)
            Log.e("AudioRecorder", "File not found: $filePath")
        }
    }

        // stop playing
        private fun stopPlayRecording(result: MethodChannel.Result) {
        try {
            mediaPlayer?.apply {
                if (isPlaying) {
                    stop()
                    release()
                }
            }
            mediaPlayer = null

            Log.d("AudioRecorder", "Playback stopped")
            result.success("Playback stopped")
        } catch (e: Exception) {
            result.error("STOP_PLAY_FAILED", "Failed to stop playback", e.localizedMessage)
            Log.e("AudioRecorder", "Error stopping playback: ${e.localizedMessage}")
        }
    }

}
