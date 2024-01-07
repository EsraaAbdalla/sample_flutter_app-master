// ignore_for_file: avoid_print, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:presentation_displays/displays_manager.dart';
import 'package:sample_flutter_app/my_home.dart';
import 'package:screen_capture_event/screen_capture_event.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ScreenCaptureEvent screenCaptureEvent = ScreenCaptureEvent();
  Future<void> _getDisplayInfo(BuildContext context) async {
    final displayManager = DisplayManager();
    final displays = await displayManager.getDisplays();
    print("Number of displays: ${displays!.length}");

    if (displays.length > 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EmptyPage()),
      );
    }
  }

  @override
  void initState() {
    // Example usage
    void someFunction(BuildContext context) {
      _getDisplayInfo(context);
    }

    someFunction(context);
    // _getDisplayInfo();
    screenCaptureEvent.addScreenShotListener((filePath) {
      print("ScreenShot!");
    });

    screenCaptureEvent.preventAndroidScreenShot(true);
    //when user Start recording => value of recorded will be true then navigate to EmptyPage
    screenCaptureEvent.watch();

    screenCaptureEvent.addScreenRecordListener((recorded) {
      if (recorded) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EmptyPage()),
        );
      }
    });

    screenCaptureEvent.addScreenRecordListener((recorded) {
      print(recorded ? "Start Recording" : "Stop Recording");
      print("recorded $recorded");
    });
    super.initState();
  }

  @override
  void dispose() {
    screenCaptureEvent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const MyHome();
  }
}

class EmptyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Text(
              'Screen Recording Is Not Allow In Our Application',
              style: TextStyle(fontSize: 20),
            )
          ])),
    );
  }
}
