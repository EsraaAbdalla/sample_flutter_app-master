import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_device/safe_device.dart';
import 'package:sample_flutter_app/main_screen.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isJailBroken = false;
  bool canMockLocation = false;
  bool isRealDevice = true;
  bool isOnExternalStorage = false;
  bool isSafeDevice = false;
  bool isEmulator = false;
  bool isDevelopmentModeEnable = false;
  @override
  void initState() {
    _protectDataLeakageOn();
    initPlatformState();

    super.initState();
  }

  Future<void> initPlatformState() async {
    await Permission.location.request();
    if (await Permission.location.isPermanentlyDenied) {
      openAppSettings();
    }

    if (!mounted) return;
    try {
      isJailBroken = await SafeDevice.isJailBroken;
      canMockLocation = await SafeDevice.canMockLocation;
      isRealDevice = await SafeDevice.isRealDevice;
      isOnExternalStorage = await SafeDevice.isOnExternalStorage;
      isSafeDevice = await SafeDevice.isSafeDevice;
      isEmulator = !isSafeDevice;
      isDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;
    } catch (error) {
      print(error);
    }

    setState(() {
      isJailBroken = isJailBroken;
      canMockLocation = canMockLocation;
      isRealDevice = isRealDevice;
      isOnExternalStorage = isOnExternalStorage;
      isSafeDevice = isSafeDevice;
      isEmulator = !isSafeDevice;
      isDevelopmentModeEnable = isDevelopmentModeEnable;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blue.shade700, // status bar color
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _buildMainContent(),
      navigatorObservers: [
        VdoPlayerController.navigatorObserver('/player/(.*)')
      ],
      theme: ThemeData(
          primaryColor: Colors.blue,
          textTheme: const TextTheme(bodyLarge: TextStyle(fontSize: 14.0))),
    );
  }

  Widget _buildMainContent() {
    if (isJailBroken ||
        isOnExternalStorage ||
        !isRealDevice ||
        !isDevelopmentModeEnable) {
      return _buildSecurityWarning();
    } else {
      return const MainScreen();
    }
  }

  Widget _buildSecurityWarning() {
    print("isJailBroken $isJailBroken");

    print("!isRealDevice${!isRealDevice}");

    print("isOnExternalStorage$isOnExternalStorage");

    print("isEmulator$isEmulator");

    print("isDevelopmentModeEnable$isDevelopmentModeEnable");

    return Stack(
      children: [
        // Blurred overlay
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
        const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'This option is not allowed for security reasons.',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _protectDataLeakageOn() async {
    if (Platform.isIOS) {
      final isRecording = await ScreenProtector.isRecording();
      print(isRecording);
      await ScreenProtector.preventScreenshotOn();
      await ScreenProtector.protectDataLeakageWithColor(Colors.pink);
    } else if (Platform.isAndroid) {
      await ScreenProtector.protectDataLeakageOn();
    }
  }

  @override
  void dispose() async {
    await ScreenProtector.protectDataLeakageOff();
    super.dispose();
  }
}
