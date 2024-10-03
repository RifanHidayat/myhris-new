package com.siscom.siscomhris

import io.flutter.embedding.android.FlutterActivity

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.os.Looper
import androidx.core.app.NotificationCompat
import com.google.android.gms.location.*
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Bundle
import android.util.Log

import android.location.Address
import android.location.Geocoder
import java.net.HttpURLConnection
import java.net.URL
import java.util.Locale

import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall

import io.flutter.plugins.GeneratedPluginRegistrant
import java.text.SimpleDateFormat
import java.util.*

class MainActivity: FlutterActivity() {
    private val CHANNEL_MOCK = "com.example.mocklocation/detect"
    private val CHANNEL_BACKGROUNDSERVICE = "com.example/backgroundservice"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_MOCK).setMethodCallHandler { call, result ->
            if (call.method == "checkMockLocation") {
                val isMockLocation = checkForMockLocation()
                result.success(isMockLocation)
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_BACKGROUNDSERVICE).setMethodCallHandler { call, result ->
            when (call.method) {
                "startService" -> {
                    val interval = (call.argument<Int>("interval") ?: 5000).toLong() // Default 5 seconds
                    val apiUrl = call.argument<String>("apiUrl")
                    val emId = call.argument<String>("emId")
                    val database = call.argument<String>("database")
                    val basicAuth = call.argument<String>("basicAuth")

                    val intent = Intent(this, LocationService::class.java)
                    intent.putExtra("interval", interval)
                    intent.putExtra("apiUrl", apiUrl)
                    intent.putExtra("emId", emId)
                    intent.putExtra("database", database)
                    intent.putExtra("basicAuth", basicAuth)

                    startService(intent)
                    result.success("Service Started")
                }
                "stopService" -> {
                    val intent = Intent(this, LocationService::class.java)
                    stopService(intent)
                    result.success("Service Stopped")
                }
                else -> result.notImplemented()
            }
        }
        
    }

    private fun checkForMockLocation(): Boolean {
        val locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager
        val lastLocation = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER)
        return lastLocation?.isFromMockProvider ?: false
    }
}

class LocationService : Service() {
    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private lateinit var locationCallback: LocationCallback
    private var interval: Long = 5000 // Default interval of 5 seconds
    private var apiUrl: String? = null
    private var tanggal: String? = null
    private var emId: String? = null
    private var waktu: String? = null
    private var database: String? = null
    private var basicAuth: String? = null

    override fun onCreate() {
        super.onCreate()

        // Initialize FusedLocationClient
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)

        // Define location callback
        locationCallback = object : LocationCallback() {
            override fun onLocationResult(locationResult: LocationResult) {
                val location = locationResult.lastLocation
                if (location != null) {
                    sendLocationToApi(location)
                    updateNotification()
                }
            }
        }
    }

    private fun sendLocationToFlutter(location: Location): Map<String, Double> {
        val locationData = mapOf("latitude" to location.latitude, "longitude" to location.longitude)

        val flutterEngine = FlutterEngine(this)
        flutterEngine.dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())

        val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example/backgroundservice/location_channel")

        methodChannel.invokeMethod("sendLocation", locationData)

        return locationData
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent == null) {
            Log.e("LocationService", "Intent is null!")
            return START_NOT_STICKY
        }

        // Ambil data dari intent dan log setiap nilai
        val newInterval = intent.getLongExtra("interval", -5L)
        apiUrl = intent.getStringExtra("apiUrl")
        emId = intent.getStringExtra("emId")
        database = intent.getStringExtra("database")
        basicAuth = intent.getStringExtra("basicAuth")

        if (newInterval != -5L) {
            interval = newInterval
        }

        startLocationUpdates()
        startForeground(888, createNotification())
        return START_STICKY
    }


    private fun sendLocationToApi(location: Location) {
        Thread {
            try {
                // Inisialisasi Geocoder
                val geocoder = Geocoder(this, Locale.getDefault())
                val addresses: MutableList<Address>? = geocoder.getFromLocation(location.latitude, location.longitude, 1)

                // Ambil alamat dengan aman
                val address = if (addresses != null && addresses.isNotEmpty()) {
                    addresses[0].getAddressLine(0) // Mengambil alamat lengkap
                } else {
                    "Alamat tidak ditemukan"
                }

                // Create JSON payload
                val dateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
                val timeFormat = SimpleDateFormat("HH:mm", Locale.getDefault())
                val jsonPayload = """
                    {
                        "tanggal": "${dateFormat.format(Date())}",
                        "em_id": "$emId",
                        "waktu": "${timeFormat.format(Date())}",
                        "longitude": "${location.longitude}",
                        "latitude": "${location.latitude}",
                        "alamat": "$address",
                        "database": "$database"
                    }
                """.trimIndent()

                // Log.d("LocationService", "JSON Payload: $jsonPayload")

                // Encode username and password to Base64 for Basic Auth
                // val auth = "$username:$password"
                // val encodedAuth = Base64.encodeToString(auth.toByteArray(), Base64.NO_WRAP)
                val authHeader = "$basicAuth"

                // Pastikan apiUrl tidak null
                apiUrl?.let {
                    // Create URL object
                    val url = URL(it)

                    // Open a connection
                    val urlConnection = url.openConnection() as HttpURLConnection
                    urlConnection.requestMethod = "POST"
                    urlConnection.setRequestProperty("Content-Type", "application/json")
                    urlConnection.setRequestProperty("Authorization", authHeader)
                    urlConnection.doOutput = true
                    
                    // Send the request
                    val outputStream = urlConnection.outputStream
                    outputStream.write(jsonPayload.toByteArray())
                    outputStream.flush()
                    outputStream.close()

                    // Check the response
                    val responseCode = urlConnection.responseCode
                    if (responseCode == HttpURLConnection.HTTP_OK) {
                        Log.d("LocationService", "Location sent successfully")
                    } else {
                        Log.d("LocationService", "Failed to send location. Response code: $responseCode")
                    }

                    urlConnection.disconnect()
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }.start()
    }



    private fun startLocationUpdates() {
        val locationRequest = LocationRequest.create().apply {
            interval = this@LocationService.interval
            fastestInterval = this@LocationService.interval
            priority = LocationRequest.PRIORITY_HIGH_ACCURACY
        }

        fusedLocationClient.requestLocationUpdates(locationRequest, locationCallback, Looper.getMainLooper())
    }

    private fun updateNotification() {
        val notification = createNotification()
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.notify(888, notification)
    }

    private fun createNotification(): Notification {
        val date = SimpleDateFormat("dd MMMM yyyy, HH:mm:ss", Locale.getDefault()).format(Date())

        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, PendingIntent.FLAG_IMMUTABLE)

        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel("location_service", "Lokasi Service", NotificationManager.IMPORTANCE_LOW)
            notificationManager.createNotificationChannel(channel)
        }

        return NotificationCompat.Builder(this, "location_service")
            .setContentTitle("Tracking Lokasi")
            .setContentText("Tanggal: $date")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .build()
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onDestroy() {
        super.onDestroy()
        fusedLocationClient.removeLocationUpdates(locationCallback)
    }
}
