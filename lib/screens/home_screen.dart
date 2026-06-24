import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _toggleOverlay(BuildContext context) async {
    bool hasPermission = await FlutterOverlayWindow.isPermissionGranted();

    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please grant "Display over other apps" permission.')),
      );
      await FlutterOverlayWindow.requestPermission();
    } else {
      await FlutterOverlayWindow.showOverlay(
        enableDrag: true,
        // Using focusable or specific interaction flags ensures it floats securely over lock layers
        flag: OverlayFlag.clickThrough, 
        alignment: OverlayAlignment.center,
        // Forces the overlay to remain visible on secure public screens (Lockscreen)
        visibility: NotificationVisibility.visibilityPublic,
        height: 150, 
        width: 950, 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Android Overlay Controller'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => _toggleOverlay(context),
          icon: const Icon(Icons.power_settings_new),
          label: const Text('Launch Floating Bar'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}