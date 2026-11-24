package com.wms.wms_new;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Build;
import android.os.Bundle;
import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

import java.util.HashMap;
import java.util.Map;

public class MainActivity extends FlutterActivity {
    private static final String EVENT_CHANNEL = "com.wms.scanner/events";
    private static final String METHOD_CHANNEL = "com.wms.scanner/methods";

    private EventChannel.EventSink eventSink;
    private BroadcastReceiver scanReceiver;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        // Setup EventChannel for streaming scanner intents to Flutter
        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), EVENT_CHANNEL)
            .setStreamHandler(new EventChannel.StreamHandler() {
                @Override
                public void onListen(Object arguments, EventChannel.EventSink events) {
                    eventSink = events;
                    registerScanReceiver();
                }

                @Override
                public void onCancel(Object arguments) {
                    unregisterScanReceiver();
                    eventSink = null;
                }
            });

        // Setup MethodChannel for DataWedge / Scanner Commands
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), METHOD_CHANNEL)
            .setMethodCallHandler((call, result) -> {
                if (call.method.equals("sendDataWedgeCommand")) {
                    String command = call.argument("command");
                    String parameter = call.argument("parameter");
                    sendDataWedgeIntent(command, parameter);
                    result.success(true);
                } else if (call.method.equals("triggerSoftScan")) {
                    triggerZebraSoftScan();
                    result.success(true);
                } else {
                    result.notImplemented();
                }
            });
    }

    private void registerScanReceiver() {
        if (scanReceiver != null) return;

        scanReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                if (eventSink == null) return;

                String action = intent.getAction();
                String barcodeData = null;
                String symbology = "UNKNOWN";
                String source = "Hardware Laser";

                if (action == null) return;

                // 1. Zebra DataWedge Broadcast Intents
                if (action.equals("com.symbol.datawedge.api.RESULT_ACTION") ||
                    action.equals("com.wms.SCAN_BROADCAST") ||
                    action.equals("com.zebra.action.BARCODE_SCAN")) {

                    source = "Zebra DataWedge";
                    if (intent.hasExtra("com.symbol.datawedge.data_string")) {
                        barcodeData = intent.getStringExtra("com.symbol.datawedge.data_string");
                    } else if (intent.hasExtra("data")) {
                        barcodeData = intent.getStringExtra("data");
                    }

                    if (intent.hasExtra("com.symbol.datawedge.label_type")) {
                        symbology = intent.getStringExtra("com.symbol.datawedge.label_type");
                    }
                }
                // 2. Honeywell Broadcast Intents
                else if (action.equals("com.honeywell.decode.intent.action.SCAN_RESULT") ||
                         action.equals("com.honeywell.scan.broadcast")) {

                    source = "Honeywell Scanner";
                    if (intent.hasExtra("barcodeData")) {
                        barcodeData = intent.getStringExtra("barcodeData");
                    } else if (intent.hasExtra("data")) {
                        barcodeData = intent.getStringExtra("data");
                    }

                    if (intent.hasExtra("codeId")) {
                        symbology = intent.getStringExtra("codeId");
                    }
                }
                // 3. Generic Android Scan Intent
                else if (intent.hasExtra("scanData")) {
                    barcodeData = intent.getStringExtra("scanData");
                    source = "Generic Intent";
                }

                if (barcodeData != null && !barcodeData.isEmpty()) {
                    Map<String, String> payload = new HashMap<>();
                    payload.put("barcode", barcodeData.trim());
                    payload.put("symbology", symbology != null ? symbology : "UNKNOWN");
                    payload.put("source", source);
                    payload.put("timestamp", String.valueOf(System.currentTimeMillis()));

                    eventSink.success(payload);
                }
            }
        };

        IntentFilter filter = new IntentFilter();
        // Zebra Actions
        filter.addAction("com.symbol.datawedge.api.RESULT_ACTION");
        filter.addAction("com.wms.SCAN_BROADCAST");
        filter.addAction("com.zebra.action.BARCODE_SCAN");
        // Honeywell Actions
        filter.addAction("com.honeywell.decode.intent.action.SCAN_RESULT");
        filter.addAction("com.honeywell.scan.broadcast");
        // Generic Actions
        filter.addAction("android.intent.action.SCAN_RESULT");

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(scanReceiver, filter, Context.RECEIVER_EXPORTED);
        } else {
            registerReceiver(scanReceiver, filter);
        }
    }

    private void unregisterScanReceiver() {
        if (scanReceiver != null) {
            try {
                unregisterReceiver(scanReceiver);
            } catch (Exception e) {
                // Receiver was not registered
            }
            scanReceiver = null;
        }
    }

    private void sendDataWedgeIntent(String command, String parameter) {
        Intent i = new Intent();
        i.setAction("com.symbol.datawedge.api.ACTION");
        i.putExtra(command, parameter);
        sendBroadcast(i);
    }

    private void triggerZebraSoftScan() {
        Intent i = new Intent();
        i.setAction("com.symbol.datawedge.api.ACTION");
        i.putExtra("com.symbol.datawedge.api.SOFT_SCAN_TRIGGER", "TOGGLE_SCANNING");
        sendBroadcast(i);
    }

    @Override
    protected void onDestroy() {
        unregisterScanReceiver();
        super.onDestroy();
    }
}
